function et = beymer_make(params)
%  beymer_make  Creates an eye tracker using Beymer and Flickner's method
%    The method uses the setup from
%
%    David Beymer and Myron Flicker. Eye Gaze Tracking Using an Active Stereo
%    Head. Computer Vision and Pattern Recognition, Vol. 2, 451-458, 2003.
%
%    The actual gaze estimation algorithm is the same as that used in the
%    shihwuliu_* method.
%
%    params is a structure containing the following parameters:
%
%    - 'num_lights' specifies the number of lights that should be used
%
%    - 'num_calib_points' specifies the number of calib points to be used
%
%    - 'err' is the camera error in pixels, 'err_type' has to be 'uniform' or 
%      'gaussian'
%
%    - 'focal_length_1_2' is the focal length of the two wide angle cameras
%
%    - 'focal_length_3_4' is the focal length of the two narrow angle cameras 
%
%    - 'recalib_type' is the type of recalibration to use. Valid values are
%      'fixed', 'angle', 'hennessey', and 'screen'. The recalibration types
%      are described in detail in the documentation for the recalibration
%      routines recalib_<r>_calib() (where <r> is the name of the
%      recalibration type).

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

    % If no parameters passed, use defaults
    if nargin < 1
        params=struct([]);
    end

    % Default parameters
    default_params.num_lights=2;
    default_params.num_calib_points=7;
    default_params.err=0.0;
    default_params.err_type='uniform';
    default_params.focal_length_1_2=2880;
    default_params.focal_length_3_4=7330;
    default_params.recalib_type='angle';

    % Obtain parameter values by overwriting those fields in the default
    % parameters that were also specified in 'params'
    params=merge_fields(default_params, params);

    et.calib_func=@beymer_calib;
    et.eval_func=@beymer_eval;
    et.state.recalib_type=params.recalib_type;

    % Create lights
    light_pos=[
        -200e-3 0 50e-3 1;
         200e-3 0 50e-3 1;
        -200e-3 0 350e-3 1;
         200e-3 0 350e-3 1;
           0    0 350e-3 1;]';
    et.lights=cell(params.num_lights,1);
    for j=1:params.num_lights
        et.lights{j}=light_make;
        et.lights{j}.pos=light_pos(:,j);
    end

    % Create four cameras, the first and the second are wide angle cameras, 
    % the two others narrow angle cameras
    cam_pos=[0 0 0; 0 0 50e-3; -200e-3 0 0; 200e-3 0 0]';
    et.cameras=cell(4,1);
    for j=1:4
        et.cameras{j}= camera_make;
        et.cameras{j}.trans(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
        et.cameras{j}.err=params.err;
        et.cameras{j}.err_type=params.err_type;
        if j==1 | j==2
            % Wide angle
            et.cameras{j}.focal_length=params.focal_length_1_2;
        else
            % Narrow angle
            et.cameras{j}.focal_length=params.focal_length_3_4;
        end
        et.cameras{j}.trans(1:3,4)=cam_pos(:,j);
        et.cameras{j}.rest_trans = et.cameras{j}.trans;
        et.cameras{j}=camera_point_at(et.cameras{j}, [0 550e-3 350e-3 1]');
    end

    % calibration points
    et.calib_points=[-200e-3 350e-3; 
        200e-3 350e-3;
        -200e-3 200e-3;
        200e-3 200e-3;
        0e-3 200e-3;
        -200e-3  50e-3;
        200e-3  50e-3]';
    et.calib_points=et.calib_points(:,1:params.num_calib_points);
