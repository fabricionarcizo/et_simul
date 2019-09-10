function gaze3d=recalib_angle_eval(state, gaze3d)
%  recalib_angle_eval  Apply gaze angle recalibration
%    gaze3d = recalib_angle_eval(state, gaze3d) corrects the gaze vector
%    'gaze3d' according to the recalibration information 'state' (obtained
%    using recalib_angle_calib()).

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

    angles=gaze2angle(gaze3d);
    
    if size(state.A,2)==4
        angles=state.A*[1 angles(1) angles(2) angles(1)*angles(2)]';
    else
        angles=state.A*[1 angles(1) angles(2) angles(1)*angles(2) ...
            angles(1)^2 angles(2)^2]';
    end

    gaze3d=angle2gaze(angles);
