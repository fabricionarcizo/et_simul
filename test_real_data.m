    function errors=test_real_data(et)
%  test_over_screen Computes gaze error at different gaze positions on screen
%    test_over_screen(et, observer_pos_calib, observer_pos_test, r_cornea,
%    r_pc) tests the eye tracker 'et' by sweeping the gaze position across the
%    screen. The observer position is 'observer_pos_calib' for the calibration
%    and 'observer_pos_test' for the test. The size of the cornea is
%    'r_cornea', and the distance between cornea center and pupil center is
%    'r_pc'.
%    Any arguments after 'et' that are not specified are set to sensible
%    default values.

%    Copyright 2008 Mathis Graw, Martin Böhme and the University of Lübeck
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

    % Search for all eye information data.
    files = dir('../../05 Data/normalized/*.csv');

    % Read the calibration data.
    for file = 1:length(files)

        % Open the current file and get the eye information.
        filename = strcat('../../05 Data/normalized/', files(file).name);
        dataset = readtable(filename);

        % Get the calibration data.
        target_x = [dataset.target_x(1:3:7); dataset.target_x(15:3:21); dataset.target_x(29:3:35)]';
        target_y = [dataset.target_y(1:3:7); dataset.target_y(15:3:21); dataset.target_y(29:3:35)]';
        pupil_x = [dataset.pupil_x(1:3:7); dataset.pupil_x(15:3:21); dataset.pupil_x(29:3:35)]';
        pupil_y = [dataset.pupil_y(1:3:7); dataset.pupil_y(15:3:21); dataset.pupil_y(29:3:35)]';

        % Process the calibration data.
        N = size(pupil_x, 2);
        calib_data = cell(1, N);
        for i=1:N
            et.calib_points(:, i) = [target_x(i); target_y(i)];
            calib_data{i}.camimg = cell(1, length(et.cameras));
            calib_data{i}.camimg{1}.pc = [pupil_x(i); pupil_y(i)];
        end
        et.calib_data = calib_data;

        % Calibrate eye tracker
        et=feval(et.calib_func, et, calib_data);

        % Get the test data.
        target_x = dataset.target_x;
        target_y = dataset.target_y;
        pupil_x = dataset.pupil_x;
        pupil_y = dataset.pupil_y;

        % Define screen positions grid
        X=linspace(min(target_x), max(target_x), 7);
        Y=linspace(min(target_y), max(target_y), 5);
        M=size(X, 2);
        N=size(Y, 2);

        U=zeros(N, M);
        V=zeros(N, M);

        % Show the epipolar geometry.
        epipolar_geometry(et);

        % Gaze estimation.
        camimg=cell(1, length(et.cameras));
        for i=1:(M * N)

            % Target ID.
            id = ceil(i / 1) - 1;

            % Organize the eye feature data.
            camimg{1}.pc = [pupil_x(i); pupil_y(i)];

            % Gaze estimation.
            gaze = feval(et.eval_func, et, camimg);

            % Calculate the indexes.
            j = floor(id / 7) + 1;
            k = mod(id, 7) + 1;

            % Calculate the error.
            U(j, k) = U(j, k) + gaze(1) - target_x(i);
            V(j, k) = V(j, k) + gaze(2) - target_y(i);

        end
        fprintf('\n');

        % Plot gaze error
        fig = figure(3);
        surf(X, Y, sqrt(U.^2+V.^2));
        errs_px=reshape(sqrt(U.^2+V.^2), 1, []);
        errors.px=compute_error_statistics(errs_px);
        fprintf('Maximum error %g px\n', errors.px.max);
        fprintf('Mean error %g px\n', errors.px.mean);
        fprintf('Standard deviation %g px\n', errors.px.std);

        % Compute error in degrees.
        screen_px_y = 1080;
        screen_mm_y = 298.89;

        S = screen_mm_y / screen_px_y;
        D = 550;

        output_data = zeros(10, length(errs_px));
        errs_x = U(:)';
        errs_y = V(:)';
        for i = 1:length(errs_px)
            output_data( 1, i) = target_x(i);
            output_data( 2, i) = target_y(i);
            output_data( 3, i) = errs_x(i) + target_x(i);
            output_data( 4, i) = errs_y(i) + target_y(i);
            output_data( 5, i) = errs_x(i);
            output_data( 6, i) = errs_y(i);
            output_data( 7, i) = errs_px(i);
            output_data( 8, i) = (180/pi)*2*atan(((errs_x(i)/2)*S)/D);
            output_data( 9, i) = (180/pi)*2*atan(((errs_y(i)/2)*S)/D);
            output_data(10, i) = (180/pi)*2*atan(((errs_px(i)/2)*S)/D);
        end
        errors.deg=compute_error_statistics(output_data(10, :));

        title(sprintf(...
            'Maximum Error: %.2g° - Mean Error: %.2g° - Standard Deviation: %.2g°', ...
            errors.deg.max, errors.deg.mean, errors.deg.std));

        number = substr(files(file).name, 1, 4);
        if is_undistorted
            filepath = '../../05 Data/real_data/distortion';
        else
            if is_compensated
                filepath = '../../05 Data/real_data/camera';
            else
                filepath = '../../05 Data/real_data/original';
            end
        end

        % Save the gaze error in degrees.
        filename = sprintf('%s/%s_error.csv', filepath, number);
        csvwrite(filename, output_data');

        % Save the statistics in degrees.
        filename = sprintf('%s/%s_results.mat', filepath, number);
        save(filename, 'errors');

        % Save the gaze error image.
        filename = sprintf('%s/%s_error.png', filepath, number);
        saveas(fig, filename);
    end

function stats=compute_error_statistics(errs)
    stats.mean=mean(errs);
    stats.max=max(errs);
    stats.std=std(errs);
    stats.median=median(errs);
