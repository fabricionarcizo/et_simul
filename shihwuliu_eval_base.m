function [gaze, cc_approx, gaze3d] = shihwuliu_eval_base(et, camimg)
%  shiwuliu_eval_base  Evaluation function helper for Shih, Wu & Liu's method

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

    cam=cell(1,length(et.cameras));

    for j=1:length(et.cameras)

        cam{j}.pos = et.cameras{j}.trans(:,4);
        cam{j}.dist = norm(cam{j}.pos(1:3));
        cam{j}.led_vec = cell(1,length(et.lights));
        cam{j}.cr_vec = cell(1,length(et.lights));

        % Determine all needed vectors for every used LED
        for i=1:length(et.lights)
            % Calculate the camera-LED-vectors for both cameras and all LEDs
            cam{j}.led_vec{i}=et.lights{i}.pos-cam{j}.pos;
            cam{j}.led_vec{i}=cam{j}.led_vec{i}/norm(cam{j}.led_vec{i});

            % Calculate the 3D coordinates of the CRs from the 2D camera image
            cam{j}.cr_vec{i} = ...
                camera_unproject(et.cameras{j}, camimg{j}.cr{i}, 1);

            % Calculate the camera-CR-vectors for both cameras and all CRs
            cam{j}.cr_vec{i}=cam{j}.cr_vec{i}-cam{j}.pos;
            cam{j}.cr_vec{i}=cam{j}.cr_vec{i}/norm(cam{j}.cr_vec{i});

            % Calculate the normal vectors of the planes defined by the 
            % camera-LED-vectors and the camera-cr-vectors
            cam{j}.norm_vec(i,:)= ...
                cross(cam{j}.cr_vec{i}(1:3), cam{j}.led_vec{i}(1:3))';

            cam{j}.norm_vec(i,:) = ...
                cam{j}.norm_vec(i,:)/norm(cam{j}.norm_vec(i,:));
        end

        % Add an extra condition
        cam{j}.norm_vec= [cam{j}.norm_vec; [ 0 1 0]];

        % Get the solutions of overconstrained system
        cam{j}.b = [zeros(length(et.lights),1); 1];
        cam{j}.cc_vec = cam{j}.norm_vec\cam{j}.b;
        cam{j}.cc_vec = cam{j}.cc_vec/norm(cam{j}.cc_vec);

        % Create homogeneous coordinates
        cam{j}.cc_vec = [cam{j}.cc_vec; 0];
    end

    % Calculate the cornea center (closest point) from the two lines
    [cc_l1,cc_l2]= ...
                      lines_closest_point(cam{1}.pos,cam{1}.cc_vec,...
                                          cam{2}.pos,cam{2}.cc_vec);

    cc_approx = (cc_l1+cc_l2)/2;

    % Cornea center relative to cameras
    cam{1}.cc_vec = cc_approx - cam{1}.pos;
    cam{2}.cc_vec = cc_approx - cam{2}.pos;
    cam{1}.cc_vec = cam{1}.cc_vec/norm(cam{1}.cc_vec);
    cam{2}.cc_vec = cam{2}.cc_vec/norm(cam{2}.cc_vec);

    % Determine the pupil center from the 2D camera image
    cam{1}.pc_vec = camera_unproject(et.cameras{1}, camimg{1}.pc, 1);
    cam{2}.pc_vec = camera_unproject(et.cameras{2}, camimg{2}.pc, 1);

    cam{1}.pc_vec = cam{1}.pc_vec-cam{1}.pos;
    cam{1}.pc_vec = cam{1}.pc_vec/norm(cam{1}.pc_vec);

    cam{2}.pc_vec = cam{2}.pc_vec-cam{2}.pos;
    cam{2}.pc_vec = cam{2}.pc_vec/norm(cam{2}.pc_vec);

    % Plane equations for the gaze direction
    plane_equation(1,:)= cross(cam{1}.cc_vec(1:3),cam{1}.pc_vec(1:3))';
    plane_equation(1,:)= plane_equation(1,:)/norm(plane_equation(1,:));

    plane_equation(2,:)= cross(cam{2}.cc_vec(1:3),cam{2}.pc_vec(1:3))';
    plane_equation(2,:)= plane_equation(2,:)/norm(plane_equation(2,:));

    % Extra condition
    plane_equation(3,:)=[0 1 0];

    % Calculate the gaze direction
    % b(3) = -1 because of negative y-axis
    b=[ 0 0 -1]';
    gaze3d = [plane_equation\b; 0];

    gaze = intersect_ray_plane(cc_approx, gaze3d, [0 0 0 1]', [0 1 0 0]');
    gaze=[gaze(1), gaze(3)]';
