function [S0, Sd]=reflect_ray_circle(R0, Rd, C0, Cr)
%  reflect_ray_circle  Reflects ray on circle
%    [S0, Sd] = reflect_ray_circle(R0, Rd, C0, Cr) finds the point 'S0' at 
%    which a ray (specified by its origin 'R0' and direction 'Rd') strikes a 
%    circle (with center 'C0' and radius 'Cr') and computes the direction 'Sd'
%    of the reflected ray. The result is undefined if the original ray does 
%    not intersect the circle.

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

    Rd=Rd/norm(Rd);

    % Find point of intersection
    S0=intersect_ray_circle(R0, Rd, C0, Cr);

    N=(S0-C0)/norm(S0-C0);
    Sd=Rd-2*N*(Rd'*N);

