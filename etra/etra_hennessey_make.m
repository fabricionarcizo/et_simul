function et=etra_hennessey_make(params)
%  etra_hennessey_make  Returns Hennessey eye tracker for ETRA paper
%    et = etra_hennessey_make(params) creates an eye tracker that uses the
%    method by Hennessey et al. (see hennessey_make()). The camera and
%    calibration points are adjusted to specific values used for tests in the
%    ETRA 2008 paper describing et_simul.

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

    et=hennessey_make(params);

    % Adjust camera specs
    et.cameras{1}=etra_camera_adjust(et.cameras{1});

    % Use standard calibration points
    et.calib_points=etra_calib_points();
