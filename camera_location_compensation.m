function [et, pupils] = camera_location_compensation(et, pupils)
%  camera_location_compensation  Compensate the influence of eye camera location
%  in different position in the eye tracker setup

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

    % Global variables.
    global rvc_cam;

    % Normalized space.
    unit = mkgrid(3, 1, 'pose', SE3(0.5, 0.5, 1.0));

    % Camera resolution.
    w = rvc_cam.npix(1);
    h = rvc_cam.npix(2);

    % Projecion matrix 2D -> 3D.
    A1 = [1 0 -w/2; 0 1 -h/2; 0, 0, 0; 0, 0, 1];

    % R - rotation matrix.
    R = eye(4);
    R(1:3, 1:3) = rvc_cam.estpose(unit, pupils(1:2, :)).R';

    % Camera matrix.
    Kcam = rvc_cam.K;

    % T - translation matrix.
    T = eye(4);
    T(3, 4) = Kcam(1, 1);

    % K - intrinsic matrix.
    K = eye(3, 4);
    K(1:3, 1:3) = Kcam;

    % Inverse Perspective Mapping.
    et.state.M = K * (T * (R * A1));
%{
    % Midpoint
    q = pupils(:, 5);
    q = et.state.M * q;
    q = q / q(3);

    et.state.T = eye(3);
    et.state.T(1, 3) = (w/2) - q(1);
    et.state.T(2, 3) = (h/2) - q(2);
%}
    % Transformed points.
    p = et.state.M * pupils;
    pupils = bsxfun(@rdivide, p, p(3, :));
%    pupils = et.state.T * pupils;
