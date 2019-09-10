function X=eye_get_pupil_image(e, c, N)
%  eye_get_pupil_image  Computes image of pupil boundary
%    X = eye_get_pupil_image(e, c, N) returns a 2xM matrix of points
%    describing the image of the pupil boundary of the eye 'e' as observed by
%    the camera 'c'. Normally, M=N, but M can be less than N if some of the
%    boundary points lie outside the camera image or are not visible through
%    the cornea. Refraction at the corneal surface and camera error are taken
%    into account.

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

    if nargin<3
        N=20;
    end

    pupil=eye_get_pupil(e, N);
    X=zeros(4,0);
    for i=1:size(pupil, 2)
        img=eye_find_refraction(e, c.trans(:,4), pupil(:,i));
        if ~isempty(img)
            X(:,end+1)=img;
        end
    end

    [X,dists,valid]=camera_project(c, X);
    X=X(:,valid);
