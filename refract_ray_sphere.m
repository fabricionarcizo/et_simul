function [U0, Ud]=refract_ray_sphere(R0, Rd, S0, Sr, n_outside, n_sphere)
%  refract_ray_sphere  Refracts ray at surface of sphere
%    [U0, Ud] = refract_ray_sphere(R0, Rd, S0, Sr, n_outside, n_sphere) finds
%    the point 'U0' at which a ray (specified by its origin 'R0' and direction
%    'Rd') strikes a sphere (with center 'S0' and radius 'Sr') and computes 
%    the direction 'Ud' of the refracted ray. The refractive index outside
%    the sphere is 'n_outside', the refractive index of the sphere is 
%    'n_sphere'.
%
%    [] is returned for 'U0' and 'Ud' if the original ray does not intersect
%    the sphere.
%
%    3D or homogeneous coordinates may be passed in; the same type of
%    coordinates is passed out.

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

    % Normalize ray direction
    Rd=Rd/norm(Rd);

    % Find point of intersection
    U0=intersect_ray_sphere(R0, Rd, S0, Sr);

    if isempty(U0)
        Ud=[];
        return;
    end

    % Find surface normal at point of intersection (pointing inwards)
    N=(S0-U0)/norm(S0-U0);

    % Find cosines
    costh1=Rd'*N;
    costh2=sqrt(1-(n_outside/n_sphere)^2*(1-costh1^2));

    Ud=n_outside/n_sphere*Rd + (costh2 - n_outside/n_sphere*costh1)*N;
