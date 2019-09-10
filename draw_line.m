function h=draw_line(x1, x2, spec)
%  draw_line  Draws a three-dimensional line between two points
%    h = draw_line(x1, x2, spec) draws a three-dimensional line on the current
%    axes between 'x1' and 'x2' using the line specification 'spec'. If no
%    specification is given, a continuous black line is drawn. Returns the
%    handle for the line object that is created.
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

    if nargin<3
        spec='k-';
    end

    subplot(2, 1, 1);
    h=plot3([x1(1) x2(1)], [x1(2) x2(2)], [x1(3) x2(3)], spec);
