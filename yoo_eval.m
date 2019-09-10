function gaze=yoo_eval(et, camimg, e)
%  yoo_eval  Evaluation function for Yoo and Chung's method

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

    % Pan and tilt camera towards eye
    cameras{1}=camera_pan_tilt(et.cameras{1}, ...
        camera_unproject(et.cameras{1}, camimg{1}.cr{5}, 1));

    % Recapture image
    camimg{1}=camera_take_image(et.cameras{1}, e, et.lights);

    % Rename our CRs according to Yoo and Chung's nomenclature
    r=[camimg{1}.cr{1}, camimg{1}.cr{2} camimg{1}.cr{3} camimg{1}.cr{4}];
    c=camimg{1}.cr{5};
    p=camimg{1}.pc;

    % Find "virtual projection points"
    v=zeros(size(r));
    for i=1:4
        v(:,i)=c + et.state.alpha(i)*(r(:,i)-c);
    end

    % Compute point e ("center of screen")
    e=line_intersect_2d(v(:,1), v(:,3), v(:,2), v(:,4));

    m=zeros(2,4);

    % Compute m1 and m2
    vanish=line_intersect_2d(v(:,1), v(:,4), v(:,2), v(:,3));
    m(:,1)=line_intersect_2d(vanish, e, v(:,1), v(:,2));
    m(:,2)=line_intersect_2d(vanish, p, v(:,1), v(:,2));

    % Compute m3 and m4
    vanish=line_intersect_2d(v(:,1), v(:,2), v(:,3), v(:,4));
    m(:,3)=line_intersect_2d(vanish, p, v(:,2), v(:,3));
    m(:,4)=line_intersect_2d(vanish, e, v(:,2), v(:,3));

    % Compute cross ratios
    vx=v(1,:);
    vy=v(2,:);
    mx=m(1,:);
    my=m(2,:);
    cross_x=(vx(1)*my(1) - mx(1)*vy(1))*(mx(2)*vy(2) - vx(2)*my(2)) / ...
        ( (vx(1)*my(2) - mx(2)*vy(1))*(mx(1)*vy(2) - vx(2)*my(1)) );
    cross_y=(vx(2)*my(3) - mx(3)*vy(2))*(mx(4)*vy(3) - vx(3)*my(4)) / ...
        ( (vx(2)*my(4) - mx(4)*vy(2))*(mx(3)*vy(3) - vx(3)*my(3)) );

    % Compute gaze position
    xg=-200e-3 + cross_x/(1+cross_x)*400e-3;
    yg=350e-3 + cross_y/(1+cross_y)*(-300e-3);

    gaze=[xg yg]';

    % Visualize
    if 0
        plot(r(1,:), r(2,:), 'bx');
        hold on;
        plot(c(1), c(2), 'kx');
        plot(v(1,:), v(2,:), 'rx');
        plot(p(1), p(2), 'ko');
        plot(e(1), e(2), 'k+');
        plot(m(1,:), m(2,:), 'k+');
        hold off;

        pause;
    end
