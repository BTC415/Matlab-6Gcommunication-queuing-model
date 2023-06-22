% Define the model parameters
s = [14, 17, 20, 23]; % number of servers
mu = 1 / 0.00001; % service rate (messages per second)
K = 600; % buffer size

% Define the range of message arrival rates
lambda = 1200000:100000:2000000; % message arrival rates (messages per second)

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
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(1-epsilon(i,j)^(K-s(i)+1))/(1-epsilon(i,j))+sum(rho(i,j).^(0:s(i)-1)./factorial(0:s(i)-1)))^-1;
        else
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(K-s(i)+1)+sum(rho(i,j).^(0:s(i)-1)./factorial(0:s(i)-1)))^-1;
        end
        avg_waiting_msg(i,j)=0;
        for iii=s(i)+1:K
            avg_waiting_msg(i,j)=avg_waiting_msg(i,j)+p_0(i,j)*(iii-s(i))*epsilon(i,j)^(iii-s(i))*rho(i,j)^(s(i))/factorial(s(i));
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
        mean_waiting_time(i,j) = avg_waiting_msg(i,j)/tau_M1(i,j);
        
    end
end


% Set the JMT simulation result points.
mean_waiting_time2 = [2.40E-6, 6.97E-6, 2.21E-4, 4.03E-4, 4.17E-4, 4.20E-4, 4.15E-4, 4.17E-4, 4.21E-4;
                     2.57E-7, 5.56E-7, 1.20E-6, 2.59E-6, 7.01E-6, 1.60E-4, 3.31E-4, 3.41E-4, 3.39E-4;
                     3.19E-8, 6.76E-8, 1.64E-7, 3.28E-7, 6.33E-7, 1.21E-6, 2.90E-6, 7.71E-6, 1.60E-4;
                     2.86E-9, 8.01E-9, 2.09E-8, 4.50E-8, 1.05E-7, 1.88E-7, 3.54E-7, 7.34E-7, 1.39E-6];

% Plot the resource usage (R_M^y) as a function of message arrival rate for each s value
figure;
hold on;
plot(lambda, mean_waiting_time2(1,:), 'b-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_waiting_time2(2,:), 'r-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_waiting_time2(3,:), 'm-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_waiting_time2(4,:), 'g-', 'LineWidth',1.5,'MarkerSize',6);
xlabel('Message Arrival Rate (messages/second)');
ylabel('Mean Waiting Time (second)');
title('Comparison of Eqation results vs Simulation results in the relationship of Mean Waiting Time and Message Arrival Rate')
plot(lambda, mean_waiting_time(1,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_waiting_time(2,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_waiting_time(3,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_waiting_time(4,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
legend('vMEC=14', 'vMEC=17', 'vMEC=20', 'vMEC=23','analytical result','Location','northwest');
grid on

