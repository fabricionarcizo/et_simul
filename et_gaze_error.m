function  [u, v] = et_gaze_error(et, e, look_at_pos)
%  et_gaze_error  Performs gaze estimation and computes error
%    [u, v] = et_gaze_error(et, e, look_at_pos) computes the gaze estimation
%    error made by the eye tracker 'tracker' when the eye 'e' is looking at
%    the screen position 'look_at_pos' (a two-dimensional vector specifying
%    the fixated point in the x-z plane). The horizontal and vertical 
%    component of the gaze error are returned in 'u' and 'v'.

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

    % Point eye at the target position
    e=eye_look_at(e, [look_at_pos(1) 0 look_at_pos(2) 1]');

    camimg=cell(1, length(et.cameras));

    for iCamera=1:length(et.cameras)
        camimg{iCamera}=camera_take_image(et.cameras{iCamera}, e, et.lights);
    end

    % Find gaze point
    if nargin(et.eval_func)<3
        gaze=feval(et.eval_func, et, camimg);
    else
        gaze=feval(et.eval_func, et, camimg, e);
    end

    u=gaze(1)-look_at_pos(1);
    v=gaze(2)-look_at_pos(2);
