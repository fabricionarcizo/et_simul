function test_over_observer(et)
%  test_over_observer  Computes gaze error at different observer positions
%    test_over_observer(et) tests the eye tracker 'et' by placing the observer
%    at different positions in space. The gaze position on the screen is fixed.

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

    % Observer position for calibration
    observer_pos=[0 550e-3 350e-3 1]';

    % Create eye
    e=eye_make(7.98e-3, [1 0 0; 0 0 1; 0 1 0]);
    e.trans(1:3,4)=observer_pos(1:3);

    % Calibrate eye tracker
    et=et_calib(et, e);

    % Desired gaze point on screen (should be most diffcult)
    look_at_pos=[200e-3 350e-3 ]';

    % Define observer position grid
    N=16;
    X=linspace(-200e-3, 200e-3, N);
    Z=linspace(400e-3, 600e-3, N);
    observer_y=0;

    U= zeros(N);
    V= zeros(N);

    % Output eye measurements
    fprintf('Corneal radius: %.3g mm\n',...
        norm(e.pos_apex-e.pos_cornea)*1e3);

    fprintf('Pupil radius:   %.3g mm\n',...
        norm(e.pos_cornea-e.pos_pupil)*1e3);

    % Calculate gaze error
    for i=1:length(X)
        for j=1:length(Z)
            % Put the observer at the desired position
            % e.trans(1:3,4)=[X(i) observer_dist Y(j)]';
            e.trans(1:3,4)=[X(i) Z(j) observer_y]';

            [U(j,i), V(j,i)]=et_gaze_error(et, e, look_at_pos);
        end
        fprintf('.');
    end
    fprintf('\n');

    % Plot gaze error
    quiver(X, Z, U, V, 0);
    errs=reshape(sqrt(U.^2+V.^2), 1, []);
    fprintf('Maximum error %g mm\n', max(errs)*1e3);
    fprintf('Mean error %g mm\n', mean(errs)*1e3);
    fprintf('Standard deviation %g mm\n', std(errs)*1e3);

    title(sprintf(...
        'Maximum error %.3g mm\tMean error %.3g mm\tStd dev %.3g mm', ...
        max(errs)*1e3, mean(errs)*1e3, std(errs)*1e3));
