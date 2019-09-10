function [x, dist, valid]=camera_project(c, pos)
%  camera_project  Projects points in space onto the camera's image plane
%    [x, dist] = camera_project(c, pos) transforms a list of points 'pos'
%    (given as a 4xn matrix) into the local coordinate system of camera 'c' 
%    and projects them onto the camera's image plane. A certain amount of
%    random error is added to the image coordinates, see the documentation for
%    camera_make() for details. The function returns a 2xn matrix 'x' of image
%    points, a row vector 'dist' of length n containing the distances of the 
%    points from the camera (measured along the optical axis), and a boolean
%    row vector 'valid' of length n specifying, for each point, whether it
%    fell within the camera image (as defined by the c.resolution parameter).
%    In addition, if a point fell outside the camera image, the corresponding
%    entry in 'x' is set to 'nan'.
%    Note: We use this approach (returning a separate 'valid' array and
%    setting points outside the image to 'nan') because this makes it easier
%    to process all of the resulting points at once, as opposed to, for 
%    example, a cell array containing [] for invalid points. Additionally,
%    users will almost never interact directly with camera_project(), but will
%    use camera_take_image() instead.

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

    pos=c.trans\pos;
    dist=-pos(3,:);

    x=[c.focal_length*pos(1,:)./dist; c.focal_length*pos(2,:)./dist];

    if strcmp(c.err_type, 'uniform')
        x=x + c.err*(2*rand(2,size(pos,2))-1);
    elseif strcmp(c.err_type, 'gaussian')
        x=x + c.err*normal_deviates(size(pos,2))';
    else
        error('Unknown error type');
    end

    valid=find(x(1,:)>=-c.resolution(1)/2 & x(1,:)<=c.resolution(1)/2 & ...
        x(2,:)>=-c.resolution(2)/2 & x(2,:)<=c.resolution(2)/2);

    x(:,~valid)=nan;
