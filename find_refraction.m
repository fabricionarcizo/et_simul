function I=find_refraction(C, O, S0, Sr, n_outside, n_sphere)
%  find_refraction  Computes image produced by refracting sphere
%    I = find_refraction(C, O, S0, Sr, n_outside, n_sphere) finds the position
%    on a sphere with center S0 and radius Sr where a ray emanating from an
%    object at a position 'O' inside the sphere is refracted to pass directly
%    through point 'C' (this could be a camera, for example). The refractive
%    index of the sphere is 'n_sphere', that of the outside medium is
%    'n_outside'.

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

    a=find_zero( ...
        @(a) refract_objective(a, C, O, S0, Sr, n_outside, n_sphere), ...
        0, 1);

    [dummy, I]=refract_objective(a, C, O, S0, Sr, n_outside, n_sphere);

function [diff, U0]=refract_objective(a, C, O, S0, Sr, n_outside, n_sphere)
    % Compute vectors from the sphere center to the camera and the object
    to_c=(C-S0)/norm(C-S0);
    to_o=(O-S0)/norm(O-S0);

    % Use a to interpolate between the two vectors and normalize to obtain a
    % surface normal
    n=a*to_c+(1-a)*to_o;
    n=n/norm(n);

    % Compute point on surface of sphere
    U0=S0+Sr*n;

    % Compute angle that ray to camera and ray to light make with the surface
    % normal at this point
    cos_angle_c=n'*(C-U0)/norm(C-U0);
    cos_angle_o=n'*(U0-O)/norm(U0-O);
    sin_angle_c=mysqrt(1-cos_angle_c^2);
    sin_angle_o=mysqrt(1-cos_angle_o^2);

    % Snell's law
    diff=n_outside*sin_angle_c-n_sphere*sin_angle_o;

function y=mysqrt(x)
    if x<=0
        y=0;
    else
        y=sqrt(x);
    end
