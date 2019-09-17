function et = interpolate_calib(et, calib_data)
%  interpolate_calib  Calibration function for pupil-CR interpolation

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

    % Calculate the matrices sizes.
    N = size(et.calib_points, 2);
    [M, D] = size(equation(1, 1));

    % Calibration data.
    pupils = ones(3, N);
    targets = ones(3, N);
    X = ones(M, N, D);

    % Fill out the pupils matrix and targets matrix.
    for i = 1:N

        % Get the pupil center for each calibration point to calculate the
        % homography matrix
        pc = calib_data{i}.camimg{1}.pc;
        pupils(:, i) = [pc(1:2); 1];

        % Get the current calibration target coordinates.
        targets(1:2, i) = et.calib_points(:, i);
    end

    % PCCR normalization.
    if (isempty(is_glint_normalization) || is_glint_normalization)
        for i = 1:N
            pupils(1:2, i) = pupils(1:2, i) - calib_data{i}.camimg{1}.cr{1};
        end
    end

    % Eye camera location compensation method.
    if (~isempty(is_compensated) && is_compensated)
        [et, pupils] = camera_location_compensation(et, pupils);
    end
    
    % Eye feature distortion compensation method.
    if (~isempty(is_undistorted) && is_undistorted)
        squared_unit = ones(3, N);
        squared_unit(1, 1:3:N) = -1;
        squared_unit(1, 2:3:N) = 0;
        squared_unit(2, 1:3) = -1;
        squared_unit(2, 4:6) = 0;

        et = calculate_distortion(et, pupils, squared_unit);

        pupils = undistort_pupil(et, pupils);
    end

    for i = 1:size(et.calib_points, 2)
        % Calculate the pupil-CR-vector for each calibration point and 
        % build the interpolation matrix
        pc = pupils(:, i);
        X(:,i,:) = equation(pc(1), pc(2));
    end

    % Determine the coefficients of the calibration function by solving
    % the linear equations
    if (D == 1)
        et.state.A = et.calib_points / X;
    else
        et.state.A = [];
        for i=1:D
            row = et.calib_points(i, :) / X(:, :, i);
            et.state.A = [et.state.A; row];
        end
    end
