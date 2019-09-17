function et=homography_make()
%  homography_make  Creates an eye tracker based on Hansen et al. (2010) method
%    et = homography_make() creates an eye tracker 'et' that uses homography
%    transformation from the pupil center to screen/scene coordinates.

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

    et.calib_func=@homography_calib;
    et.eval_func=@homography_eval;

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
    et.lights{1}.pos=[ -200e-3 0 350e-3 1]';
    et.lights{2}=light_make;
    et.lights{2}.pos=[  200e-3 0 350e-3 1]';
    et.lights{3}=light_make;
    et.lights{3}.pos=[  200e-3 0  50e-3 1]';
    et.lights{4}=light_make;
    et.lights{4}.pos=[ -200e-3 0  50e-3 1]';

    % Calibration points are at the edges of the monitor, halfway between the 
    % edges and the center of the monitor
    et.calib_points=[
        -200e-3 50e-3;
           0e-3 50e-3;
         200e-3 50e-3;
        -200e-3 200e-3;
           0e-3 200e-3;
         200e-3 200e-3;
        -200e-3 350e-3;
           0e-3 350e-3;
         200e-3 350e-3]';
