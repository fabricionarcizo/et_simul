function success=test_gaze2angle()
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

    % Define observer position
    observer_pos=[0 500e-3 200e-3 1]';

    success=1;

    % Generate gaze vectors
    for x=-0.2:0.05:0.2
        for y=0.05:0.05:0.35
            gaze=[x 0 y 1]'-observer_pos;
            gaze=gaze/norm(gaze);

            % Convert gaze to angles and back
            angles=gaze2angle(gaze);
            gaze_new=angle2gaze(angles);

            % Check that both are equal
            if norm(gaze-gaze_new)>1e-8
                success=false;
            end
        end
    end
