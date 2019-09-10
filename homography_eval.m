function gaze = homography_eval(et, camimg)
%  homography_eval  Evaluation function for homography transformation

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
    global is_glint_normalization;

    % Get the current pupil center.
    pupil = camimg{1}.pc;

    % Homography normalization.
    if (isempty(is_glint_normalization) || is_glint_normalization)
        squared_unit = [0 1; 1 1; 1 0; 0 0]';

        M = size(camimg{1}.cr, 1);
        glints = zeros(2, M);
        for j=1:M
            glints(:, j) = camimg{1}.cr{j};
        end

        % Calculate the normalization matrix.
        Hn = homography_solve(glints, squared_unit);

        % Normalize the pupil center.
        pupil = homography_transform(pupil(1:2), Hn);

    end

    % Eye camera location compensation method.
    if (~isempty(is_compensated) && is_compensated)
        pupil = pupil_compensation(et, pupil);
    end

    % Gaze estimation.
    gaze = homography_transform(pupil(1:2), et.state.H);
