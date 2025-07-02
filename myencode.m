function compressedValue = myencode(numbers)
    % Encode 8 numbers into a single compressed value.
    % Input:
    %   numbers - An array containing 8 numbers:
    %             The first 4 numbers are from 0:0.2:1,
    %             The 5th number is fixed at 0,
    %             The last 3 numbers are from -pi:0.2:pi.
    % Output:
    %   compressedValue - The encoded value as a single number.

    % Check the input length
    if length(numbers) ~= 8
        error('Input must contain exactly 8 numbers.');
    end

    % Map the first 4 numbers from 0:0.2:1
    sequence1 = 0:0.2:1;
    mappedValues1 = arrayfun(@(x) find(abs(sequence1 - x) < 1e-6, 1) - 1, numbers(1:4));

    % Map the last 3 numbers from -pi:0.2:pi
    sequence2 = -pi:0.2:pi;
    mappedValues3 = arrayfun(@(x) find(abs(sequence2 - x) < 1e-6, 1) - 1, numbers(6:8));
    
    % Encode the first 4 numbers using base-6
    part1 = mappedValues1(1) * 6^3 + mappedValues1(2) * 6^2 + ...
            mappedValues1(3) * 6^1 + mappedValues1(4) * 6^0;

    % Encode the last 3 numbers using base-32
    part2 = mappedValues3(1) * 32^2 + mappedValues3(2) * 32^1 + mappedValues3(3) * 32^0;

    % Combine both parts to get the compressed value
    compressedValue = part1 * 32^3 + part2;
end
