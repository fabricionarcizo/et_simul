function success=test_pan_tilt()
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

    c=camera_make();

    % Rotate camera to rest position
    cam_angle=10*pi/180;
    c.trans(1:3,1:3)=[1 0 0; 0 -sin(cam_angle) -cos(cam_angle); ...
        0 cos(cam_angle) -sin(cam_angle)];
    c.rest_trans=c.trans;

    % Pan and tilt camera to look at test point
    look_at=[2 5 3 1]';
    c=camera_pan_tilt(c, look_at);

    % Test point should now be projected onto center of image plane
    x=camera_project(c, look_at);

    success=norm(x)<sqrt(eps);
