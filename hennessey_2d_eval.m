function gaze = hennessey_2d_eval(et, camimg)
%  hennessey_2d_eval  Evaluation function for pupil-CR interpolation

%    Copyright 2019 Fabricio Batista Narcizo and the IT University of Copenhagen
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
    global is_compensated;
    global is_undistorted;
    global is_glint_normalization;

    % Get the current pupil center
    pc = camimg{1}.pc;

    % PCCR normalization.
    if (isempty(is_glint_normalization) || is_glint_normalization)
        pc = pc - camimg{1}.cr{1};
    end

    % Eye camera location compensation method.
    if (~isempty(is_compensated) && is_compensated)
        pc = pupil_compensation(et, pc);
    end

    % Eye feature distortion compensation method.
    if (~isempty(is_undistorted) && is_undistorted)
        pc = undistort_pupil(et, pc);
    end

    gaze = et.state.A * [1 pc(1) pc(2) pc(1)*pc(2)]';
