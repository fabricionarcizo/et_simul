function state=recalib_henn_angle_calib(gaze3d_measured, gaze3d_desired)
%  recalib_henn_angle_calib  Calibrate eye angle version of Hennessey recalib.
%    state = recalib_henn_angle_calib(gaze3d_measured, gaze3d_desired)
%    calibrates a variant of Hennessey et al.'s recalibration procedure [1]
%    that works on eye angles instead of the 2D gaze positions used in the
%    original procedure.
%
%    'gaze3d_measured' is a 3-times-n matrix of estimated gaze vectors, and
%    'gaze3d_desired' are the corresponding true gaze vectors.
%
%    [1] Craig Hennessey, Borna Noureddin, Peter Lawrence. A Single Camera
%        Eye-Gaze Tracking System with Free Head Motion. ETRA 2006.

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

    % Get number of gaze points
    n=size(gaze3d_measured, 2);

    state.angles_desired=zeros(2,n);
    state.offsets=zeros(2,n);

    for j=1:n
        state.angles_measured(:,j)=gaze2angle(gaze3d_measured(:,j));
        state.offsets(:,j)=gaze2angle(gaze3d_desired(:,j)) - ...
            state.angles_measured(:,j);
    end
