function c=camera_make()
%  camera_make  Creates a structure that represents a camera
%    c = camera_make() creates a camera object with default properties.
%
%    The camera model is a pinhole model, the center of projection is at the
%    origin of the camera coordinate system, and the camera's optical axis
%    points out along the negative z axis. The x and y axes of the image plane
%    are aligned with the x and y axes of the camera coordinate system.
%
%    The camera object 'c' that is produced contains the following elements:
%
%    - 'trans' is the transformation matrix from camera to world coordinates.
%      The default value for this is the identity matrix.
%
%    - 'rest_trans' is used for pan-tilt cameras to store the transformation 
%      matrix from camera to world coordinates in the camera's rest position.
%      This is needed because the 'trans' matrix is changed when the camera
%      pans and tilts out of its rest position. 'rest_trans' need not be set
%      for fixed cameras.
%
%    - 'focal_length' is the focal length of the camera in pixels. A point at 
%      a distance of 1 metre from the camera and offset horizontally from the 
%      optical axis by 1 metre will appear at an x coordinate of 
%      'focal_length' pixels in the camera image. The default value for this 
%      parameter is 2880.
%
%    - 'resolution' is a two-dimensional vector specifying the image
%      resolution of the camera (resolution (1) is the horizontal resolution,
%      and resolution(2) is the vertical resolution). The point where the
%      optical axis intersects the image plane has the image coordinates
%      (0,0); hence, valid x-coordinates range from -resolution(1)/2 to
%      resolution(1)/2, and valid y-coordinates range from -resolution(2)/2 to
%      resolution(2)/2. Points that fall outside this range cannot be "seen"
%      by the camera. The default resolution is [1280, 1024].
%
%    - 'err' is the amount of random error in measurements made in the camera
%      image. When camera_project() is used to project a point onto the
%      camera, a certain amount of random error is added to the position of
%      the point in the image. The exact meaning of this parameter depends on 
%      the type of error distribution selected in 'err_type'. The default 
%      value is 0.
%
%    - 'err_type' specifies the type of error. This parameter can have the
%      following values:
%
%      'gaussian' (default): A bivariate Gaussian distribution with mean 0 
%      and standard deviation err
%
%      'uniform': A uniform distribution between -err and +err for both the x
%      and y coordinate

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

    c.trans=eye(4);
    c.rest_trans=c.trans;

    c.focal_length=2880;

    c.resolution=[1280 1024];

    c.err=0;

    c.err_type='gaussian';
