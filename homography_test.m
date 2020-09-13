function homography_test(test_type)
%  homography_test  Tests homography normalization method
%    homography_test(test_type) tests the gaze estimation method that uses 
%    homography normalization to map the pupil plane to the screen plane.
%
%    If 'test_type' is 'screen' (or non-existent), the observer's position is
%    fixed and the gaze position is swept across the screen. If 'test_type' is
%    'observer', the gaze position is fixed, and the observer is placed at
%    different positions.

%    Copyright 2019 Fabricio Batista Narcizo and the IT University of Copenhagen
%
%    This file is part of eyeinfo_simul.
%
%    eyeinfo_simul is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License (version 3) as
%    published by the Free Software Foundation.
%
%    eyeinfo_simul is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    (version 3) along with et_simul in a file called 'COPYING'. If not, see
%    <http://www.gnu.org/licenses/>.

    if nargin<1
        test_type='screen';
    end

    et=homography_make();

    if strcmp(test_type, 'screen')
        test_over_screen(et);
    else
        if strcmp(test_type, 'real')
            test_real_data(et);
        else
            if strcmp(test_type, 'simulated')
                test_simulated_data(et);
            else
                test_over_observer(et);
            end
        end
    end
