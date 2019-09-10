function et=interpolate_make()
%  interpolate_make  Creates pupil-CR tracker with biquadratic interpolation
%    et = interpolate_make() creates an eye tracker 'et' that uses biquadratic
%    interpolation from the pupil-CR difference vector to screen coordinates.

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

    et.calib_func=@interpolate_calib;
    et.eval_func=@interpolate_eval;

    % Create the camera
    et.cameras{1}=camera_make;
    et.cameras{1}.trans(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
    et.cameras{1}.rest_trans=et.cameras{1}.trans;
    et.cameras{1}.err=0.0;
    et.cameras{1}.err_type='gaussian';
    et.cameras{1}=camera_point_at(et.cameras{1}, [0 550e-3 350e-3 1]');

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
