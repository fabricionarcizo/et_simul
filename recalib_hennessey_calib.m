function state=recalib_hennessey_calib(gaze_measured, gaze_desired)
%  recalib_hennessey_calib  Calibrate Hennessey's recalibration procedure
%    state = recalib_hennessey_calib(gaze_measured, gaze_desired) performs the
%    calibration for the recalibration procedure described by Hennessey et
%    al. [1] and returns the result in 'state'. 'gaze_measured' is a 2-times-n
%    matrix of estimated gaze positions on screen, and 'gaze_desired' are the
%    corresponding true gaze positions.
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

    state.gaze_measured=gaze_measured;
    state.offsets=gaze_desired-gaze_measured;
