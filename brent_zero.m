function xroot=brent_zero(f, xmin, xmax)
%  brent_zero  Zero finder using Brent's method
%    xroot = brent_zero(f, xmin, xmax) finds a zero of the function 'f'
%    between 'xmin' and 'xmax'. 'xroot' is set to the position of the zero
%    that was found. The function must have different sign at 'xmin' and
%    'xmax', i.e. f(xmin)*f(xmax)<0 must hold.

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

    tol=1e-10;
    max_iter=100;

    a=xmin;
    b=xmax;
    c=xmax;
    fa=f(a);
    fb=f(b);
    fc=fb;

    if fa*fb>0
        error('Root not bracketed');
    end

    for iter=1:max_iter
        if fb*fc>0
            c=a;
            fc=fa;
            d=b-a;
            e=d;
        end

        if abs(fc)<abs(fb)
            a=b;
            b=c;
            c=a;
            fa=fb;
            fb=fc;
            fc=fa;
        end

        % Check for convergence
        toli=2*eps*abs(b)+0.5*tol;
        xm=0.5*(c-b);
        if abs(xm)<=toli || fb==0
            xroot=b;
            return;
        end

        if abs(e)>=toli & abs(fa)>abs(fb)
            s=fb/fa;
            if a==c
                p=2*xm*s;
                q=1-s;
            else
                q=fa/fc;
                r=fb/fc;
                p=s*(2*xm*q*(q-r)-(b-a)*(r-1));
                q=(q-1)*(r-1)*(s-1);
            end
            if p>0
                q=-q;
            end
            p=abs(p);
            min1=3*xm*q-abs(toli*q);
            min2=abs(e*q);
            if(2*p<min([min1 min2]))
                e=d;
                d=p/q;
            else
                d=xm;
                e=d;
            end
        else
            d=xm;
            e=d;
        end

        a=b;
        fa=fb;
        if abs(d)>tol
            b=b+d;
        else
            b=b+abs(toli)*sign(xm);
        end
        fb=f(b);
    end

    error('Maximum number of iterations reached');
