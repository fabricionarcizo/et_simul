function within=eye_point_within_cornea(e, p)
%  eye_point_within_cornea  Tests whether a point lies within the cornea
%    within=eye_point_within_cornea(e, p) tests whether the point 'p', lying
%    on the corneal sphere of the eye 'e', lies within the boundaries of the
%    cornea, as defined by e.depth_cornea. This function is used by
%    eye_find_cr() and eye_find_refraction().

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

    p=e.trans\p;

    within = ((p-e.pos_apex)'*(e.pos_cornea-e.pos_apex) / ...
        norm(e.pos_cornea-e.pos_apex) < e.depth_cornea);
