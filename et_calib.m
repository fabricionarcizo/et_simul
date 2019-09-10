function et = et_calib(et, e)
%  et_calib  Calibrates an eye tracker
%
%    et = et_calib(et, e) calibrates the eye tracker 'et' using the eye 'e'
%    and returns the calibrated eye tracker.
%
%    An eye tracker object contains the following properties:
%
%    'cameras'       A cell array of one or several camera objects.
%
%    'lights'        A cell array of one or several light objects.
%
%    'calib_points'  A 2-times-n matrix of calibration points. The calibration
%                    points are displayed on a "virtual monitor" in the
%                    x-z-plane.
%
%    'state'         A struct containing state information, depending on the
%                    type of eye tracker. Typically, 'state' contains
%                    information gathered during calibration.
%
%    'calib_func'    A function handle for the calibration function (see
%                    below).
%
%    'eval_func'     A function handle for the evaluation function (see
%                    below).
%
%
%    Calibration function
%    --------------------
%
%    The calibration function uses the positions of the pupil and the corneal
%    reflexes observed when the eye is fixating the various calibration points
%    to calibrate the eye tracker. It should have the following signature:
%
%        et = calib_func(et, calib_data)
%
%    where 'et' is the eye tracker object and 'calib_data' is a cell array
%    with as many entries as there are calibration points. For each
%    calibration point, calib_data contains:
%
%    - A cell array 'camimg' giving the positions of the corneal reflexes 
%      and pupil center in each camera image (as returned by 
%      camera_take_image()).
%
%    - An eye object 'e' giving the position and orientation of the eye 
%      when fixating the corresponding calibration point.
%
%    Example:
%    calib_data{5}.camimg{2}.cr{3}
%    This is the position of the third corneal reflex in the image of the
%    second camera, as seen when the observer is fixating the fifth
%    calibration point.
%
%    The calibration function should store the information obtained during
%    calibration in et.state.
%
%
%    Evaluation function
%    -------------------
%
%    The evaluation function uses the observed positions of the pupil and
%    the corneal reflexes along with the state information obtained during
%    calibration to compute a gaze position on the screen (gaze estimation).
%    It should have the following signature:
%
%      gaze = eval_func(et, camimg)
%
%    where 'et' is the eye tracker object (containing the state data that was
%    saved during calibration) and 'camimg' is a cell array containing the
%    positions of the corneal reflexes and pupil center in each camera image,
%    as returned by camera_take_image().

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

    % Various "features" -- i.e., how realistic is the model?
    global FEAT_REFRACTION FEAT_FOVEA_DISPLACEMENT
    FEAT_REFRACTION=1;
    FEAT_FOVEA_DISPLACEMENT=1;

    % Find CRs and PCs for calibration points
    calib_data=cell(1, size(et.calib_points,2));
    rand('state', 0);
    for i=1:size(et.calib_points,2)
        e=eye_look_at(e, [et.calib_points(1,i) 0 et.calib_points(2,i) 1]');

        % Take an image of the eye in the various cameras
        calib_data{i}.camimg=cell(1, length(et.cameras));
        for iCamera=1:length(et.cameras)
            calib_data{i}.camimg{iCamera}=camera_take_image( ...
                et.cameras{iCamera}, e, et.lights);
        end

        % Save the current position of the eye in the calibration data
        calib_data{i}.e=e;
    end

    % Calibration
    et=feval(et.calib_func, et, calib_data);
