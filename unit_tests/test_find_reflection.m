function success=test_find_reflection()
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

    L=[0.25 0 0]';
    C=[0.1 -0.1 0]';
    S0=[0.05 0 1.0]';
    Sr=0.8;
    
    U0_target=[
        0.1472592734935877;
        -0.0408954315633531
        0.2069878958069135];

    U0=find_reflection(L, C, S0, Sr);

    success=norm(U0-U0_target)<1e-10;
