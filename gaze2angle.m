function angles = gaze2angle(gaze, rest_pos)
%  gaze2angle  Determines rotation angles of the eye from given gaze direction
%   angles = gaze2angle(gaze, rest_pos) calculates the rotation angles of the
%   eye for the gaze direction 'gaze', relative to the rest position of the
%   eye 'rest_pos' (specified as a 3x3 rotation matrix). angles(1) is the 
%   rotation angle in the x-z-plane, and angles(2) is the angle in the 
%   y-z-plane. If no rest position is specified, uses [1 0 0; 0 0 1; 0 1 0].

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

    if nargin<2
        rest_pos=[1 0 0; 0 0 1; 0 1 0];
    end

    % Translate gaze vector into the coordinate system of the rest position of
    % the eye
    gaze=rest_pos\gaze(1:3);

    angles=zeros(2,1);
    angles(1) = atan2(gaze(1), -gaze(3));
    angles(2) = atan2(gaze(2), norm(gaze([1,3])));
