function xroot=find_zero(f, xmin, xmax)
%  find_zero  Find zero of a function
%    xroot = find_zero(f, xmin, xmax) finds a zero of the function 'f'
%    between 'xmin' and 'xmax'. 'xroot' is set to the position of the zero
%    that was found. The function must have different sign at 'xmin' and
%    'xmax', i.e. f(xmin)*f(xmax)<0 must hold.
%
%    This function can be used to switch between the zero finder from the
%    Matlab optimization toolbox and brent_zero().

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

    if 0
        persistent opt_options

        % Initialize optimizer options if they haven't been set yet
        if isempty(opt_options)
            opt_options=optimset('fzero');
        end

        xroot=fzero(f, [xmin xmax], opt_options);
    else
        xroot=brent_zero(f, xmin, xmax);
    end
