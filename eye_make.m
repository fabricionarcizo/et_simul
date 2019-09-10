function e=eye_make(r_cornea, rest_pos)
%  eye_make  Creates a structure that represents an eye
%    e = eye_make(r_cornea, rest_pos) creates an eye object 'e' with corneal
%    curvature radius 'r_cornea' and rest position 'rest_pos' (a 3x3 rotation 
%    matrix, see below for details).
%
%    e = eye_make() creates an eye with a default corneal radius and rest
%    position.
%
%    The center of rotation of the eye lies at the origin of the local eye 
%    coordinate system. The optical axis of the eye points out along the
%    negative z axis. The x axis lies in the horizontal plane, the y axis in
%    the sagittal plane.
%
%    The eye object 'e' that is produced contains the following elements:
%
%    - 'trans' is the transformation matrix from eye to world coordinates.
%
%    - 'rest_pos' is a 3x3 rotation matrix that specifies the rest position of
%      the eye -- i.e. a transformation that rotates the local eye coordinate
%      system into the rest position of the eye in world coordinates. The rest
%      position is important for computing the amount of torsion that occurs
%      during eye rotations (as given by Listing's law).
%
%   - 'r_cornea' is the radius of corneal curvature (the cornea is modeled as
%     a spherical surface).
%
%   - 'pos_cornea' is the corneal curvature center.
%
%   - 'r_cornea_inner' is the curvature radius of the cornea's inner surface.
%
%   - 'cornea_inner_center' is the curvature center of the cornea's inner
%     surface.
%
%   - 'n_cornea' is the refractive index of the cornea.
%
%   - 'n_aqueous_humor' is the refractive index of the aqueous humor.
%
%   - 'pos_apex' is the position of the apex (the frontmost part of the
%     cornea).
%
%   - 'depth_cornea' is the distance, measured on the optical axis, between
%     the cornea apex and the projection of the limbus (the boundary of the
%     cornea) onto the optical axis.
%
%   - 'pos_pupil' is the position of the center of the pupil.
%
%   - 'across_pupil' and 'up_pupil' are two orthogonal vectors that extend 
%    from the center of the pupil to its border. Any position on the pupil's
%    border can thus be obtained by taking
%
%        pos_pupil + cos(alpha)*across_pupil + sin(alpha)*up_pupil

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

    % Center of spherical part of eye (which should correspond pretty well to
    % the center of rotation) is at the origin in eye coordinates. The eye
    % looks out along the negative z axis.

    r_cornea_default=7.98e-3;

    if nargin<1
        r_cornea=r_cornea_default;
    end
    scale=r_cornea/r_cornea_default;

    if nargin<2
        rest_pos=eye(3);
    end

    e.trans=eye(4);
    e.trans(1:3, 1:3)=rest_pos;
    e.rest_pos=rest_pos;

    % Radius of the cornea
    e.r_cornea=r_cornea;

    % Center of the cornea in eye coordinates
    e.pos_cornea=[0 0 -scale*(24.75e-3 - 2*10.20e-3) 1]';

    % Radius of inner surface of cornea
    e.r_cornea_inner=scale*6.22e-3;

    % Center of curvature of the inner surface of the cornea
    e.cornea_inner_center=e.pos_cornea- ...
        [0 0 e.r_cornea - e.r_cornea_inner - scale*1.15e-3 0]';

    % Refractive index of cornea
    e.n_cornea=1.376;

    % Refractive index of aqueous humor
    e.n_aqueous_humor=1.336;

    % Apex (frontmost part of cornea) in eye coordinates
    e.pos_apex=e.pos_cornea+[0 0 -e.r_cornea 0]';

    % Depth of the cornea
    e.depth_cornea=scale*3.54e-3;

    % Center of the pupil in eye coordinates
    e.pos_pupil=e.pos_apex+[0 0 scale*3.54e-3 0]';

    % "Across" and "Up"-vectors defining the pupil disk
    e.across_pupil=scale*3e-3*[1 0 0 0]';
    e.up_pupil=scale*3e-3*[0 1 0 0]';
