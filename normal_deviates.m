function D=normal_deviates(n)
%  normal_deviates  Generates bivariate normal deviates
%    D = normal_deviates(n) generates an n-times-2 matrix of bivariate normal
%    deviates with mean 0 and standard deviation 1.

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

% Polar form of the Box-Muller transformation for generating normal
% deviates (see Numerical Recipes in C, Section 7.2)

    X = [];

    while size(X,1)<n
        X=[X; rand(n-size(X,1), 2)*2-1];
        W=X(:,1).^2+X(:,2).^2;
        X=X(find(W<1),:);
    end

    W=sqrt( -2*log(W)./W );
    D=X .* [W, W];
