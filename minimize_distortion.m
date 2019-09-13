function val = minimize_distortion(coeff, pupils, targets)
%  minimize_distortion  First-order iterative optimization algorithm for finding
%  the minimum of a function.

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

    % The relationship between pupils and targets
    x = targets(1, :);
    y = targets(2, :);
    xp = pupils(1, :);
    yp = pupils(2, :);

    % Distortion coefficients
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
    r = sqrt(xp .* xp + yp .* yp);
    r2 = r .^ 2;
    r4 = r .^ 4;
    r6 = r .^ 6;

    % Radial distortion
    rad = (1 + k1 * r2 + k2 * r4 + k3 * r6) ./ (1 + k4 * r2 + k5 * r4 + k6 * r6);

    % Tangential distortion
    tanX = 2 * p1 * xp .* yp + p2 * (r2 + 2 * xp.^2);
    tanY = p1 * (r2 + 2 * yp.^2) + 2 * p2 * xp .* yp;

    % Prism distortion
    priX = s1 * r2 + s2 * r4;
    priY = s3 * r2 + s4 * r4;

    % Calculate the distortion error
    temp1 = x - (xp .* rad + tanX + priX);
    temp2 = y - (yp .* rad + tanY + priY);

    val = sqrt(temp1 .* temp1 + temp2 .* temp2);
