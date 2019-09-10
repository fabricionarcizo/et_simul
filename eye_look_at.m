function e=eye_look_at(e, pos)
%  eye_look_at  Rotates an eye to look at a given position in space
%    e=eye_look_at(e, pos) rotates the eye 'e' to look at the
%    three-dimensional position 'pos' in world coordinates and returns the
%    rotated eye. Listing's law is used to compute the amount of torsion that
%    occurs. If the global variable FEAT_FOVEA_DISPLACEMENT is true, the
%    displacement of the fovea from the optical axis is taken into account
%    (i.e. the line-of-sight will be aligned with the given position, not the
%    optical axis).

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

    global FEAT_FOVEA_DISPLACEMENT

    % Calculate "out" vector
    out=pos(1:3)-e.trans(1:3,4);
    out=out/norm(out);

    % Compute rotation using Listing's law
    out_rest=e.rest_pos*[0 0 -1]';
    e.trans(1:3, 1:3)=listings_law(out_rest, out)*e.rest_pos;

    % Compensate for the fact that fovea is displaced relative to optical axis
    if FEAT_FOVEA_DISPLACEMENT
        alpha=6/180*pi;
        % beta=0/180*pi;
        beta=2/180*pi;
        A=[cos(alpha) 0 -sin(alpha); 0 1 0; sin(alpha) 0 cos(alpha)];
        B=[1 0 0; 0 cos(beta) sin(beta); 0 -sin(beta) cos(beta)];
        e.trans(1:3, 1:3)=e.trans(1:3, 1:3)*B*A;
    end
