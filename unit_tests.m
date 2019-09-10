function success=unit_tests()
%  unit_tests  Runs unit tests
%    unit_tests() executes all Matlab '.m' files in the directory
%    'unit_tests'. Each of these files should execute a unit test and return
%    true if the test was successful or false if it failed. unit_tests()
%    prints a diagnostic for any unit test that fails and returns true if all
%    tests ran successfully or false if one or more tests failed.

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

    % Add unit tests to search path
    p=path();
    path(p, strcat(pwd, '/unit_tests'));

    % Loop over all '.m' files in directory 'unit_tests'
    w=what('unit_tests');
    success=true;
    for i=1:length(w(1).m)
        % Construct name of corresponding function
        func_name=w(1).m{i}(1:end-2);
        fprintf('Testing %s... ', func_name);

        % Run test
        if feval(func_name)
            fprintf('success\n');
        else
            fprintf('failed\n');
            success=false;
        end
    end

    % Restore old path
    path(p);
