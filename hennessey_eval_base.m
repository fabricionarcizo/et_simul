function [gaze, cc_estim, gaze3d]=hennessey_eval_base(et, camimg)
%  hennessey_eval_base  Evaluation function helper for Hennessey et al.

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

    r_cornea_assumed=7.98e-3*(1+et.state.parameter_err);
    rpc_assumed=4.44e-3*(1+et.state.parameter_err);

    % Find CC
    cc_estim=estimate_cc_hennessey(et.cameras{1}, et.lights, camimg{1}.cr, ...
        r_cornea_assumed);

    % Find position of PC using ray-sphere-intersection
    switch et.state.pupil_alg
        case 'hennessey'
            % Bring CC into camera coordinate system and compute distance
            cc_cam=et.cameras{1}.trans\cc_estim;
            d_cc=-cc_cam(3);

            % Fit ellipse to pupil image and compute radius of pupil
            % Do Hennessey et al. take into account that the cornea magnifies
            % the image of the pupil? At any rate, we apply an empirical
            % correction to try and compensate for this.
            a=fitellipse_hf(camimg{1}.pupil(1,:), camimg{1}.pupil(2,:));
            r_pupil=max(a(3:4));
            r_pupil=r_pupil/et.cameras{1}.focal_length*d_cc;
            % Empirical correction
            r_pupil=r_pupil/1.165;

            % Unproject pupil contour
            pupil_rays= ...
                camera_unproject(et.cameras{1}, camimg{1}.pupil, 1.0) - ...
                repmat(et.cameras{1}.trans(:,4), 1, size(camimg{1}.pupil, 2));

            % Initialize array of pupil points
            pupil_points=zeros(size(pupil_rays));

            % Refract pupil contour rays
            pupil_points=zeros(4,0);
            for j=1:size(pupil_rays, 2)
                % Refract ray at cornea. If we don't hit the cornea, ignore
                % the ray.
                [U0, Ud]=refract_ray_sphere(et.cameras{1}.trans(:,4), ...
                    pupil_rays(:,j), cc_estim, r_cornea_assumed, 1, 1.376);
                if isempty(U0)
                    continue;
                end

                % Intersect refracted ray with sphere around cornea center to
                % find pupil contour point. If we don't hit the sphere, ignore
                % the ray.
                pt=intersect_ray_sphere(U0, Ud, cc_estim, ...
                    sqrt(rpc_assumed^2+r_pupil^2));
                if ~isempty(pt)
                    pupil_points(:,j)=pt;
                end
            end

            pc_estim=mean(pupil_points,2);
        case 'pupil_center'
            % This doesn't use the actual Hennessey algorithm. Instead, we
            % reproject the pupil center into the eye and intersect with a 
            % sphere of radius r_pc around the cornea center
            dir=camera_unproject(et.cameras{1}, camimg{1}.pc, 1.0) - ...
                et.cameras{1}.trans(:,4);
            [U0, Ud]=refract_ray_sphere(et.cameras{1}.trans(:,4), dir, ...
                cc_estim, r_cornea_assumed, 1, 1.376);
            pc_estim=intersect_ray_sphere(U0, Ud, cc_estim, rpc_assumed);
        otherwise
            error('Unknown pupil finder algorithm');
    end

    % Compute 3D direction of gaze
    gaze3d=pc_estim-cc_estim;
    gaze3d=gaze3d/norm(gaze3d);

    x=intersect_ray_plane(cc_estim, gaze3d, [0 0 0 1]', ...
        [0 1 0 0]');
    gaze=[x(1) x(3)]';
