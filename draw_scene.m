function draw_scene(c, l, e)
%  draw_scene  Draws a scene consisting of cameras, lights, and an eye
%    draw_scene(c, l, e) draws a graphical representation of the camera(s) 
%    'c', the light(s) 'l' and the eye(s) 'e' on the current axes. 'c', 'l' 
%    and 'e' can be either single camera / light / eye objects or cell arrays 
%    of camera / light / eye objects.

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

    if ~iscell(c)
        c={c};
    end
    if ~iscell(l)
        l={l};
    end
    if ~iscell(e)
        e={e};
    end

    subplot(2,1,1);

    % Dummy plot command to establish 3D view
    plot3(0, 0, 0, '');
    hold on;

    for i=1:length(c)
        camera_draw(c{i});
    end
    for i=1:length(l)
        light_draw(l{i});
    end
    for i=1:length(e)
        eye_draw(e{i});
    end
    hold off;

    axis equal;
    axis vis3d;
    rotate3d on;
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    % set(gca, 'CameraTarget', cc(1:3));

    for i=1:length(e)
        % Mark cornea center and pupil center
        [dummy, hCornea]=mark_point(c{1}, e{i}.trans*e{i}.pos_cornea, 'g+');
        [dummy, hPupil]=mark_point(c{1}, e{i}.trans*e{i}.pos_pupil, 'kx');

        % Draw CRs
        for j=1:length(l)
            cr=eye_find_cr(e{i}, l{j}, c{1});
            if ~isempty(cr)
                [dummy, hCR]=mark_point(c{1}, cr);
            end
        end
    end

    subplot(2,1,2);
    axis equal;
    set(gca, 'XLim', expandaxis(get(gca, 'XLim')));
    set(gca, 'YLim', expandaxis(get(gca, 'YLim')));

    legend([hCornea, hPupil, hCR], 'Cornea Centre', 'Pupil Centre', 'CR', ...
        'Location', 'EastOutside');

function lim=expandaxis(lim)
    centre=(lim(1)+lim(2))/2;
    lim=(lim-centre)*1.25+centre;
