function [gaze, cc_approx, gaze3d] = beymer_eval_base(et, camimg, e)
%  beymer_eval  Evaluation function helper for Beymer and Flickner's method

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

    % Cell-array to save needed camera information
    cam = cell(1,length(et.cameras));

    for i=1:length(et.cameras)
        cam{i}.pos= et.cameras{i}.trans(:,4);
        cam{i}.led_vec = cell(1,length(et.lights));
        cam{i}.cr_vec = cell(1,length(et.lights)); 

        % Determine CR directions in the two wide angle
        % cameras
        if i < 3
            cam{i}.cr3D= camera_unproject(et.cameras{i},...
                camimg{i}.cr{1}, 1);
            cam{i}.cr3D= cam{i}.cr3D-cam{i}.pos;
            cam{i}.cr3D= cam{i}.cr3D/norm(cam{i}.cr3D);
        else
            % Calculate CR position in space
            [cr_1,cr_2]=...
            lines_closest_point(cam{1}.pos, cam{1}.cr3D,...
                cam{2}.pos, cam{2}.cr3D);
            cr_3D_pos = (cr_1+cr_2)/2;

            % Obtain images of CR and PC in pan-tilt cameras
            et.cameras{i}= camera_pan_tilt(et.cameras{i},cr_3D_pos);
            cam{i}.camimg = camera_take_image(et.cameras{i},e,et.lights);

            % Determine all needed vectors for every used LED
            for s=1:length(et.lights)
                % Calculate the camera-LED-vectors for both cameras and all 
                % LEDs
                cam{i}.led_vec{s}= et.lights{s}.pos-cam{i}.pos;    
                cam{i}.led_vec{s}= cam{i}.led_vec{s}/norm(cam{i}.led_vec{s});

                % Calculate the 3D-coordinates of the CRs from the 2D camera 
                % image 
                cam{i}.cr_vec{s} = ...
                    camera_unproject(et.cameras{i},cam{i}.camimg.cr{s},1);

                % Calculate the camera-CR-vectors for both cameras and all
                % CRs
                cam{i}.cr_vec{s}= cam{i}.cr_vec{s}-cam{i}.pos;
                cam{i}.cr_vec{s}= cam{i}.cr_vec{s}/norm(cam{i}.cr_vec{s});  

                % Calculate the normal vectors of the planes defined by the 
                % camera-LED-vectors and the camera-CR-vectors  
                cam{i}.norm_vec(s,:)= ...
                    cross(cam{i}.cr_vec{s}(1:3),cam{i}.led_vec{s}(1:3))';

                cam{i}.norm_vec(s,:) =...
                    cam{i}.norm_vec(s,:)/norm(cam{i}.norm_vec(s,:));
             end 

            % Add an extra condition
            cam{i}.norm_vec= [cam{i}.norm_vec; [ 0 1 0]];   

            % Get the solutions of overconstrained system    
            cam{i}.b = [zeros(length(et.lights),1);1];
            cam{i}.cc_vec = cam{i}.norm_vec\cam{i}.b;
            cam{i}.cc_vec = cam{i}.cc_vec/norm(cam{i}.cc_vec);

            % Create homogeneous coordinates
            cam{i}.cc_vec = [cam{i}.cc_vec; 0];
         end
    end

    % Calculate the cornea center (closest point) from the two lines
    [cc_l1,cc_l2]= ...
                    lines_closest_point(cam{3}.pos,cam{3}.cc_vec,...
                                        cam{4}.pos,cam{4}.cc_vec);

    cc_approx = (cc_l1+cc_l2)/2;
    %cc_real=e.trans*e.pos_cornea
    %keyboard

    % Cornea center relative to cameras
    cam{3}.cc_vec = cc_approx - cam{3}.pos;
    cam{4}.cc_vec = cc_approx - cam{4}.pos;
    cam{3}.cc_vec = cam{3}.cc_vec/norm(cam{3}.cc_vec);
    cam{4}.cc_vec = cam{4}.cc_vec/norm(cam{4}.cc_vec);

    % Determine the pupil center from the 2D camera image
    cam{3}.pc_vec = camera_unproject(et.cameras{3},cam{3}.camimg.pc,1);
    cam{4}.pc_vec = camera_unproject(et.cameras{4},cam{4}.camimg.pc,1);

    cam{3}.pc_vec = cam{3}.pc_vec-cam{3}.pos;
    cam{3}.pc_vec = cam{3}.pc_vec/norm(cam{3}.pc_vec);

    cam{4}.pc_vec = cam{4}.pc_vec-cam{4}.pos;
    cam{4}.pc_vec = cam{4}.pc_vec/norm(cam{4}.pc_vec);

    % Plane equations for the gaze direction
    plane_equation(1,:)= cross(cam{3}.cc_vec(1:3),cam{3}.pc_vec(1:3))';
    plane_equation(1,:)= plane_equation(1,:)/norm(plane_equation(1,:));

    plane_equation(2,:)= cross(cam{4}.cc_vec(1:3),cam{4}.pc_vec(1:3))';
    plane_equation(2,:)= plane_equation(2,:)/norm(plane_equation(2,:));

    % Extra condition
    plane_equation(3,:)=[0 1 0];

    % Calculate the gaze direction
    % b(3) = -1 because of negative y-axis
    b=[ 0 0 -1]';
    gaze3d = [plane_equation\b; 0];

    gaze = intersect_ray_plane(cc_approx, gaze3d, [0 0 0 1]', [0 1 0 0]');
    gaze=[gaze(1), gaze(3)]';
