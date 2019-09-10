function et=yoo_calib(et, calib_data)
%  yoo_calib  Calibration function for Yoo and Chung's method

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

    et.state.alpha=ones(1, 4);

    for i=1:4
        % Pan and tilt camera towards eye
        c=camera_pan_tilt(et.cameras{1}, ...
            camera_unproject(et.cameras{1}, ...
                calib_data{i}.camimg{1}.cr{5}, 1));

        % Recapture image
        camimg=camera_take_image(c, calib_data{i}.e, et.lights);

        % Rename according to Yoo and Chung's nomenclature
        r=[camimg.cr{1}, camimg.cr{2} camimg.cr{3} camimg.cr{4}];
        c=camimg.cr{5};
        p=camimg.pc;

        et.state.alpha(i)=norm(p-c)/norm(r(:,i)-c);

        %i
        %p-c
        %state.alpha(i)*(r(:,i)-c)
    end

    et.state.alpha
