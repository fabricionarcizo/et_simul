function [O0, I0, Id]=eye_refract_ray_advanced(e, R0, Rd)
%  eye_refract_ray_advanced  Computes refraction at both surfaces of cornea
%    [U0, I0, Id] = eye_refract_ray_advanced(e, R0, Rd) takes a ray (specified 
%    by its origin 'R0' and direction 'Rd') entering the eye from the outside 
%    and computes the point 'O0' where the ray strikes the outer surface of 
%    the cornea, the point 'I0' where it strikes the inner surface of the 
%    cornea and the direction 'Id' of the ray exiting the inner surface of the 
%    cornea.
%
%    Returns [] for 'O0', 'I0' and 'Id' if the ray does not strike the eye.
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

    % Compute refraction at outer surface of cornea
    [O0, Od]=refract_ray_sphere(R0, Rd, e.trans*e.pos_cornea, e.r_cornea, ...
        1, e.n_cornea);

    % Compute refraction at inner surface of cornea
    [I0, Id]=refract_ray_sphere(O0, Od, e.trans*e.cornea_inner_center, ...
        e.r_cornea_inner, e.n_cornea, e.n_aqueous_humor);
