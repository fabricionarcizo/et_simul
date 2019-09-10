function cc_triang=estimate_cc_hennessey(c, l, cr, r_cornea_assumed)
%  estimate_cc_hennessey  Estimates pos. of cornea center (Hennessey's method)
%    cc_triang = estimate_cc_hennessey(c, l, cr, r_cornea_assumed) estimates
%    position of the cornea center (returned in 'cc_triang') for a camera
%    object 'c', a cell array 'l' of light sources, a cell array 'cr' with the
%    positions of the corresponding corneal reflexes observed in the camera
%    image and an assumed corneal radius of 'r_cornea_assumed'. If no corneal
%    radius is given, a default value of 7.98 mm is used. The function uses
%    the algorithm from [1].
%
%    [1] Craig Hennessey, Borna Noureddin, Peter Lawrence. A Single Camera
%        Eye-Gaze Tracking System with Free Head Motion. ETRA 2006.

%    Copyright 2008 Martin Böhme and the University of Lübeck
%
%    This file is part of et_simul.
%
%    et_simul is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License (version 3) as
%    published by the Free Software Foundation.
%
%    et_simul is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    (version 3) along with et_simul in a file called 'COPYING'. If not, see
%    <http://www.gnu.org/licenses/>.

    if nargin<4
        r_cornea_assumed=7.98e-3;
    end

    num_lights=length(l);

    % For all corneal reflexes
    for j=1:num_lights
        % Compute vector to CR
        cr_hat=camera_unproject(c, cr{j}, 1);
        cr_vec=cr_hat-c.trans(:,4);
        cr_vec=cr_vec/norm(cr_vec);

        % Compute vector to light
        l_vec=l{j}.pos-c.trans(:,4);

        % Define auxiliary coordinate system
        X=l_vec/norm(l_vec);
        Z=cr_vec-X*(cr_vec'*X);
        Z=Z/norm(Z);
        Y=[cross(X(1:3), Z(1:3)); 0];
        params.R{j}=[X Y Z c.trans(:,4)];

        % Compute other required quantities
        params.alpha(j)=acos(l_vec'*cr_vec/norm(l_vec));
        params.l(j)=norm(l_vec);

        gx_start(j)=norm(l_vec)/2;
    end

    params.r_cornea=r_cornea_assumed;

    options=optimset('fminsearch');
    options.TolFun=1e-8;
    gx_min=fminsearch(@(gx) objective_func(params, gx), gx_start, options);

    [err, cc]=objective_func(params, gx_min);
    
    cc_triang=mean(cc, 2);

function [val, cc]=objective_func(params, gx)
    num_lights=length(gx);

    cc=zeros(4, num_lights);

    for j=1:num_lights
        beta=atan(gx(j)*tan(params.alpha(j))/(params.l(j)-gx(j)));
        
        cx=gx(j)-params.r_cornea*sin((params.alpha(j)-beta)/2);
        cz=gx(j)*tan(params.alpha(j)) + ...
            params.r_cornea*cos((params.alpha(j)-beta)/2);

        cc(:,j)=params.R{j} * [cx; 0; cz; 1];
    end

    val=norm(cc(:,1)-cc(:,2));
