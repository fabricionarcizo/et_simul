function gaze3d=recalib_henn_angle_eval(state, gaze3d)
%  recalib_henn_angle_eval  Apply eye angle version of Hennessey recalibration
%    gaze3d = recalib_henn_angle_eval(state, gaze3d) corrects the gaze vector
%    'gaze3d' according to the recalibration information 'state' (obtained
%    using recalib_henn_angle_calib()).

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

    angles=gaze2angle(gaze3d);

    % Compute distance to each of the calibration points
    d=state.angles_measured-repmat(angles, 1, size(state.angles_measured,2));
    d=sqrt(sum(d.^2,1));

    % If any distance is zero, just set the weight for that point to one 
    % and the rest to zero
    I=find(d<1e-8);
    if ~isempty(I)
        weights=zeros(size(d));
        weights(I(1))=1;
    else
        % Compute weights as reciprocal of distance and normalize so they
        % sum to one
        weights=1./d;
        weights=weights/sum(weights);
    end

    % Add weighted sum of offsets to angles
    angles=angles+sum(state.offsets.*repmat(weights,2,1), 2);

    % Convert back to a gaze vector
    gaze3d=angle2gaze(angles);
