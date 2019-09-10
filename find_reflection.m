function U0=find_reflection(L, C, S0, Sr)
%  find_reflection  Finds position of a glint on the surface of a sphere
%    U0 = find_reflection(L, C, S0, Sr) finds the position on a sphere with
%    center S0 and radius Sr where a ray emanating from a light source at 'L'
%    is reflected to pass directly through point 'C' (this could be a camera,
%    for example).

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

    a=find_zero(@(a) reflect_objective(a, L, C, S0, Sr), 0, 1);

    [dummy, U0]=reflect_objective(a, L, C, S0, Sr);

function [angle_diff, U0]=reflect_objective(a, L, C, S0, Sr)
    % Compute vectors from the sphere center to the camera and to the light
    to_c=(C-S0)/norm(C-S0);
    to_l=(L-S0)/norm(L-S0);

    % Use a to interpolate between the two vectors and normalize to obtain a
    % surface normal
    n=a*to_c+(1-a)*to_l;
    n=n/norm(n);

    % Compute point on surface of sphere
    U0=S0+Sr*n;

    % Compute angle that ray to camera and ray to light make with the surface
    % normal at this point
    angle_c=myacos(n'*(C-U0)/norm(C-U0));
    angle_l=myacos(n'*(L-U0)/norm(L-U0));

    % Compute angle difference
    angle_diff=angle_c-angle_l;

function y=myacos(x)
    if x>=1
        y=0;
    else
        y=acos(x);
    end
