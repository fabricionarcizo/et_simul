function c=camera_pan_tilt(c, look_at)
%  camera_pan_tilt  Pans and tilts a camera towards a certain location
%    c = camera_pan_tilt(c, look_at) pans and tilts the camera 'c' so that it
%    is looking directly at the point 'look_at' (given in world coordinates).
%    The coordinate transformation 'trans' of the returned camera is modified
%    accordingly. The camera is panned and tilted around the origin of its
%    coordinate system.

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

    % Extend 'look_at' to homogeneous coordinates if necessary
    if length(look_at)<4
        look_at=[look_at(1:3); 1];
    end

    % Convert 'look_at' to coordinate system of unrotated camera
    axis=c.rest_trans\look_at;

    % Strip off fourth component of axis and normalize
    axis=axis(1:3)/norm(axis(1:3));

    % Get pan and tilt angles
    alpha=pi/2-atan2(-axis(3), axis(1));
    beta=asin(axis(2));

    % Construct pan and tilt matrices that transform from the panned and
    % tilted camera's system to the system of the camera in its rest position
    pan_matrix=[ ...
        cos(alpha) 0 -sin(alpha) 0; ...
        0          1  0          0; ...
        sin(alpha) 0  cos(alpha) 0; ...
        0          0  0          1];
    tilt_matrix=[ ...
        1 0          0         0; ...
        0 cos(beta) -sin(beta) 0; ...
        0 sin(beta)  cos(beta) 0; ...
        0 0          0         1];

    % Create transformation matrix for rotated camera
    c.trans=c.rest_trans*pan_matrix*tilt_matrix;
