function errors=test_over_screen(et, observer_pos_calib, ...
    observer_pos_test, r_cornea, r_pc)
%  test_over_screen Computes gaze error at different gaze positions on screen
%    test_over_screen(et, observer_pos_calib, observer_pos_test, r_cornea,
%    r_pc) tests the eye tracker 'et' by sweeping the gaze position across the
%    screen. The observer position is 'observer_pos_calib' for the calibration
%    and 'observer_pos_test' for the test. The size of the cornea is
%    'r_cornea', and the distance between cornea center and pupil center is
%    'r_pc'.
%    Any arguments after 'et' that are not specified are set to sensible
%    default values.

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

    if nargin<2
        observer_pos_calib=[0 550e-3 350e-3 1]';
    end
    if nargin<3
        observer_pos_test=observer_pos_calib;
    end
    if nargin<4
        r_cornea=7.98e-3;
    end

    % Create eye
    e=eye_make(r_cornea, [1 0 0; 0 0 1; 0 1 0]);
    e.trans(1:3,4)=observer_pos_calib(1:3);
    if nargin>=5
        e.pos_pupil=e.pos_cornea-[0 0 r_pc 0]';
    end

    % Calibrate eye tracker
    et=et_calib(et, e);

    % Define screen positions grid
    N=16;
    X=linspace(-200e-3, 200e-3, N);
    Y=linspace(50e-3, 350e-3, N);

    U=zeros(N);
    V=zeros(N);
    errs_deg=zeros(N);

    % Output eye measurements
    fprintf('Corneal radius: %.3g mm\n',...
        norm(e.pos_apex-e.pos_cornea)*1e3);

    fprintf('Pupil radius:   %.3g mm\n',...
        norm(e.pos_cornea-e.pos_pupil)*1e3);

    % Calculate gaze error
    e.trans(1:3,4)=observer_pos_test(1:3);
    for i=1:length(X)
        for j=1:length(Y)
            [U(j,i), V(j,i)]=et_gaze_error(et, e, [X(i),Y(j)]);

            % Compute error in degrees
            gaze3d_real=[X(i) 0 Y(j)]'-observer_pos_test(1:3);
            gaze3d_measured=[X(i)+U(j,i) 0 Y(j)+V(j,i)]'- ...
                observer_pos_test(1:3);
            gaze3d_real=gaze3d_real/norm(gaze3d_real);
            gaze3d_measured=gaze3d_measured/norm(gaze3d_measured);
            errs_deg(j,i)=180/pi*real(acos(gaze3d_real'*gaze3d_measured));
        end
        fprintf('.');
    end
    fprintf('\n');

    % Plot gaze error
    quiver(X, Y, U, V);
    errs_mtr=reshape(sqrt(U.^2+V.^2), 1, []);
    errors.mtr=compute_error_statistics(errs_mtr);
    errors.deg=compute_error_statistics(errs_deg(:));
    fprintf('Maximum error %g mm\n', errors.mtr.max*1e3);
    fprintf('Mean error %g mm\n', errors.mtr.mean*1e3);
    fprintf('Standard deviation %g mm\n', errors.mtr.std*1e3);

    title(sprintf(...
        'Maximum error %.3g mm\tMean error %.3g mm\tStd dev %.3g mm', ...
        errors.mtr.max*1e3, errors.mtr.mean*1e3, ...
        errors.mtr.std*1e3));

function stats=compute_error_statistics(errs)
    stats.mean=mean(errs);
    stats.max=max(errs);
    stats.std=std(errs);
    stats.median=median(errs);
