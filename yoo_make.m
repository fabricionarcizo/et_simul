function et=yoo_make()
%  yoo_config  Creates an eye tracker using Yoo and Chung's method
%    et = hennessey_make(params) creates an eye tracker that uses the method
%    from [1].
%
%    [1] Dong Hyun Yoo and Myung Jin Chung. A novel non-intrusive eye gaze
%        estimation using cross-ratio under large head motion. Computer Vision
%        and Image Understanding 98, 25-51, 2005.

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

    et.calib_func=@yoo_calib;
    et.eval_func=@yoo_eval;

    % Create camera
    et.cameras=cell(1,1);
    et.cameras{1}=camera_make;
    et.cameras{1}.trans(1:3,1:3)=[1 0 0; 0 0 -1; 0 1 0];
    et.cameras{1}.rest_trans=et.cameras{1}.trans;
    et.cameras{1}.err=0.0;
    et.cameras{1}.err_type='uniform';
    et.cameras{1}=camera_point_at(et.cameras{1}, [0 550e-3 350e-3 1]');

    et.lights=cell(5,1);

    % Create four lights around the monitor
    et.lights{1}=light_make;
    et.lights{1}.pos=[200e-3 0 350e-3 1]';
    et.lights{2}=light_make;
    et.lights{2}.pos=[-200e-3 0 350e-3 1]';
    et.lights{3}=light_make;
    et.lights{3}.pos=[-200e-3 0 50e-3 1]';
    et.lights{4}=light_make;
    et.lights{4}.pos=[200e-3 0 50e-3 1]';

    % Create fifth light co-located with camera
    et.lights{5}=light_make;
    et.lights{5}.pos=[0 0 0 1]';

    % Calibration points are just the positions of the four lights around the
    % monitor
    et.calib_points=zeros(2,4);
    et.calib_points(:,1)=[  200e-3 350e-3 ]';
    et.calib_points(:,2)=[ -200e-3 350e-3 ]';
    et.calib_points(:,3)=[ -200e-3  50e-3 ]';
    et.calib_points(:,4)=[  200e-3  50e-3 ]';
