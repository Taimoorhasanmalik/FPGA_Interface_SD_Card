s= serialport ("Com10", 921600);
%%
data_arr = get_data(s);
[head, ann, data]= process_data(data_arr);
%%
n =1; %selecting the patient number to work with

patient_head= data_arr(head(n)+4:ann(n)-5);
char(patient_head);
patient_ann= data_arr(ann(n):data(n)-5);
patient_data= data_arr(data(n):head(n+1)-1);
%%
decoded_data = decode212array(patient_data);
%%
scaled = process_raw_data(decoded_data , 360, 1024, 200); 
%%
scaled = scaled(1:end-1);
%%

channel1= scaled(1:2:end);
channel2= scaled(2:2:end);

%%

fs = 360;
tm = (0:length(channel1) -1)/fs;  % Generate time vector
figure;
subplot(2,1,1);
plot(tm, channel1);
xlabel('Time (s)');
ylabel('Amplitude');
title('Patient Data Plot');
grid on;


tm = (0:length(channel2) -1)/fs;  % Generate time vector
subplot(2,1,2);
plot(tm, channel2);
xlabel('Time (s)');
ylabel('Amplitude');
title('Patient Data Plot');
grid on;
