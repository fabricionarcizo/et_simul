function [pos, pos2]=intersect_ray_sphere(R0, Rd, S0, Sr)
%  intersect_ray_sphere  Finds intersection between ray and sphere
%    [pos, pos2] = intersect_ray_sphere(R0, Rd, S0, Sr) finds the intersection
%    between a ray (specified by its origin 'R0' and direction 'Rd') and a 
%    sphere (center 'S0' and radius 'Sr'). The intersection that is closer to
%    'R0' is returned in 'pos', and the other intersection is returned in
%    'pos2'. [] is returned for 'pos' and 'pos2' if the ray does not intersect
%    the sphere.
%
%    3D or homogeneous coordinates may be passed in; the same type of
%    coordinates is passed out.

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

    % Normalize direction of ray
    Rd=Rd/norm(Rd);

    b=2*(Rd(1)*(R0(1)-S0(1)) + Rd(2)*(R0(2)-S0(2)) + Rd(3)*(R0(3)-S0(3)));
    c=(R0(1)-S0(1))^2 + (R0(2)-S0(2))^2 + (R0(3)-S0(3))^2 - Sr^2;

    disc=b^2-4*c;
    if(disc<0)
        pos=[];
        pos2=[];
    else
        t1=(-b+sqrt(disc))/2;
        t2=(-b-sqrt(disc))/2;
        if(abs(t1)<abs(t2))
            t=t1;
            t_=t2;
        else
            t=t2;
            t_=t1;
        end

        pos=R0+t*Rd;
        pos2=R0+t_*Rd;
    end
