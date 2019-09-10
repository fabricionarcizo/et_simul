function [et, pupils] = camera_location_compensation(et, pupils)
%  camera_location_compensation  Compensate the influence of eye camera location
%  in different position in the eye tracker setup

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

    % Calibration data
    N = size(et.calib_points, 2);
    targets = ones(3, N);

    % Second-order polynomial
    X = ones(6, N);
    for i=1:N
        pc = pupils(:, i);
        X(:, i) = [pc(1)^2 pc(2)^2 pc(1)*pc(2) pc(1) pc(2) 1]';
    end

    % Targets in the normalized plane
    targets(1, 1:3:N) = -1;
    targets(1, 2:3:N) = 0;
    targets(2, 1:3) = -1;
    targets(2, 4:6) = 0;

    % Fit data
    et.state.Ten = targets / X;

    % Fill out the pupil matrix
    for i=1:N

        % Get the pupil center for each calibration point and normalize it
        pc = pupils(:, i);
        pc = et.state.Ten * [pc(1)^2 pc(2)^2 pc(1)*pc(2) pc(1) pc(2) 1]';

        pupils(:, i) = [pc(1:2); 1];
    end
