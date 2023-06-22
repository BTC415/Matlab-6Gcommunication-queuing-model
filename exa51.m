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
        
    end
end

% Set the JMT simulation result points.
R_M2 = [0.7049,	0.7865,	0.8491,	0.9325,	1.0000,	1.0000,	1.0000,	1.0000,	1.0000,	1.0000,	1.0000;
        0.5829,	0.6545,	0.7003,	0.7734,	0.8365,	0.8814,	0.9299,	0.9939,	1.0000,	1.0000,	1.0000;
        0.4950,	0.5444,	0.5989,	0.6470,	0.7027,	0.7477,	0.8036,	0.8575,	0.8956,	0.9516,	0.9995;
        0.4312,	0.4777,	0.5211,	0.5624,	0.6081,	0.6484,	0.6909,	0.7386,	0.7932,	0.8210,	0.8725];

% Plot the resource usage (R_M^y) as a function of message arrival rate for each s value
figure;
hold on;
plot(lambda, R_M2(1,:), 'b-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, R_M2(2,:), 'r-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, R_M2(3,:), 'm-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, R_M2(4,:), 'g-', 'LineWidth',1.5,'MarkerSize',6);
xlabel('Message Arrival Rate (messages/second)');
ylabel('Resource Usage (%)');
title('Comparison of Eqation results vs Simulation results in the relationship of Resource Usage and Message Arrival Rate')
plot(lambda, R_M1(1,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, R_M1(2,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, R_M1(3,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, R_M1(4,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
legend('vMEC=14', 'vMEC=17', 'vMEC=20', 'vMEC=23','analytical result','Location','southeast');
grid on