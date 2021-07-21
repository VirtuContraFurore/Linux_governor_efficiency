%% Place here the input file in the "csv" format
input = "userspace_freq2.csv";

%% Read input data
data = csvread(input);
time = data(:,1);
% set time to reference zero
time = time - time(1)*ones(size(time));
% convert frequency to GHz from Hz
scaling_frequency = data(:,2)/1000000;
current_frequency = data(:,3)/1000000;

%% Setup moving average filter
n = 20;
coef = 1/n*ones(n,1);


%% Plot data and apply filter
hold off;
plot(time,filter(coef, 1, current_frequency));
hold on;
plot(time,filter(coef, 1, scaling_frequency));
ytickformat('%.3f');
legend("current frequency", "scaling frequency");
xlabel("time [s]");
ylabel("Frequency [GHz]");
title(extractBefore(input, '_'));
