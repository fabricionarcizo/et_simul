function shihwuliu_test(test_type)
%  shiwuliu_test  Tests Shih, Wu and Liu's method
%    If 'test_type' is 'screen' (or non-existent), the observer's position is
%    fixed and the gaze position is swept across the screen. If 'test_type' is
%    'observer', the gaze position is fixed, and the observer is placed at
%    different positions.

%    Copyright 2008 Mathis Graw, Martin Böhme and the University of Lübeck
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

    if nargin<1
        test_type='screen';
    end

    params.recalib_type='angle';

    % Create eye tracker
    et=shihwuliu_make(params);

    if strcmp(test_type, 'screen')
        test_over_screen(et);
    elseif strcmp(test_type,'observer')
        test_over_observer(et);
    end
