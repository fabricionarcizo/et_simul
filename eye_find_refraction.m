function I=eye_find_refraction(e, C, O)
%  eye_find_refraction  Computes observed position of intraocular objects
%    I = eye_find_refraction(e, C, O) computes the position at which a camera
%    at position 'C' observes an object at position 'O' inside the eye 'e' due
%    to refraction at the surface of the cornea. The position of the image 'I'
%    that is returned lies on the surface of the cornea; a ray emanating from
%    'O' is refracted at 'I' to pass directly through 'C'. If no suitable
%    point can be found within the boundaries of the cornea, [] is returned
%    for 'I'.

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

    I=find_refraction(C, O, e.trans*e.pos_cornea, e.r_cornea, 1, e.n_cornea);

    if ~eye_point_within_cornea(e, I)
        I=[];
    end
