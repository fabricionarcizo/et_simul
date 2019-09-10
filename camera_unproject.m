function pos=camera_unproject(c, X, d)
%  camera_unproject  Unprojects points on the image plane back into 3D space
%    pos = camera_unproject(c, x, d) unprojects the two-dimensional points
%    contained in the columns of the 2xn matrix 'X' from the image plane of 
%    camera 'c' back to a distance 'd' from the camera (measured along the 
%    optical axis). The points are returned as a 4xn matrix of homogeneous
%    column vectors.

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

    n=size(X,2);
    pos=c.trans*[X(1,:)/c.focal_length*d; X(2,:)/c.focal_length*d;
        repmat(-d,1,n); ones(1,n)];
