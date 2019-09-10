function pos=intersect_ray_circle(R0, Rd, C0, Cr)
%  intersect_ray_circle  Finds intersection between ray and circle
%    pos = intersect_ray_circle(R0, Rd, C0, Cr) finds the intersection (in
%    2-D) between a ray (specified by its origin 'R0' and direction 'Rd') and
%    a circle (center C0 and radius Cr). The intersection that is closest to 
%    R0 is returned. [] is returned if the ray does not intersect the circle.

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

    b=2*(Rd(1)*(R0(1)-C0(1)) + Rd(2)*(R0(2)-C0(2)));
    c=(R0(1)-C0(1))^2 + (R0(2)-C0(2))^2 - Cr^2;

    disc=b^2-4*c;
    if(disc<0)
        pos=[];
    else
        t1=(-b+sqrt(disc))/2;
        t2=(-b-sqrt(disc))/2;
        if(abs(t1)<abs(t2))
            t=t1;
        else
            t=t2;
        end

        pos=R0+t*Rd;
    end

