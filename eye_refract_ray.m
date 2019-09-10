function [U0, Ud]=eye_refract_ray(e, R0, Rd)
%  eye_refract_ray  Computes refraction of ray at cornea surface
%    [U0, Ud] = eye_refract_ray(e, R0, Rd) takes a ray (specified by its 
%    origin 'R0' and direction 'Rd') entering the eye 'e' from the outside and
%    computes the point 'U0' where the ray strikes the surface of the cornea 
%    and the direction 'Ud' of the refracted ray.
%
%    Returns [] for 'U0' and 'Ud' if the ray does not strike the eye.
%
%    'R0', 'Rd', 'O0', 'I0' and 'Id' are in world coordinates. 3D or 
%    homogeneous coordinates may be passed in; the same type of coordinates is 
%    passed out.

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

    % Compute refraction at surface of cornea
    [U0, Ud]=refract_ray_sphere(R0, Rd, e.trans*e.pos_cornea, e.r_cornea, ...
        1, e.n_cornea);
