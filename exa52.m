% Define the model parameters
s = [14, 17, 20, 23]; % number of servers
mu = 1 / 0.00001; % service rate (messages per second)
K = 600; % buffer size

% Define the range of message arrival rates
lambda = 1000000:100000:2000000; % message arrival rates (messages per second)

% Calculate the utilization factor (rho, epsilon) for each s and lambda value

% Calculate the blocking probability (p_C^y) and resource usage (R_M) for each s and lambda value
p_0 = zeros(length(s), length(lambda));
p_C = zeros(length(s), length(lambda));
R_M = zeros(length(s), length(lambda));

for i = 1:length(s)
    for j = 1:length(lambda)
        y=0;
        rho(i,j) = lambda(j)/mu;
        epsilon(i,j) = lambda(j)/(s(i)*mu);    
        if (epsilon(i,j) ~= 1)
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(1-epsilon(i,j)^(K-s(i)+1))/(1-epsilon(i,j))+sum(rho(i,j).^([0:s(i)-1])./factorial([0:s(i)-1])))^-1;
        else
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(K-s(i)+1)+sum(rho(i,j).^([0:s(i)-1])./factorial([0:s(i)-1])))^-1;
        end
        if(y>=0 && y<s(i)) 
            p_C(i,j) = p_0(i,j)*rho(i,j)^y/factorial(y);
        elseif (y<=K)
            p_C(i,j) = p_0(i,j)*rho(i,j)^(y)/factorial(s(i))/s(i)^(y-s(i));
        end
        R_M(i,j) = epsilon(i,j)*(1-p_C(i,j));
        if(R_M(i,j)<=1) R_M1(i,j) = R_M(i,j);
        else R_M1(i,j) = 1;
        end
        tau_M1(i,j) = R_M1(i,j)*s(i)*mu;
    end
end

% Set the JMT simulation result points.
tau_M2 = [1.00E6,	1.11E6,	1.20E6,	1.30E6,	1.39E6,	1.41E6,	1.40E6,	1.40E6,	1.39E6,	1.42E6,	1.41E6;
        9.95E5,	1.11E6,	1.20E6,	1.30E6,	1.41E6,	1.49E6,	1.59E6,	1.68E6,	1.69E6,	1.69E6,	1.69E6;
        9.96E5,	1.10E6,	1.20E6,	1.30E6,	1.41E6,	1.50E6,	1.60E6,	1.69E6,	1.81E6,	1.90E6,	1.98E6;
        9.93E5,	1.10E6,	1.20E6,	1.30E6,	1.40E6,	1.49E6,	1.59E6,	1.70E6,	1.81E6,	1.91E6,	2.01E6];

% Plot the resource usage (R_M^y) as a function of message arrival rate for each s value
figure;
hold on;
plot(lambda, tau_M2(1,:), 'b-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, tau_M2(2,:), 'r-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, tau_M2(3,:), 'm-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, tau_M2(4,:), 'g-', 'LineWidth',1.5,'MarkerSize',6);
xlabel('Message Arrival Rate (messages/second)');
ylabel('Mean Throughput Message (messages/second)');
title('Comparison of Eqation results vs Simulation results in the relationship of Mean Throughput Message and Message Arrival Rate')
plot(lambda, tau_M1(1,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, tau_M1(2,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, tau_M1(3,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, tau_M1(4,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
legend('vMEC=14', 'vMEC=17', 'vMEC=20', 'vMEC=23','analytical result','Location','southeast');
grid on