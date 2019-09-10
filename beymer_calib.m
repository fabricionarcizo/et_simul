function et = beymer_calib(et, calib_data)
%  beymer_calib  Calibration function for Beymer and Flickner's method

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

    gaze_measured=zeros(size(et.calib_points));
    gaze3d_measured=zeros(4, size(et.calib_points, 2));
    gaze3d_desired=zeros(4, size(et.calib_points, 2));

    % Determine uncorrected gaze estimate for each calibration point
    for i=1:size(et.calib_points,2)
        [gaze_measured(:,i), cc_estim, gaze3d_measured(:,i)]= ...
            beymer_eval_base(et, calib_data{i}.camimg, calib_data{i}.e);
        gaze3d_desired(:,i)= ...
            [et.calib_points(1,i) 0 et.calib_points(2,i) 1]' - ...
            cc_estim;
    end

    et.state.recalib_hennessey=recalib_hennessey_calib(gaze_measured, ...
        et.calib_points);

    et.state.recalib_screen=recalib_screen_calib(gaze_measured, ...
        et.calib_points, 'biquadratic');

    et.state.recalib_angle=recalib_angle_calib(gaze3d_measured, ...
        gaze3d_desired, 'biquadratic');
