function x=intersect_ray_plane(R0, Rd, P0, Pn)
%  intersect_ray_plane  Finds intersection between ray and plane
%    x = intersect_ray_plane(R0, Rd, P0, Pn) returns the intersection between 
%    a ray (specified by its origin 'R0' and direction 'Rd') and a plane
%    (specified by a point 'P0' on the plane and a normal 'Pn'). [] is
%    returned if the ray does not intersect the plane or if it lies within the
%    plane.

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

    if Rd'*Pn==0
        x=[];
    else
        alpha=((P0-R0)'*Pn)/(Rd'*Pn);
        x=R0+alpha*Rd;
    end
