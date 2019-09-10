function et = shihwuliu_make(params)
%  shiwuliu_make  Creates an eye tracker using Shih, Wu and Liu's method
%    et = shihwuliu_make(params) creates an eye tracker that uses the method
%    from [1]. Parameters can be specified using a struct 'params' containing
%    one or more of the following fields; default values are used for fields
%    that are not specified or if no 'params' argument is passed in.
%
%    - 'num_lights' specifies the number of lights that should be used
%
%    - 'num_calib_points' specifies the number of calib points to be used
%
%    - 'err' the camera error in pixels, 'err_type' has to be 'uniform' or 
%      'gaussian'
%
%    - 'focal_length' the focal length of the camera
%
%    - 'recalib_type' is the type of recalibration to use. Valid values are
%      'fixed', 'angle', 'hennessey', and 'screen'. The recalibration types
%      are described in detail in the documentation for the recalibration
%      routines recalib_<r>_calib() (where <r> is the name of the
%      recalibration type).
%
%    [1] Sheng-Wen Shih, Yu-Te Wu and Jin Liu. A Calibration-Free Gaze
%        Tracking Technique. International Conference on Pattern Recognition,
%        Vol. 4, 201-204, 2000.

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

    % If no parameters passed, use defaults
    if nargin < 1
        params=struct([]);
    end

    % Default parameters
    default_params.num_lights=2;
    default_params.num_calib_points=7;
    default_params.err=0.0;
    default_params.err_type='uniform';
    default_params.focal_length=2880;
    default_params.recalib_type='angle';

    % Obtain parameter values by overwriting those fields in the default
    % parameters that were also specified in 'params'
    params=merge_fields(default_params, params);

    et.calib_func=@shihwuliu_calib;
    et.eval_func=@shihwuliu_eval;
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

    % Create two cameras
    cam_pos=[-200e-3 0 0; 200e-3 0 0]';
    et.cameras=cell(2,1);
    for j=1:2
        et.cameras{j}=camera_make;
        et.cameras{j}.err=params.err;
        et.cameras{j}.err_type=params.err_type;
        et.cameras{j}.focal_length=params.focal_length;
        et.cameras{j}.trans(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
        et.cameras{j}.trans(1:3,4)=cam_pos(:,j);
        et.cameras{j}.rest_trans=et.cameras{j}.trans;
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
