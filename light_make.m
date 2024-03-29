function l=light_make()
%  light_make  Creates a structure that represents a light
%    l = light_make() creates a light object 'l' that is positioned at the
%    origin. The light object contains the following element:
%
%    - 'pos' is the position of the light in world coordinates.

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

    l.pos=[0 0 0 1]';
