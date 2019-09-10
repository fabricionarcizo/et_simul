function c=camera_point_at(c, point_at)
%  camera_point_at  Points camera towards a certain location
%    c = camera_point_at(c, point_at) changes the rest position of the
%    camera 'c' so that it is pointing at the point 'point_at' (given in world
%    coordinates). The elements 'rest_trans' and 'trans' of the returned
%    camera are modified accordingly.
%
%    Note: This function differs from camera_pan_tilt() in that the latter
%    does not affect the rest position of the camera, while this function
%    does.

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

    % First, make sure rest transform for camera is the same as the transform
    c.rest_trans=c.trans;

    % Pan and tilt camera to look at the given point
    c=camera_pan_tilt(c, point_at);

    % This is also the new rest transform for the camera
    c.rest_trans=c.trans;
