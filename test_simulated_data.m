function test_simulated_data(et, observer_pos_calib, ...
    r_cornea, r_pc)
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
    global user_position;
    global eye_camera_position;
    global file_number;

    if nargin<2
        if (~isempty(user_position))
            observer_pos_calib=user_position;
        else
            observer_pos_calib=[0 550e-3 350e-3 1]';
        end
    end
    if nargin<4
        r_cornea=7.98e-3;
    end

    % Create eye
    e=eye_make(r_cornea, [1 0 0; 0 0 1; 0 1 0]);
    e.trans(1:3,4)=observer_pos_calib(1:3);
    if nargin>=5
        e.pos_pupil=e.pos_cornea-[0 0 r_pc 0]';
    end

    % Define screen positions grid
    N=21;
    X=linspace(-200e-3, 200e-3, N);
    Y=linspace(50e-3, 350e-3, N);

    % Eye feature CSVs.
    sample = zeros(N * N, 18);
    distribution = zeros(N * N, 4);

    k=0;
    for i=1:length(X)
        fprintf('.');
        for j=1:length(Y)

            % Look at a target on the screen
            e=eye_look_at(e, [X(i) 0 Y(j) 1]');

            % Take a photo from the eye
            camimg = camera_take_image(et.cameras{1}, e, et.lights);

            % Glint normalization
            glints = zeros(2, 4);
            for l=1:4
                if size(camimg.cr{l}, 2) ~= 0
                    glints(:, l) = camimg.cr{l};
                end
            end

            % Calculate middle point.
            glints = glints(:, any(glints));

            % Current frame and target ID.
            k = k + 1;

            % Get the current pupil center
            distribution(k,   1) = X(i);
            distribution(k,   2) = Y(j);
            distribution(k, 3:4) = camimg.pc;% - mean(glints, 2);

            % Save the current eye feature.
            sample(k,  1) = k - 1;
            sample(k,  2) = k - 1;
            sample(k,  3) = now;
            sample(k,  4) = X(i);
            sample(k,  5) = Y(j);
            sample(k,  6) = camimg.pc(1);
            sample(k,  7) = camimg.pc(2);
            sample(k,  8) = camimg.ellipse(3);
            sample(k,  9) = camimg.ellipse(4);
            sample(k, 10) = camimg.ellipse(5);
            for l=1:4
                if size(camimg.cr{l}, 2) ~= 0
                    sample(k, 10+(2*l-1)) = camimg.cr{l}(1);
                    sample(k, 10+2*l) = camimg.cr{l}(2);
                else
                    sample(k, 10+(2*l-1)) = -1;
                    sample(k, 10+2*l) = -1;
                end
            end
        end
    end
    fprintf('\n');

    % Define the output matrix.
    colNames = {'frame_no', 'target_no', 'time_stamp', 'target_x', 'target_y', ...
        'pupil_x', 'pupil_y', 'ellipse_min_axis', 'ellipse_max_axis', ...
        'ellipse_angle', 'glint_1_x', 'glint_1_y', 'glint_2_x', 'glint_2_y', ...
        'glint_3_x', 'glint_3_y', 'glint_4_x', 'glint_4_y'};
    output_data = array2table(sample, 'VariableNames', colNames);

    % Save the simulated eye feature.
    filepath = sprintf('../../02 Data/01_simulated/00_raw/00_eye_feature');
    filename = sprintf('%s/%04.0f_X%+04.0f_Y%+04.0f_Z%+04.0f_dataset.csv', filepath, ...,
        file_number, eye_camera_position(1) * 1000, eye_camera_position(3) * 1000, ...,
        eye_camera_position(2) * 1000);
    writetable(output_data, filename);

    % Define the output matrix.
    colNames = {'target_x', 'target_y', 'pupil_x', 'pupil_y'};
    output_data = array2table(distribution, 'VariableNames', colNames);

    % Save the normalized eye feature.
    filepath = sprintf('../../02 Data/01_simulated/01_filtered/00_normalized');
    filename = sprintf('%s/%04.0f_X%+04.0f_Y%+04.0f_Z%+04.0f_dataset.csv', filepath, ...,
        file_number, eye_camera_position(1) * 1000, eye_camera_position(3) * 1000, ...,
        eye_camera_position(2) * 1000);
    writetable(output_data, filename);
