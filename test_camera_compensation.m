function test_camera_compensation(method, data, compensate, undistort)
%  test_camera_compensation  Tests the eye camera location compensation method
%    test_camera_compensation(method) tests the proposed eye camera location
%    compensation method to reduce the influence of eye camera location in the
%    eye tracker setup.
%
%    If 'method' defines the gaze estimation method to be used in the
%    simulation. For standard, the method is based on homography transformation.
%    You can also define if you want to compensation the pupil center
%    distribution distortion through the variable 'undistort'.

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

    % INFO: To use this script, you must install the Robotics Toolbox Matlab
    % available on https://github.com/petercorke/robotics-toolbox-matlab. Then
    % you must add the path of common folder (addpath rvctools/common) and start
    % up the toolbox (startup_rvc).
    % Define the global variables.
    global is_compensated;
    global is_undistorted;
    global eye_camera_position;
    global user_position;
    global is_glint_normalization;
    global polynomial;

    is_compensated = false;
    is_undistorted = false;

    % Adjust the arguments.
    if (nargin < 1)
        method='homography_test';
    end

    if (nargin < 2)
        data='screen';
    end

    if (nargin > 2)
        if (strcmp(compensate, 'on'))
            is_compensated = true;
        end
    end

    if (nargin > 3)
        if (strcmp(undistort, 'on'))
            is_undistorted = true;
        end
    end

    % Define the eye camera location in the world coordinate system.
    eye_camera_position = [0e-3 0e-3 0e-3];

    % Define the user location in the world coordinate system.
    user_position = [0 550e-3 350e-3 1]';

    % Remove the glint normalization.
    is_glint_normalization = false;

    % Define the polynomial used in the simulation.
    polynomial = @(x, y) [x^2 y^2 x*y x y 1]'; % Cerrolaza et al. (2008)

    % Execute the gaze estimation method.
    feval(method, data);

    % Clean all current variables.
    clear;
    clear global;
