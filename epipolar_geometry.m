function epipolar_geometry(et, e) 

    % Seven is the minimum number of calibration targets to calculate the
    % epipolar geometry
    N = length(et.calib_points);
    if N > 7

        % Calibration data
        pupils = ones(3, N);
        targets = ones(3, N);
        targets(1:2, :) = et.calib_points;

        for i=1:N
            % Look at a target on the screen
            e=eye_look_at(e, [targets(1, i) 0 targets(2, i) 1]');

            % Take a photo from the eye
            camimg = camera_take_image(et.cameras{1}, e, et.lights);

            % Get the current pupil center
            pupils(1:2, i) = camimg.pc;
        end

        % Calculate the fundamental matrix (F)
        F = FundamentalMatrix(pupils, targets);
        colors = rand(3, N);

        % Plot the first view
        figure(2);
        h1 = subplot(2, 1, 1);
        cla(h1);
        hold('on');

        % Define the plot axes
        min_x = min(targets(1, :)) - 0.05;
        max_x = max(targets(1, :)) + 0.05;
        min_y = min(targets(2, :)) - 0.05;
        max_y = max(targets(2, :)) + 0.05;
        axis([min_x max_x min_y max_y]);

        % X coordinates in the plot
        line_x = linspace(min_x, max_x);

        % Draw the epipolar geometry between the targets and pupils
        for i=1:N

            % Epipolar line
            line = F * pupils(:, i);
            line = [-line(1), -line(3)] / line(2);
            line_y = polyval(line, line_x);

            % Plot the epipolar geometry
            plot(line_x, line_y, 'color', colors(:, i));
            plot(targets(1, i), targets(2, i), ...
                 'MarkerEdgeColor','k', 'MarkerFaceColor', colors(:, i), ...
                 'MarkerSize', 7, 'marker', 'o');
        end

        hold('off');

        % Plot the second view.
        h2 = subplot(2, 1, 2);
        cla(h2)
        hold('on');

        % Define the plot axes
        min_x = min(pupils(1, :)) - 0.5;
        max_x = max(pupils(1, :)) + 0.5;
        min_y = min(pupils(2, :)) - 0.5;
        max_y = max(pupils(2, :)) + 0.5;
        axis([min_x max_x min_y max_y]);

        % X coordinates in the plot
        line_x = linspace(min_x, max_x);

        % Draw the epipolar geometry between the pupils and targets
        for i=1:N

            % Epipolar line.
            line = F' * targets(:, i);
            line = [-line(1), -line(3)] / line(2);
            line_y = polyval(line, line_x);

            % Plot the epipolar geometry
            plot(line_x, line_y, 'color', colors(:, i));
            plot(pupils(1, i), pupils(2, i), ...
                 'MarkerEdgeColor','k', 'MarkerFaceColor', colors(:, i), ...
                 'MarkerSize', 7, 'marker', 'o');
        end

        hold('off');

    end
