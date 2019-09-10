function et = interpolate_calib(et, calib_data)
%  interpolate_calib  Calibration function for pupil-CR interpolation

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

    for i=1:size(et.calib_points, 2)
        % Calculate the pupil-CR-vector for each calibration point and 
        % build the interpolation matrix
        pcr = calib_data{i}.camimg{1}.pc-calib_data{i}.camimg{1}.cr{1};
        X(:,i) = [1 pcr(1) pcr(2) pcr(1)*pcr(2) pcr(1)^2 pcr(2)^2]';
    end

    % Determine the coefficients of the calibration function by solving
    % the linear equations
    et.state.A=et.calib_points/X;
