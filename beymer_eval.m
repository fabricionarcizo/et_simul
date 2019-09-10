function [gaze, cc_estim, gaze3d]=beymer_eval(et, camimg, e)
%  beymer_eval  Evaluation function for Beymer and Flickner's method

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

    [gaze, cc_estim, gaze3d]=beymer_eval_base(et, camimg, e);

    % Perform angle recalibration if desired
    switch et.state.recalib_type
        case 'angle'
            gaze3d=recalib_angle_eval(et.state.recalib_angle, gaze3d);
        case 'fixed'
            gaze3d(1:3)= correct_foveal_displacement(gaze3d(1:3), ...
                6*pi/180);
    end

    % Intersect the gaze line with the plane to see where it hits
    x=intersect_ray_plane(cc_estim, gaze3d, [0 0 0 1]', ...
        [0 1 0 0]');
    gaze=[x(1) x(3)]';

    % Perform screen-coordinate recalibration if desired
    switch et.state.recalib_type
        case 'hennessey'
            gaze=recalib_hennessey_eval(et.state.recalib_hennessey, gaze);
        case 'screen'
            gaze=recalib_screen_eval(et.state.recalib_screen, gaze);
    end
