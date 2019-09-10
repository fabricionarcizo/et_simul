function cr=eye_find_cr_simple(e, l, c)
%  eye_find_cr_simple  Finds the position of a corneal reflex (simplified)
%    cr = eye_find_cr_simple(e, l, c) finds the position of the corneal reflex
%    generated by light 'l' on the eye 'e' as seen by the camera 'c'. In
%    contrast to eye_find_cr(), which computes the position of the CR exactly, 
%    this routine uses a paraxial approximation proposed by Morimoto, Amir and 
%    Flicker ('Detecting Eye Position and Gaze from a Single Camera and 2 
%    Light Sources').

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

    cc=e.trans*e.pos_cornea;
    to_cam=c.trans(:,4)-cc;
    to_cam=to_cam/norm(to_cam);
    w=e.r_cornea/(2*(l.pos-cc)'*to_cam);
    cr=cc+w*(l.pos-cc);
