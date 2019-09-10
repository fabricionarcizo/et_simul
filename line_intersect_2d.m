function p=line_intersect_2d(p11, p12, p21, p22)
%  line_intersect_2d  Computes intersection of two-dimensional lines
%    p = line_intersect_2d(p11, p12, p21, p22) computes the intersection (in
%    2D) of the line through 'p11' and 'p12' with the line through 'p21' and
%    'p22'. The result is returned in 'p'. If the lines do not intersect, the
%    result is undefined.

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

    b=p21-p11;
    A=[p12-p11, p22-p21];
    x=A\b;

    p=p11+x(1)*(p12-p11);
