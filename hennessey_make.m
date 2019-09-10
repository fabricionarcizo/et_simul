function et=hennessey_make(params)
%  hennessey_make  Create an eye tracker that uses Hennessey et al.'s method
%    et = hennessey_make(params) creates an eye tracker that uses the method
%    from [1]. Parameters can be specified using a struct 'params' containing
%    one or more of the following fields; default values are used for fields
%    that are not specified or if no 'params' argument is passed in.
%
%    - 'recalib_type' is the type of recalibration to use. Valid values are
%      'angle', 'henn_angle', 'henn3d', 'hennessey', and 'screen'. The
%      recalibration types are described in detail in the documentation for
%      the recalibration routines recalib_<r>_calib() (where <r> is the name of
%      the recalibration type).
%
%    - 'pupil_alg' is the algorithm to use for estimating the pupil center.
%      Valid values are: 'hennessey' (uses the original algorithm from the
%      paper, where individual rays to pupil contour points are traced back
%      into the eye) and 'pupil_center' (where the pupil center is determined
%      by fitting an ellipse to the pupil in the image and a single ray to
%      this pupil center is traced back into the ray)
%
%    - 'err' and 'err_type' are the amount and type of camera error, specified
%      as described in camera_make().
%
%    - 'parameter_err' is the amount of relative error in the eye model
%      parameters assumed by the algorithm relative to their true values in
%      the simulated eye.
%
%    [1] Craig Hennessey, Borna Noureddin, Peter Lawrence. A Single Camera
%        Eye-Gaze Tracking System with Free Head Motion. ETRA 2006.

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
    if nargin<1
        params=struct([]);
    end

    % Default parameters
    default_params.recalib_type='hennessey';
    default_params.pupil_alg='hennessey';
    default_params.err=0.0;
    default_params.err_type='uniform';
    default_params.parameter_err=0.0;

    % Obtain parameter values by overwriting those fields in the default
    % parameters that were also specified in 'params'
    params=merge_fields(default_params, params);

    et.calib_func=@hennessey_calib;
    et.eval_func=@hennessey_eval;
    et.state.recalib_type=params.recalib_type;
    et.state.pupil_alg=params.pupil_alg;
    et.state.parameter_err=params.parameter_err;

    % Create camera
    et.cameras=cell(1,1);
    et.cameras{1}=camera_make;
    et.cameras{1}.trans(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
    et.cameras{1}.rest_trans=et.cameras{1}.trans;
    et.cameras{1}.err=params.err;
    et.cameras{1}.err_type=params.err_type;
    et.cameras{1}=camera_point_at(et.cameras{1}, [0 550e-3 350e-3 1]');

    % Create lights (on vertical edge of monitor)
    et.lights=cell(2,1);
    et.lights{1}=light_make;
    et.lights{1}.pos=[200e-3 0 50e-3 1]';
    et.lights{2}=light_make;
    et.lights{2}.pos=[200e-3 0 300e-3 1]';

    if 1
        % Nine-point calibration pattern
        et.calib_points=zeros(2,9);
        et.calib_points(:,1)=[    0    200e-3 ]';
        et.calib_points(:,2)=[ -150e-3  50e-3 ]';
        et.calib_points(:,3)=[ -150e-3 350e-3 ]';
        et.calib_points(:,4)=[  150e-3  50e-3 ]';
        et.calib_points(:,5)=[  150e-3 350e-3 ]';
        et.calib_points(:,6)=[ -100e-3 150e-3 ]';
        et.calib_points(:,7)=[ -100e-3 250e-3 ]';
        et.calib_points(:,8)=[  100e-3 150e-3 ]';
        et.calib_points(:,9)=[  100e-3 250e-3 ]';
    else
        % Calibration points are just the corners of the screen
        et.calib_points=zeros(2,4);
        et.calib_points(:,1)=[ -200e-3  50e-3 ]';
        et.calib_points(:,2)=[  200e-3  50e-3 ]';
        et.calib_points(:,3)=[ -200e-3 350e-3 ]';
        et.calib_points(:,4)=[  200e-3 350e-3 ]';
    end
