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
       
        rho(i,j) = lambda(j)/mu;
        epsilon(i,j) = lambda(j)/(s(i)*mu);    
        if (epsilon(i,j) ~= 1)
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(1-epsilon(i,j)^(K-s(i)+1))/(1-epsilon(i,j))+sum(rho(i,j).^(0:s(i)-1)./factorial(0:s(i)-1)))^-1;
        else
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(K-s(i)+1)+sum(rho(i,j).^(0:s(i)-1)./factorial(0:s(i)-1)))^-1;
        end
        blocking_prob(i,j)=s(i)*mu*p_0(i,j)*epsilon(i,j)^(K-s(i))*rho(i,j)^(s(i))/factorial(s(i));
        
    end
end

% Set the JMT simulation result points.
blocking_prob2 = [0.0,	0.0,	0.0,	0.0,	5038.0945,	1.01E5,	1.97E5,	3.01E5,	4.01E5,	4.93E5,	6.08E5;
                  0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	1.00E5,	2.03E5,	3.00E5;
                  0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	1636.13954;
                  0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0,	0.0];

% Plot the resource usage (R_M^y) as a function of message arrival rate for each s value
figure;
hold on;
plot(lambda, blocking_prob2(1,:), 'b-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, blocking_prob2(2,:), 'r-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, blocking_prob2(3,:), 'm-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, blocking_prob2(4,:), 'g-', 'LineWidth',1.5,'MarkerSize',6);
xlabel('Message Arrival Rate (messages/second)');
ylabel('System Drop Rate (messages/second)');
title('Comparison of Eqation results vs Simulation results in the relationship of System Drop Rate and Message Arrival Rate')
plot(lambda, blocking_prob(1,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, blocking_prob(2,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, blocking_prob(3,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, blocking_prob(4,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
legend('vMEC=14', 'vMEC=17', 'vMEC=20', 'vMEC=23','analytical result','Location','northwest');
grid on
