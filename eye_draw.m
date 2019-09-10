function eye_draw(e, ax)
%  eye_draw  Draws a graphical representation of an eye
%    eye_draw(e, ax) draws a graphical representation of eye 'e' into the axes
%    'ax'. If no axes are specified, the current axes are used.

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

    if nargin<2
        ax=gca;
    end

    % Generate spherical surface for cornea
    [X, Y, Z]=sphere(20);
    X=e.r_cornea*X;
    Y=e.r_cornea*Y;
    Z=e.r_cornea*Z;
    I=find(Z>-e.r_cornea+e.depth_cornea);
    X(I)=nan;
    Y(I)=nan;
    Z(I)=nan;
    X=X+e.pos_cornea(1);
    Y=Y+e.pos_cornea(2);
    Z=Z+e.pos_cornea(3);

    % Transform
    for i=1:size(X,1)
        for j=1:size(X,2)
            v=e.trans*[X(i, j) Y(i, j) Z(i, j) 1]';
            X(i, j)=v(1);
            Y(i, j)=v(2);
            Z(i, j)=v(3);
        end
    end

    h=surf(X, Y, Z, 0.8*ones(size(X, 1), size(X, 2), 3));
    set(h, 'FaceAlpha', 0.5);
    set(h, 'EdgeAlpha', 0.3);
    set(h, 'CDataMapping', 'direct');
