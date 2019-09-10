function h=light_draw(l, ax)
%  light_draw  Draws a graphical representation of a light
%    h = light_draw(l, ax) draws a graphical representation of light 'l' into
%    the axes 'ax' and returns a handle to the graphics object in 'h'. If no
%    axes are specified, the current axes are used.

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

    if nargin<2
        ax=gca;
    end

    h=plot3(l.pos(1), l.pos(2), l.pos(3), 'ro');
