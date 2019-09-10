function et = homography_calib(et, calib_data)
%  interpolate_calib  Calibration function for homography transformation

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

    % Calibration data.
    N = size(et.calib_points, 2);
    pupils = ones(3, N);
    targets = ones(3, N);

    % Fill out the pupils matrix and targets matrix.
    for i=1:N

        % Get the pupil center for each calibration point to calculate the
        % homography matrix
        pc = calib_data{i}.camimg{1}.pc;
        pupils(:, i) = [pc(1:2); 1];

        % Get the current calibration target coordinates.
        targets(1:2, i) = et.calib_points(:, i);
    end

    % Homography normalization.
    if (isempty(is_glint_normalization) || is_glint_normalization)
        squared_unit = [0 1; 1 1; 1 0; 0 0]';
        for i=1:N

            % Get the glints coordinates.
            M = size(calib_data{i}.camimg{1}.cr, 1);
            glints = zeros(2, M);
            for j=1:M
                glints(:, j) = calib_data{i}.camimg{1}.cr{j};
            end

            % Calculate the normalization matrix.
            Hn = homography_solve(glints, squared_unit);

            % Normalize the pupil center.
            pupils(1:2, i) = homography_transform(pupils(1:2, i), Hn);
        end
    end

    % Eye camera location compensation method.
    if (~isempty(is_compensated) && is_compensated)
        [pupils, et] = camera_location_compensation(et, calib_data);
    end

    % Determine the coefficients of the calibration function by solving
    % the homography.
    et.state.H = homography_solve(pupils(1:2, :), targets(1:2, :));
