function gaze = interpolate_eval(et, camimg)
%  interpolate_eval  Evaluation function for pupil-CR interpolation

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

    % Global variables.
    global is_compensated;
    global is_undistorted;
    global is_glint_normalization;
    global polynomial;

    % Get the polynomial equation.
    if (~isempty(polynomial))
        equation = polynomial;
    else
        equation = @(x, y) [1 x y x*y x^2 y^2]';
    end

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

    % Gaze estimation.
    result = equation(pc(1), pc(2));
    D= size(result, 2);

    if (D == 1)
        gaze = et.state.A * result;
    else
        gaze = [];
        for i = 1:D
            row = et.state.A(i, :) * result(:, i);
            gaze = [gaze; row];
        end
    end
