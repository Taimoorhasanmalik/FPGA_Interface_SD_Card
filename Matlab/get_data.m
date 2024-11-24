function data_arr = get_data(s)
i = 1;
disp("Connected to device");
% Initialize arrays
data_arr = [];
chunk_size = 100;  % Number of bytes to read at a time

% Wait for data to be available
while s.NumBytesAvailable <= 0
    disp("Waiting For Device to Send Data");
    pause(0.1);  % Small pause to avoid busy-waiting
end

% Main data reception loop
while true
    % Read data in chunks instead of single bytes
    num_available = s.NumBytesAvailable;
    if num_available > 0
        bytes_to_read = min(chunk_size, num_available);
        data_arr(i:i + bytes_to_read - 1) = read(s, bytes_to_read, "uint8");
        i = i + bytes_to_read;
    else
        % If no data is available, wait a bit and check again
        pause(3);
        if s.NumBytesAvailable == 0
            break;
        end
    end
end

disp("Data reception complete.");
disp(['Total bytes received: ', num2str(length(data_arr))]);


end