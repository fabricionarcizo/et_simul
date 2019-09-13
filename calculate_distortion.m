function et = calculate_distortion(et, pupils, targets)
%  calculate_distortion  Calculate the dirstortion in the pupil center
%  distribution based on the targets in the normalized space.

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

    % Minimization function.
    f = @(coeff) minimize_distortion(coeff, pupils, targets);

    % Distortion optimization.
    x0 = [0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0];
    options = optimset('Display', 'iter', 'MaxIter', 30000, 'MaxFunEvals', 30000); 
    coeff = fsolve(f, x0, options);

    et.state.coeff = coeff;