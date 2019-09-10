function X=eye_get_pupil(e, N)
%  eye_get_pupil  Returns an array of points describing the pupil boundary
%    X = eye_get_pupil(e, N) returns a 4xN matrix of points (in world
%    coordinates) on the pupil boundary of the eye 'e'.

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
        N=20;
    end

    alpha=2*pi*(0:(N-1))/N;
    X=repmat(e.pos_pupil, 1, N) + e.across_pupil*cos(alpha) + ...
        e.up_pupil*sin(alpha);
    X=e.trans*X;
