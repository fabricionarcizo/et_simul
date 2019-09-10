function [U0, Ud]=reflect_ray_sphere(R0, Rd, S0, Sr)
%  reflect_ray_sphere  Reflects ray on sphere
%    [U0, Ud] = reflect_ray_sphere(R0, Rd, S0, Sr) find the point 'U0' at
%    which a ray (specified by its origin 'R0' and direction 'Rd') strikes a 
%    sphere (with center 'S0' and radius 'Sr') and computes the direction 'Ud'
%    of the reflected ray. The result is undefined if the original ray does
%    not intersect the sphere.
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

    Rd=Rd/norm(Rd);

    % Find point of intersection
    U0=intersect_ray_sphere(R0, Rd, S0, Sr);

    N=(U0-S0)/norm(U0-S0);
    Ud=Rd-2*N*(Rd'*N);

