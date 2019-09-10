function gaze=angle2gaze(angles, rest_pos)
%  angle2gaze  Calculates gaze direction from rotation angles
%    gaze = angle2gaze(angles, rest_pos) calculates a gaze direction from 
%    Euler rotation angles. angles(1) is the rotation angle in the 
%    x-z-plane (applied last), and angles(2) is the rotation angle in the 
%    y-z-plane (applied first). 'rest_pos' is a 3x3 rotation matrix specifying
%    the rest position of the eye; if no rest position is specified, uses
%    [1 0 0; 0 0 1; 0 1 0].

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

    rotat_matrix_x_z = [cos(angles(1))  0 -sin(angles(1)) 0; ...
                        0               1  0              0; ...
                        sin(angles(1))  0  cos(angles(1)) 0; ...
                        0               0  0              1];

    rotat_matrix_y_z = [ 1  0               0              0 ; ...
                         0  cos(angles(2)) -sin(angles(2)) 0 ; ...
                         0  sin(angles(2))  cos(angles(2)) 0 ; ...
                         0  0               0              1];

    % Expand rest_pos to homogeneous coordinates
    rest_pos=[rest_pos [0 0 0]'; 0 0 0 1];

    gaze=rest_pos*rotat_matrix_x_z*rotat_matrix_y_z*[0 0 -1 0]';
