function [x1, x2]=lines_closest_point(p1, d1, p2, d2)
%  lines_closest_point  Computes points where two lines are closest
%    [x1, x2] = lines_closest_point(p1, d1, p2, d2) computes the points of
%    closest proximity between the two lines given by the point 'p1' and the
%    direction 'd1' on one hand and the point 'p2' and the direction 'd2' on
%    the other hand. Returns the point 'x1' on the first line that is closest
%    to the second line and the point 'x2' on the second line that is closest
%    to the first line.
%
%    If the lines are parallel, the result is undefined.
%
%    3D or homogeneous coordinates may be passed in; the same type of
%    coordinates is passed out.

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

    A=[d1'*d1 -d2'*d1; d1'*d2 -d2'*d2];
    b=[-(p1-p2)'*d1; -(p1-p2)'*d2];
    alpha=A\b;
    x1=p1 + alpha(1)*d1;
    x2=p2 + alpha(2)*d2;
