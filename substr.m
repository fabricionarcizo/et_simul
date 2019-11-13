%% substr
% Return part of a string.
%
%% Syntax
%
%   str = substr(s,i,j)
%   str = substr(s,i,j,length_or_index)
% 
%% Description
%
% |str = substr(s,i,j)| returns the extracted part of |s| with length |j|
% beggining from |i|; or an empty vector if |j| < |i| or |i| < 0.
%
% |str = substr(s,i,j,length_or_index)| the argument |j| is treated as the
% index of the last position of the substring inside |s| if
% |length_or_index| is equal to |'index'|.
%
%% Examples
%
% Outputs the substring from the second index position with a length of 3
% chars.
%
% <html>
% <pre class="codeinput">
% str = substr(<span class="string">'12345'</span>,2,3)
% </pre>
% </html>
%
% str =
%
%       '234'
%
% Outputs the substring from the second to the third index position.
%
% <html>
% <pre class="codeinput">
% str = substr(<span class="string">'12345'</span>,2,3,<span class="string">'index'</span>)
% </pre>
% </html>
%
% str =
%
%       '23'
%
%% Input Arguments
%
% <html>
% <code>s</code> &mdash; Input string<br>
% character vector or string scalar<br>
% String to extract a substring.<br>
% <b>Data Types:</b> <code>string</code><br>
% <br>
% <code>i</code> &mdash; Initial index<br>
% positive integer number<br>
% Number of the initial index inside <code>str</code>.<br>
% <b>Data Types:</b> <code>double | single | int64 | int32 | int16 | int8</code><br>
% <br>
% <code>j</code> &mdash; Length / End index<br>
% positive real number<br>
% Length of the output string if <code>i > 0</code> or number of the end
% index inside <code>str</code> if <code>length_or_index ==
% 'index'</code>.<br>
% <b>Data Types:</b> <code>double | single | int64 | int32 | int16 | int8</code><br>
% <br>
% <code>length_or_index</code> &mdash; Length or index<br>
% 'length' (default) | 'index'<br>
% A string that interprets the input <code>j</code> as length when it is
% equal to <code>'length'</code>.<br> or as an index when it is equal to
% <code>'index'</code>.<br>
% <b>Data Types:</b> <code>string</code><br>
% </html>
%
%% Output Argument
%
% <html>
% <code>str</code> &mdash; Substring<br>
% character vector or string scalar<br>
% String inside <code>s</code>.<br>
% </html>
%
%% Code
function str = substr(str,i,j,length_or_index)
    if nargin < 4
        length_or_index = 'length';
    end
    switch lower(length_or_index)
        case 'length'
            j = i+j-1;
        case 'index'
        otherwise
            error('When explicited, the intput argument ''length_or_index'' must be equal to ''length'' or ''index''.')
    end
    if ~ischar(i)
        i = num2str(i);
    end
    if ~ischar(j)
        j = num2str(j);
    end
    str = eval(['str(' i ':' j ')']);
end
