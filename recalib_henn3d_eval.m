function gaze3d=recalib_henn3d_eval(state, gaze3d)
%  recalib_henn3d_eval  Apply 3D version of Hennessey's recalibration
%    gaze3d = recalib_henn3d_eval(state, gaze3d) corrects the gaze vector
%    'gaze3d' according to the recalibration information 'state' (obtained
%    using recalib_henn3d_calib()).

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

    % Normalize gaze vector
    gaze3d=gaze3d/norm(gaze3d);

    % Compute scalar product with each of the calibration points
    d=state.gaze3d_measured.*repmat(gaze3d, 1, size(state.gaze3d_measured,2));
    d=sum(d,1);

    % If any scalar product is zero, just set the weight for that point to one
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

    % Add weighted sum of offsets to gaze vector
    gaze3d=gaze3d+sum(state.offsets.*repmat(weights,4,1), 2);
