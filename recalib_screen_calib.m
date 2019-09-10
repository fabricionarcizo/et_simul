function state=recalib_screen_calib(gaze_measured, gaze_desired, type)
%  recalib_screen_calib  Calibrate screen coordinate recalibration procedure
%    state = recalib_screen_calib(gaze_measured, gaze_desired, type) 
%    calibrates a recalibration procedure based on an interpolation function
%    that maps estimated 2D gaze positions to corrected gaze positions.
%
%    'gaze_measured' is a 2-times-n matrix of estimated gaze positions on
%    screen, 'gaze_desired' are the corresponding true gaze positions, and
%    'type' is the type of interpolation to perform ('biquadratic' or
%    'bilinear'). The result of the recalibration is returned in 'state'.

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
        type='biquadratic';
    end

    % Get number of gaze points
    n=size(gaze_measured, 2);

    X=[ones(1,n); gaze_measured(1,:); gaze_measured(2,:);
        gaze_measured(1,:).*gaze_measured(2,:)];
    if strcmp(type, 'bilinear')
        X=[ones(1,n); gaze_measured(1,:); gaze_measured(2,:);
            gaze_measured(1,:).*gaze_measured(2,:)];
    else
        X=[ones(1,n); gaze_measured(1,:); gaze_measured(2,:);
            gaze_measured(1,:).*gaze_measured(2,:); gaze_measured(1,:).^2;
            gaze_measured(2,:).^2];
    end
    state.A=gaze_desired/X;
