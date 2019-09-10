function gaze=recalib_screen_eval(state, gaze)
%  recalib_screen_eval  Apply screen coordinate recalibration
%    gaze = recalib_screen_eval(state, gaze) corrects the 2D gaze position
%    'gaze' according to the recalibration information 'state' (obtained using
%    recalib_screen_calib()).

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

    if size(state.A,2)==4
        % Bilinear interpolation
        gaze=state.A*[1 gaze(1) gaze(2) gaze(1)*gaze(2)]';
    else
        % Biquadratic interpolation
        gaze=state.A*[1 gaze(1) gaze(2) gaze(1)*gaze(2) gaze(1)^2 gaze(2)^2]';
    end
