
 
function [temperature] = temp_monitor (a,voltage)
temperature = (voltage - 0.5) * 100; % Convert voltage to temperature
greenLED = 'D9';
    yellowLED = 'D10';
    redLED = 'D11';
% Control LEDs based on temperature
        if temperature >= 18 && temperature <= 24
            writeDigitalPin(a, greenLED, 1);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 0);
        elseif temperature < 18
           blinkLED(a, yellowLED, 0.5);% yellow blinks below 18°C
        else
             blinkLED(a, redLED, 0.25);  % red blinks above 24°C.
        end

    end
    % Function to blink  LED
function blinkLED(a, pin, delay)
    writeDigitalPin(a, pin, 1);
    pause(delay);
    writeDigitalPin(a, pin, 0);
    pause(delay);
end