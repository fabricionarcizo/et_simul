function test_moving_camera(method, data)
%  test_moving_camera  Tests the eye camera location compensation method
%    test_moving_camera(method) tests the proposed eye camera location
%    compensation method to reduce the influence of eye camera location in the
%    eye tracker setup.
%
%    If 'method' defines the gaze estimation method to be used in the
%    simulation. For standard, the method is based on homography transformation.
%    You can also define if you want to compensation the pupil center
%    distribution distortion through the variable 'undistort'.

%    Copyright 2020 Fabricio Batista Narcizo and the IT University of Copenhagen
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
    global eye_camera_position;
    global user_position;
    global file_number;
    global FEAT_REFRACTION;

    FEAT_REFRACTION = 1;

    % Adjust the arguments.
    if (nargin < 1)
        method='homography_test';
    end

    if (nargin < 2)
        data='simulated';
    end

    % Define the user location in the world coordinate system.
    user_position = [0 550e-3 350e-3 1]';

    % Define the camera positions grid.
    N=5;
    X=linspace(-200e-3,  200e-3,  N);
    Y=linspace(  50e-3,  350e-3,  N);
    Z=linspace( 500e-3,    0e-3, 11);

    file_number = 0;
    for i=1:length(X)
        for j=1:length(Y)
            for k=1:length(Z)
                % Define the eye camera location in the world coordinate system.
                eye_camera_position = [X(i) Z(k) Y(j)];

                % Execute the gaze estimation method.
                fprintf('%03d: ', file_number);
                feval(method, data);
                file_number = file_number + 1;
            end
        end
    end

    % Clean all current variables.
    clear;
    clear global;