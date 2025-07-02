function decodedNumbers = mydecode(compressedValue)
    % Decode a compressed value into 8 original numbers.
    % Input:
    %   compressedValue - The encoded value to be decoded.
    % Output:
    %   decodedNumbers - A vector containing the 8 decoded numbers.

    % Generate sequences for mapping
    sequence1 = 0:0.2:1;      % Sequence for the first 4 numbers
    sequence2 = -pi:0.2:pi;   % Sequence for the last 3 numbers

    % Decode the last 3 numbers (base-32 part)
    part2 = mod(compressedValue, 32^3);
    mappedValues3 = zeros(1, 3);
    for i = 2:-1:0
        mappedValues3(3 - i) = floor(part2 / 32^i);
        part2 = mod(part2, 32^i);
    end

    % Decode the first 4 numbers (base-6 part)
    part1 = floor(compressedValue / 32^3);
    mappedValues1 = zeros(1, 4);
    for i = 3:-1:0
        mappedValues1(4 - i) = floor(part1 / 6^i);
        part1 = mod(part1, 6^i);
    end

    % Convert mapped values back to original numbers
    decodedNumbers1 = arrayfun(@(x) sequence1(x + 1), mappedValues1); % First 4 numbers
    decodedNumbers2 = 0; % The 5th number is fixed at 0
    decodedNumbers3 = arrayfun(@(x) sequence2(x + 1), mappedValues3); % Last 3 numbers

    % Combine results into a single output
    decodedNumbers = [decodedNumbers1, decodedNumbers2, decodedNumbers3];
end

