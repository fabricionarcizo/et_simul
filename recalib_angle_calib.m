function state=recalib_angle_calib(gaze3d_measured, gaze3d_desired, type)
%  recalib_angle_calib  Calibrate gaze angle recalibration procedure
%    state = recalib_angle_calib(gaze3d_measured, gaze3d_desired, type)
%    calibrates a recalibration procedure based on an interpolation function
%    that maps estimated gaze angles to corrected gaze angles.
%
%    'gaze3d_measured' is a 3-times-n matrix of estimated gaze vectors,
%    'gaze3d_desired' are the corresponding true gaze vectors, and 'type' is
%    the type of interpolation to perform ('biquadratic' or 'bilinear'). The
%    result of the recalibration is returned in 'state'.

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
    n=size(gaze3d_measured, 2);

    X=zeros(6,n);
    angles_desired=zeros(2,n);

    for j=1:n
        angles=gaze2angle(gaze3d_measured(:,j));
        X(:,j)=[1 angles(1) angles(2) angles(1)*angles(2) angles(1)^2 ...
            angles(2)^2]';
        angles_desired(:,j)=gaze2angle(gaze3d_desired(:,j));
    end

    if strcmp(type, 'bilinear')
        X=X(1:4,:);
    end

    state.A=angles_desired/X;
