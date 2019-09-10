function et_draw_setup(et)
%  et_draw_setup  Draws the setup of an eye tracker
%    et_draw_setup(et) draws the cameras and lights of the eye tracker 'et'
%    along with an eye at a default position.

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

    observer_dist=0.5;
    observer_x=0;
    observer_y=0.2;

    e=eye_make(7.98e-3, [1 0 0; 0 0 1; 0 1 0]);
    e.trans(1:3,4)=[observer_x observer_dist observer_y]';

    draw_scene(et.cameras, et.lights, e)
