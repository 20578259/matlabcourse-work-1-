function temperature_prediction()
    a = arduino('COM3', 'Uno'); % Initialize Arduino on COM3 port
    
    V0 = 0.5; % Offset voltage
    Tc = 0.01; % Temperature coefficient

    % Initialize variables
    prev_temp = 0;
    reading_count = 0;
    celsius_per_minute = 0;

    while true 
        voltage = readVoltage(a, 'A0'); % Read voltage from analog pin A0
        temp = (voltage - V0) / Tc;  % Convert voltage to temperature
        disp(['Temperature: ', num2str(temp, '%0.2f'), '°C']);

        % Calculate rate of temperature change
        rate_sum = (temp - prev_temp) / 2;
        disp(['Temperature Change per second: ', num2str(rate_sum, '%0.2f'), '°C/s']); 

        reading_count = reading_count + 1; % Update reading count
        prev_temp = temp;

        if reading_count == 30 % Every 30 readings (30 seconds)
            celsius_per_minute = (rate_sum / reading_count) * 60; % Calculate average rate per minute
            disp(['Mean Temperature change: ', num2str(celsius_per_minute), '°C/min']);
            disp(['Expected temperature after 5 minutes: ', num2str(temp + (celsius_per_minute * 5)), '°C']);

            % Reset variables for the next 30 readings
            reading_count = 0;
        end

        % Control LEDs based on the rate of temperature change
        if celsius_per_minute > 4
            writeDigitalPin(a, 'D9', 0);
            writeDigitalPin(a, 'D10', 0);  
            writeDigitalPin(a, 'D11', 1);
        elseif celsius_per_minute < -4
            writeDigitalPin(a, 'D9', 0);
            writeDigitalPin(a, 'D10', 1);
            writeDigitalPin(a, 'D11', 0);
        else
            writeDigitalPin(a, 'D9', 1);
            writeDigitalPin(a, 'D10', 0);
            writeDigitalPin(a, 'D11', 0);            
        end

        pause(1); % Pause for 1 second between readings
    end
end
