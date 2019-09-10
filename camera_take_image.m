function camimg=camera_take_image(camera, e, lights)
%  camera_take_image  Computes the image of an eye seen by a camera
%    camimg = camera_take_image(camera, e, lights) computes the image of the
%    eye 'e' as seen by the camera 'camera'. 'lights' is a cell array of light
%    objects that generate CRs on the cornea. The function returns a structure
%    'camimg' containing the following:
%    'cr'     An n-element cell array containing the positions of the n
%             corneal reflexes in the camera image. If the reflex did not fall
%             within the cornea, or if the reflex fell outside the camera
%             image, [] is returned for the corresponding CR.
%    'pc'     A two-element vector with the position of the pupil center in
%             the camera image. If the pupil fell outside the camera image, []
%             is returned.
%    'pupil'  A 2-times-n matrix with the positions of n points on the pupil
%             border in the camera image. The number of points can depend on
%             how much of the pupil is visible in the image; if the pupil is
%             outside the image, a 2-times-0 matrix is returned.

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

    % Find the CRs
    cr=cell(length(lights),1);
    for k=1:length(lights)
        cr_3d=eye_find_cr(e, lights{k}, camera);

        if isempty(cr_3d)
            cr{k}=[];
        else
            cr{k}=camera_project(camera, cr_3d);
            if any(isnan(cr{k}))
                cr{k}=[];
            end
        end
    end
    camimg.cr=cr;

    % Find the PC
    [camimg.pupil, camimg.pc]=get_pc(e, camera);

function [pupil, pc]=get_pc(e, c);
% get_pc  Determines position of pupil in camera image
%   pc = get_pc(e, c) finds the image of the pupil border in the camera image
%   (returned as 'pupil'), then fits an ellipse to those points and returns
%   the center of the ellipse in 'pc'.
    global FEAT_REFRACTION

    % Use this to switch between the simple pupil image and one that uses
    % refraction
    if FEAT_REFRACTION
        % Get pupil image
        pupil=eye_get_pupil_image(e, c);

        % Find center of pupil
        if size(pupil,2)>=5
            pc=fitellipse_hf(pupil(1,:), pupil(2,:));
            pc=pc(1:2)';
        else
            pc=[];
        end
    else
        pupil=eye_get_pupil(e);
        [pupil,dists,valid]=camera_project(c, pupil);
        pupil=pupil(:,valid);

        pc=camera_project(c, e.trans*e.pos_pupil);
        if any(isnan(pc))
            pc=[];
        end
    end
