function pupil = pupil_compensation(et, pc)
%  pupil_compensation  Normalize the current pupil center.
%    pupil_compensation(et, pc) Normalize the pupil center into the normalized
%    space without the influence of eye camera location in the eye tracker
%    setup.

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

    pupil = et.state.Ten * [pc(1)^2 pc(2)^2 pc(1)*pc(2) pc(1) pc(2) 1]';
