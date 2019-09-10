function calib_points=etra_calib_points()
%  etra_calib_points  Returns calibration points for ETRA paper
%    calib_points = etra_calib_points() returns the calibrations points
%    'calib_points' used for tests in the ETRA 2008 paper describing et_simul.

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

    % Nine-point calibration pattern
    calib_points=[
        -200e-3  50e-3;
           0e-3  50e-3;
         200e-3  50e-3;
        -200e-3 200e-3;
           0e-3 200e-3;
         200e-3 200e-3;
        -200e-3 350e-3;
           0e-3 350e-3;
         200e-3 350e-3]';
