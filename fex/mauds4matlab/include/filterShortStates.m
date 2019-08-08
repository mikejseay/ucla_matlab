function [states] = filterShortStates(states, minStateLength, f)
% minStateLength in seconds
% f in frames/second


%    Copyright (C) 2007 Daniel Lobo - Universidad de Malaga (dlobo@geb.uma.es)

%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.


minNumFrames = minStateLength * f; % frames

i=1;
% loop from i = 1 to the size of states
while(i <= size(states, 1))
    % happens rarely....
    while(i <= size(states, 1) && states(i,2) ~= 0 && states(i,2)-states(i,1) < minNumFrames)
        states(i,:) = [];
    end
    
    % if the difference betweeen current potential start and next is less than the min
    if(i < size(states, 1) && states(i+1,1)-states(i,2) < minNumFrames)
        % if last
        if(i == size(states, 1))
            states(i-1,2) = states(i,2);
            states(i,:) = [];
        % if not last
        else
            % shift values in left-hand column, starting from the one after the next (two ahead),
            % up by one
            states(i+1:end-1,1) = states(i+2:end,1);
            % shift values in right-hand column, starting from the the next (one ahead),
            % up by one
            states(i:end-1,2) = states(i+1:end,2);
            % since the last two rows are now identical, get rid of the last row
            states(end,:) = [];
        end
    else
        i = i + 1;
    end
end