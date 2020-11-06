function errors=test_simulated_data(et)
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
    global user_position;

    % Search for all eye information data.
    files = dir('../../02 Data/01_simulated/01_filtered/00_normalized/*.csv');

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
        filename = strcat('../../02 Data/01_simulated/01_filtered/00_normalized/', files(file).name);
        dataset = readtable(filename);

        % Get the calibration data.
        target_x = [dataset.target_x(1:10:21); dataset.target_x(211:10:232); dataset.target_x(421:10:441)]';
        target_y = [dataset.target_y(1:10:21); dataset.target_y(211:10:232); dataset.target_y(421:10:441)]';
        pupil_x = [dataset.pupil_x(1:10:21); dataset.pupil_x(211:10:232); dataset.pupil_x(421:10:441)]';
        pupil_y = [dataset.pupil_y(1:10:21); dataset.pupil_y(211:10:232); dataset.pupil_y(421:10:441)]';

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
        X=linspace(min(target_x), max(target_x), 21);
        Y=linspace(min(target_y), max(target_y), 21);
        M=size(X, 2);
        N=size(Y, 2);

        U=zeros(M, N);
        V=zeros(M, N);

        % Gaze estimation.
        camimg=cell(1, length(et.cameras));
        for i=1:(M * N)

            % Target ID.
            id = i - 1;

            % Organize the eye feature data.
            camimg{1}.pc = [pupil_x(i); pupil_y(i)];

            % Gaze estimation.
            gaze = feval(et.eval_func, et, camimg);

            % Calculate the indexes.
            j = mod(id, M) + 1;
            k = floor(id / M) + 1;

            % Calculate the error.
            U(j, k) = gaze(1) - target_x(i);
            V(j, k) = gaze(2) - target_y(i);
        end

        % Calculate gaze error
        errs_deg_x=zeros(M, N);
        errs_deg_y=zeros(M, N);
        errs_deg_z=zeros(M, N);
        errs_deg=zeros(M, N);
        for i=1:length(X)
            for j=1:length(Y)
                % Compute error in degrees
                gaze3d_real=[X(i) 0 Y(j)]'-user_position(1:3);
                gaze3d_measured=[X(i)+U(j,i) 0 Y(j)+V(j,i)]'- ...
                    user_position(1:3);
                gaze3d_real=gaze3d_real/norm(gaze3d_real);
                gaze3d_measured=gaze3d_measured/norm(gaze3d_measured);
                errs_deg_x(i, j)=180/pi*real(abs(gaze3d_real(1)-gaze3d_measured(1)));
                errs_deg_y(i, j)=180/pi*real(abs(gaze3d_real(2)-gaze3d_measured(2)));
                errs_deg_z(i, j)=180/pi*real(abs(gaze3d_real(3)-gaze3d_measured(3)));
                errs_deg(i, j)=180/pi*real(acos(gaze3d_real'*gaze3d_measured));
            end
        end

        % Plot gaze error
        fig = figure(1);
        surf(X, Y, errs_deg');

        % Define the plot limits.        
        X=linspace(min(target_x), max(target_x), 11);
        Y=linspace(min(target_y), max(target_y), 11);

        xlim([min(X) max(X)]);
        set(gca, 'XTick', X);
        xlabel('X-axis (pixels)');

        ylim([min(Y) max(Y)]);
        set(gca, 'YTick', Y);
        ylabel('Y-axis (pixels)');

        %zlim([0 2.5]);
        zlabel('Z-axis (degrees)');
        
        errs_xy=reshape(sqrt(U.^2+V.^2)', 1, []);
        errors.px=compute_error_statistics(errs_xy);
        %fprintf('%g\n', substr(files(file).name, 1, 4));
        fprintf('%g\n', file);
        fprintf('Maximum error %g px\n', errors.px.max);
        fprintf('Mean error %g px\n', errors.px.mean);
        fprintf('Standard deviation %g px\n\n', errors.px.std);

        % CSV file.
        sample = zeros(length(errs_xy), 11);
        u = U';
        errs_x = u(:)';
        v = V';
        errs_y = v(:)';
        x = errs_deg_x';
        deg_x = x(:)';
        y = errs_deg_y';
        deg_y = y(:)';
        z = errs_deg_z';
        deg_z = z(:)';
        d = errs_deg';
        deg_xyz = d(:)';
        for i = 1:length(errs_xy)
            sample(i,  1) = target_x(i);
            sample(i,  2) = target_y(i);
            sample(i,  3) = target_x(i) + errs_x(i);
            sample(i,  4) = target_y(i) + errs_y(i);
            sample(i,  5) = errs_x(i);
            sample(i,  6) = errs_y(i);
            sample(i,  7) = errs_xy(i);
            sample(i,  8) = deg_x(i);
            sample(i,  9) = deg_y(i);
            sample(i, 10) = deg_z(i);
            sample(i, 11) = deg_xyz(i);
        end
        errors.deg=compute_error_statistics(sample(:, 11));

        title(sprintf(...
            'Maximum Error: %.2g° - Mean Error: %.2g° - Standard Deviation: %.2g°', ...
            errors.deg.max, errors.deg.mean, errors.deg.std));

        if is_undistorted
            filepath = sprintf('../../02 Data/01_simulated/02_data_analysis/%s/02_distortion', method_name);
        else
            if is_compensated
                filepath = sprintf('../../02 Data/01_simulated/02_data_analysis/%s/01_camera', method_name);
            else
                filepath = sprintf('../../02 Data/01_simulated/02_data_analysis/%s/00_original', method_name);
            end
        end

        % Define the output matrix.
        colNames = {'target_x', 'target_y', 'gaze_x', 'gaze_y', 'error_px_x', ...
            'error_px_y', 'error_px_xy', 'error_deg_x', 'error_deg_y', ...
            'error_deg_z', 'error_deg_xyz'};
        output_data = array2table(sample, 'VariableNames', colNames);

        % Define the filename.
        nameSize = size(files(file).name, 2);
        filename = substr(files(file).name, 1, nameSize - 4);

        % Save the gaze error in degrees.
        output = sprintf('%s/%s_error.csv', filepath, filename);
        writetable(output_data, output);

        % Save the statistics in degrees.
        % output = sprintf('%s/%s_results.mat', filepath, filename);
        % save(output, 'errors');

        % Save the gaze error image.
        % output = sprintf('%s/%s_error.png', filepath, filename);
        % saveas(fig, output);
    end

function stats=compute_error_statistics(errs)
    stats.mean=mean(errs);
    stats.max=max(errs);
    stats.std=std(errs);
    stats.median=median(errs);
