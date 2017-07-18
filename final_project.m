%% Open port %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; close all; clear all;  
%find your port on a mac:
%ls /dev/tty.usb*

%a = arduino('/dev/tty.usbserial-DA011JBC','UNO');

%windows 
a = arduino('COM3', 'UNO')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read voltage
% use this code to read the voltage output from an
% analog sensor. Be sure to use a voltage divider to get good 
% readings.

tic;                            % start a timer
duration=60;                    % duration in seconds
i=0;                            % initialize loop counter

configurePin(a,'A0','analogInput')
configurePin(a,'A1','analogInput')
configurePin(a,'A2','analogInput');
LEDpin1 = 'D3';
LEDbrightness = 1;

while toc<duration              % start a loop that will run for duration
    i=i+1;                      % increment counter each iteration
    time(i)=toc;                % builds array of elapsed time values
    
    p(i)= readVoltage(a, 'A2');
    if p(i) >= 4
        LEDbrightness =  (1/4)
    elseif p(i) >= 2.5
        LEDbrightness =  (1/2)
    elseif p(i) >= 0
        LEDbrightness =  (1)
    end
    
    f(i)= readVoltage(a, 'A0');  % builds an array of voltages from analog
    if f(i) >= 4
        writePWMDutyCycle(a, 'D3', LEDbrightness)
    else 
        writePWMDutyCycle(a, 'D3', 0)
    end
    
    c(i)= readVoltage(a, 'A1');
    y(i) = [(c(i)*(3300/1024))]*10;
    if y(i) >= 24
        writePWMDutyCycle(a, 'D5', 1)
    else 
        writePWMDutyCycle(a, 'D5', 0)
    end
        
    figure(1);
    subplot(3,1,1)
    plot(time,f,'g')
    title('Flex Sensor')
    ylabel('Flexing Level (in Voltage)')
    xlabel('Time (s)')
    
    subplot(3,1,2)
    plot(time,y,'k')
    title('Temperature Sensor')
    ylabel('Temperature in C')
    xlabel('Time (s)')
    
    subplot(3,1,3)
    plot(time,p,'b')
    title('Photoresistor')
    ylabel('light level (in Voltage)')
    xlabel('Time (s)')
    pause(0.1);                % set sampling rate
end
        fid = fopen('finalproject2.txt', 'w');
        fprintf(fid, 'Voltage Through Flex Sensor\n\n');
        fprintf(fid,'%2.5f\n', f);
        fprintf(fid, '\n\nVoltage Through Light Sensor\n\n');
        fprintf(fid,'%2.5f\n', p);
        fprintf(fid, '\n\nTemperature Change\n\n');
        fprintf(fid,'%2.5f\n', y);
        fclose(fid);