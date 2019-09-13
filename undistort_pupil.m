function pupil = undistort_pupil(et, pupil)
%  undistort_pupil  Undistort a pupil center distribution.

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

    % The pupil coordinates
    x = pupil(1, :);
    y = pupil(2, :);

    % Distortion coefficients
    coeff = et.state.coeff;
    k1 = coeff(1);
    k2 = coeff(2);
    k3 = coeff(3);
    k4 = coeff(4);
    k5 = coeff(5);
    k6 = coeff(6);
    p1 = coeff(7);
    p2 = coeff(8);
    s1 = coeff(9);
    s2 = coeff(10);
    s3 = coeff(11);
    s4 = coeff(12);

    % Calculate the error
    r = sqrt(x .* x + y .* y);
    r2 = r .^ 2;
    r4 = r .^ 4;
    r6 = r .^ 6;

    % Radial distortion
    rad = (1 + k1 * r2 + k2 * r4 + k3 * r6) ./ (1 + k4 * r2 + k5 * r4 + k6 * r6);

    % Tangential distortion
    tanX = 2 * p1 * x .* x + p2 * (r2 + 2 * x.^2);
    tanY = p1 * (r2 + 2 * y.^2) + 2 * p2 * x .* y;

    % Prims distortion
    priX = s1 * r2 + s2 * r4;
    priY = s3 * r2 + s4 * r4;

    % Remove the distortion
    x = x .* rad + tanX + priX;
    y = y .* rad + tanY + priY;

    pupil = [x; y; ones(1, size(x, 2))];
