function [gaze, cc_estim, gaze3d]=hennessey_eval(et, camimg)
%  hennessey_eval  Evaluation function for Hennessey et al.'s method

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

    [gaze, cc_estim, gaze3d]=hennessey_eval_base(et, camimg);

    % Perform angle recalibration if desired
    switch et.state.recalib_type
        case 'angle'
            gaze3d=recalib_angle_eval(et.state.recalib_angle, gaze3d);
        case 'henn_angle'
            gaze3d=recalib_henn_angle_eval(et.state.recalib_henn_angle, ...
                gaze3d);
        case 'henn3d'
            gaze3d=recalib_henn3d_eval(et.state.recalib_henn3d, gaze3d);
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
