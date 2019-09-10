function et=etra_shihwuliu_make(params)
%  etra_shihwuliu_make  Returns Shih, Wu, Liu eye tracker for ETRA paper
%    et = etra_shihwuliu_make(params) creates an eye tracker that uses the
%    method by Shih, Wu, and Liu (see shihwuliu_make()). The lights are
%    adjusted so that they are at the same positions as for the eye tracker
%    created by etra_hennessey_make(). The camera and calibration points are
%    adjusted to specific values used for tests in the ETRA 2008 paper
%    describing et_simul.

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

    et=shihwuliu_make(params);
    
    % Create lights (on vertical edge of monitor) to be the same as for the
    % Hennessey setup
    et.lights=cell(2,1);
    et.lights{1}=light_make;
    et.lights{1}.pos=[200e-3 0 50e-3 1]';
    et.lights{2}=light_make;
    et.lights{2}.pos=[200e-3 0 300e-3 1]';

    % Move cameras so they aren't collinear with the lights
    et.cameras{1}.trans(1:3,4)=[-200e-3 0 0]';
    et.cameras{2}.trans(1:3,4)=[   0e-3 0 0]';

    % Adjust camera specs
    for j=1:length(et.cameras)
        et.cameras{j}=etra_camera_adjust(et.cameras{j});
    end

    % Use standard calibration points
    et.calib_points=etra_calib_points();
