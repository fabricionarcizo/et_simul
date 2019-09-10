function [h3D, h2D]=mark_point(c, p, spec)
%  mark_point  Marks a point in 3D view and camera image
%    mark_point(c, p, spec) is a helper function used by draw_scene() to mark
%    the position of a point 'p' both in the three-dimensional scene and in
%    the camera image of camera 'c'. The point is drawn using the
%    specification 'spec'; if no specification is given, a blue plus sign is
%    used.
%    The handles of the points in the three-dimensional scene and the camera
%    image are returned in 'h3D' and 'h2D', respectively.

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
        spec='b+';
    end

    hold on;
    subplot(2,1,1);
    h3D=plot3(p(1), p(2), p(3), spec);
    subplot(2,1,2);
    p=camera_project(c, p);
    h2D=plot(p(1), p(2), spec);
    hold off;
