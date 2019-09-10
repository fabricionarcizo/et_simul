function h=camera_draw(c, ax)
%  camera_draw  Draws a graphical representation of a camera
%    h = camera_draw(c, ax) draws a graphical representation of camera 'c'
%    into the axes 'ax' and returns a handle to the graphics object that
%    represents the camera's center of projection. If no axes are specified,
%    the current axes are used.

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

    % Plot a black star at the camera's center of projection
    h=plot3(c.trans(1,4), c.trans(2,4), c.trans(3,4), 'k*');

    % Plot up and across vector
    up=[0 0.05 0 1]';
    draw_line(c.trans(:,4), c.trans*up);
    across=[0.1 0 0 1]';
    draw_line(c.trans(:,4), c.trans*across);
    in=[0 0 -0.05 1]';
    draw_line(c.trans(:,4), c.trans*in, ':');
