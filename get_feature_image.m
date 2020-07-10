function pixels=get_feature_image(feature, c)
%  get_feature_image  Get an image of eye feature using RVC toolbox

%    Copyright 2020 Fabricio Batista Narcizo and the IT University of Copenhagen
%
%    This file is part of eyeinfo_simul.
%
%    eyeinfo_simul is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License (version 3) as
%    published by the Free Software Foundation.
%
%    eyeinfo_simul is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    (version 3) along with et_simul in a file called 'COPYING'. If not, see
%    <http://www.gnu.org/licenses/>.

    % Global variables.
    global rvc_cam;

    % Create the RVC camera.
    if isempty(rvc_cam)
        w = 1280;
        h = 1024;
        rvc_cam = CentralCamera('focal', 0.02800, 'pixel', 10e-6, ...
            'resolution', [w h], 'centre', [w/2 h/2], ...
            'pose', SE3(c.trans) * SE3.Ry(pi));
    end

    pixels = [feature(1, :); feature(3, :); feature(2, :)];
    pixels = rvc_cam.project(pixels);
