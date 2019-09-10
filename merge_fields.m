function dest=merge_fields(dest, src)
%  merge_fields  Merges fields from two structures
%    dest=merge_fields(dest, src) merges the fields from the structures 'dest'
%    and 'src' by copying the fields from 'src' to 'dest', overwriting any
%    existing fields in 'dest' of the same name. Fields that exist only in
%    'dest' but not in 'src' are left unchanged.

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

    f=fieldnames(src);

    for j=1:length(f)
        dest=setfield(dest, f{j}, getfield(src, f{j}));
    end
