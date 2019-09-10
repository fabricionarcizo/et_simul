function camera=etra_camera_adjust(camera)
%  etra_camera_adjust  Sets camera parameters and orientation for ETRA paper
%    camera = etra_camera_adjust(camera) adjusts the camera parameters (focal
%    length and resolution) of the given camera and pans and tilts it to point
%    at the center of the eye position volume. These camera settings were used
%    for tests in the ETRA 2008 paper describing et_simul.

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

    camera.focal_length=2000;
    camera.resolution=[1280 1024];

    % Adjust camera transform so we're looking at the center of the eye
    % position box
    camera=camera_point_at(camera, [0 500e-3 350e-3 1]');
