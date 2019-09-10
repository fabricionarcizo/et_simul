function A=listings_law(out_rest, out_new)
%  listings_law  Computes eye rotation according to Listing's law
%    A = listings_law(out_rest, out_new) uses Listing's law to compute a 
%    matrix 'A' for the rotation an eye makes when the direction of its
%    optical axis moves from the rest position 'out_rest' to the new position
%    'out_new'.

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

    % Normalize out_rest and out_new
    out_rest=out_rest/norm(out_rest);
    out_new=out_new/norm(out_new);

    % Calculate axis for rotation
    axis1=cross(out_new, out_rest);

    if norm(axis1)==0
        A=eye(3);
    else
        axis=axis1/norm(axis1);
        axis=axis/norm(axis);

        % The third vector we just get from the cross product of the out 
        % vectors (rest and new) and the axis
        third_rest=cross(out_rest, axis);
        third_new=cross(out_new, axis);

        A=[axis out_new third_new]*[axis'; out_rest'; third_rest'];
    end
