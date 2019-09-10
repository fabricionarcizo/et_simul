function state=recalib_henn3d_calib(gaze3d_measured, gaze3d_desired)
%  recalib_henn3d_calib  Calibrate 3D version of Hennessey's recalibration
%    state = recalib_henn3d_calib(gaze3d_measured, gaze3d_desired) calibrates
%    a variant of Hennessey et al.'s recalibration procedure [1] that works on
%    3D gaze vectors instead of the 2D gaze positions used in the original
%    procedure.
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

    % Normalize vectors
    gaze3d_measured=normalize_cols(gaze3d_measured);
    gaze3d_desired=normalize_cols(gaze3d_desired);

    state.gaze3d_measured=gaze3d_measured;
    state.offsets=gaze3d_desired-gaze3d_measured;

function gaze3d=normalize_cols(gaze3d)
    norms=sqrt(sum(gaze3d.^2, 1));
    gaze3d=gaze3d./(repmat(norms,4,1));
