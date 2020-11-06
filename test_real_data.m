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
    files = dir('../../02 Data/02_real/01_filtered/01_normalized/*.csv');

    % Get the method name.
    functions = dbstack;
    if strncmpi(functions(2).name, 'interpolate', 10)
        method_name = '00_interpolate';
    else
        method_name = '01_homography';
    end

    % Read the calibration data.
    for file = 1:length(files)

        % Open the current file and get the eye information.
        filename = strcat('../../02 Data/02_real/01_filtered/01_normalized/', files(file).name);
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
        gaze_x = zeros(N * M);
        gaze_y = zeros(N * M);

        % Show the epipolar geometry.
        % epipolar_geometry(et);

        % Gaze estimation.
        camimg=cell(1, length(et.cameras));
        for i=1:(M * N)

            % Target ID.
            id = i - 1;

            % Organize the eye feature data.
            camimg{1}.pc = [pupil_x(i); pupil_y(i)];

            % Gaze estimation.
            gaze = feval(et.eval_func, et, camimg);
            gaze_x(i) = gaze(1);
            gaze_y(i) = gaze(2);

            % Calculate the indexes.
            j = floor(id / M) + 1;
            k = mod(id, M) + 1;

            % Calculate the error.
            U(j, k) = gaze(1) - target_x(i);
            V(j, k) = gaze(2) - target_y(i);

        end
        fprintf('\n');

        % Compute error in degrees.
        screen_px_y = 1080;
        screen_mm_y = 298.89;

        S = screen_mm_y / screen_px_y;
        D = 450;

        % Plot gaze error
        fig = figure(1);
        surf(X, Y, (180/pi)*2*atan(((sqrt(U.^2+V.^2)/2)*S)/D));
        
        % Define the plot limits.
        xlim([min(X) max(X)]);
        set(gca, 'XTick', X);
        xlabel('X-axis (pixels)');
        
        ylim([min(Y) max(Y)]);
        set(gca, 'YTick', Y);
        ylabel('Y-axis (pixels)');

        zlim([0 5]);
        zlabel('Z-axis (degrees)');
        
        errs_xy=reshape(sqrt(U.^2+V.^2)', 1, []);
        errors.px=compute_error_statistics(errs_xy);
        fprintf('Maximum error %g px\n', errors.px.max);
        fprintf('Mean error %g px\n', errors.px.mean);
        fprintf('Standard deviation %g px\n', errors.px.std);

        % CSV file.
        sample = zeros(length(errs_xy), 10);
        u = U';
        errs_x = u(:)';
        v = V';
        errs_y = v(:)';
        for i = 1:length(errs_xy)
            sample(i,  1) = target_x(i);
            sample(i,  2) = target_y(i);
            sample(i,  3) = target_x(i) + errs_x(i);
            sample(i,  4) = target_y(i) + errs_y(i);
            sample(i,  5) = errs_x(i);
            sample(i,  6) = errs_y(i);
            sample(i,  7) = errs_xy(i);
            sample(i,  8) = (180/pi)*2*atan(((errs_x(i)/2)*S)/D);
            sample(i,  9) = (180/pi)*2*atan(((errs_y(i)/2)*S)/D);
            sample(i, 10) = (180/pi)*2*atan(((errs_xy(i)/2)*S)/D);
        end
        errors.deg=compute_error_statistics(sample(:, 10));

        title(sprintf(...
            'Maximum Error: %.2g° - Mean Error: %.2g° - Standard Deviation: %.2g°', ...
            errors.deg.max, errors.deg.mean, errors.deg.std));

        number = substr(files(file).name, 1, 4);
        if is_undistorted
            filepath = sprintf('../../02 Data/02_real/02_data_analysis/%s/02_distortion', method_name);
        else
            if is_compensated
                filepath = sprintf('../../02 Data/02_real/02_data_analysis/%s/01_camera', method_name);
            else
                filepath = sprintf('../../02 Data/02_real/02_data_analysis/%s/00_original', method_name);
            end
        end

        % Define the output matrix.
        colNames = {'target_x', 'target_y', 'gaze_x', 'gaze_y', 'error_px_x', ...
            'error_px_y', 'error_px_xy', 'error_deg_x', 'error_deg_y', ...
            'error_deg_xy'};
        output_data = array2table(sample, 'VariableNames', colNames);

        % Save the gaze error in degrees.
        filename = sprintf('%s/%s_error.csv', filepath, number);
        writetable(output_data, filename);

        % Save the statistics in degrees.
        % filename = sprintf('%s/%s_results.mat', filepath, number);
        % save(filename, 'errors');

        % Save the gaze error image.
        % filename = sprintf('%s/%s_error.png', filepath, number);
        % saveas(fig, filename);
    end

function stats=compute_error_statistics(errs)
    stats.mean=mean(errs);
    stats.max=max(errs);
    stats.std=std(errs);
    stats.median=median(errs);
