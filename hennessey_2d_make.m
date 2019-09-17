function et=hennessey_2d_make()
%  hennessey_2d_make  Creates pupil-CR tracker with linear interpolation
%    et = hennessey_2d_make() creates an eye tracker 'et' that uses linear
%    interpolation from the pupil-CR difference vector to screen coordinates.

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

    % Global variables
    global eye_camera_position;
    global user_position;

    et.calib_func=@hennessey_2d_calib;
    et.eval_func=@hennessey_2d_eval;

    % Create the camera
    et.cameras{1}=camera_make;
    et.cameras{1}.trans(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
    if (~isempty(eye_camera_position))
        et.cameras{1}.trans(1:3,4)=eye_camera_position;
    end
    et.cameras{1}.rest_trans=et.cameras{1}.trans;
    et.cameras{1}.err=0.0;
    et.cameras{1}.err_type='gaussian';
    if (~isempty(user_position))
        et.cameras{1}=camera_point_at(et.cameras{1}, user_position);
    else
        et.cameras{1}=camera_point_at(et.cameras{1}, [0 550e-3 350e-3 1]');
    end

    % Create lights
    et.lights{1}=light_make;
    et.lights{1}.pos=[ 200e-3 0 350e-3 1]';

    % Calibration points are at the edges of the monitor, halfway between the 
    % edges and the center of the monitor
    et.calib_points=[
        -200e-3  50e-3;
              0  50e-3;
         200e-3  50e-3;
        -200e-3 200e-3;
              0 200e-3;
         200e-3 200e-3;
        -200e-3 350e-3;
              0 350e-3;
         200e-3 350e-3]';
