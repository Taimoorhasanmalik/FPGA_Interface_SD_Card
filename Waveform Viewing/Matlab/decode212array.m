function output = decode212array(samples)
    % Convert an array of 12-bit two's complement samples to int16 representation.
    % Args:
    %     samples: Array of 12-bit two's complement integers.
    % Returns:
    %     output: Array of int16 values with 12-bit data.
    i=1;
    index = 1;
    while(i<length(samples))
        output(index) = bitand(bitor(bitshift(samples(i+1),8),samples(i)),0xFFF);
        output(index+1) = bitand(bitor(bitshift(samples(i+1),8),samples(i+2)),0xFFF);
        i = i +3;
        index = index+2;
    end

    % Adjust for negative values (two's complement conversion)
    output(output >= 2048) = output(output >= 2048) - 4096;
end
