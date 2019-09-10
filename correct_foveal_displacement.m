function out=correct_foveal_displacement(out, alpha)
%  correct_foveal_displacement  Correct gaze for foveal displacement
%    out = correct_foveal_displacement(out, alpha) corrects the gaze vector
%    'out' (parallel to the optical axis of the eye) for an angular offset
%    'alpha' between the optical axis and the visual axis and returns the
%    corrected gaze vector (parallel to the visual axis of the eye) in 'out'.

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

    % Do the unrotation using Listing's law
    % TODO: Make rest position configurable
    rest_pos=[1 0 0; 0 0 1; 0 1 0];
    out_rest=rest_pos*[0 0 -1]';

    % Calculate the rotation that Listing's law would use to take the rest
    % vector to the current out vector
    eye_to_world=listings_law(out_rest, out)*rest_pos;

    A=[cos(-alpha) 0 -sin(-alpha); 0 1 0; sin(-alpha) 0 cos(-alpha)];

    out=eye_to_world*A*inv(eye_to_world)*out;
