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
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(1-epsilon(i,j)^(K-s(i)+1))/(1-epsilon(i,j))+sum(rho(i,j).^(0:s(i)-1)./factorial(0:s(i)-1)))^-1;
        else
            p_0(i,j) = (rho(i,j)^s(i)/factorial(s(i))*(K-s(i)+1)+sum(rho(i,j).^(0:s(i)-1)./factorial(0:s(i)-1)))^-1;
        end
        mean_msg_requ(i,j)=0;
        for ii=1:s(i)
            mean_msg_requ(i,j)=mean_msg_requ(i,j)+ii*p_0(i,j)*rho(i,j)^ii/factorial(ii);
        end
        for iii=s(i)+1:K
            mean_msg_requ(i,j)=mean_msg_requ(i,j)+p_0(i,j)*iii*epsilon(i,j)^(iii-s(i))*rho(i,j)^(s(i))/factorial(s(i));
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
        mean_response_time(i,j) = mean_msg_requ(i,j)/tau_M1(i,j);
        
    end
end


% Set the JMT simulation result points.
mean_response_time2 = [2.12E-5, 2.19E-5, 2.28E-5, 2.77E-5, 2.56E-4, 4.33E-4, 4.33E-4, 4.36E-4, 4.37E-4, 4.36E-4, 4.34E-4;
                  2.07E-5, 2.08E-5, 2.10E-5, 2.15E-5, 2.19E-5, 2.37E-5, 2.86E-5, 2.00E-4, 3.51E-4, 3.61E-4, 3.61E-4;
                  2.06E-5, 2.07E-5, 2.09E-5, 2.11E-5, 2.12E-5, 2.13E-5, 2.19E-5, 2.20E-5, 2.37E-5, 2.90E-5, 1.55E-4;
                  2.05E-5, 2.07E-5, 2.09E-5, 2.09E-5, 2.10E-5, 2.09E-5, 2.12E-5, 2.16E-5, 2.18E-5, 2.23E-5, 2.33E-5];

% Plot the resource usage (R_M^y) as a function of message arrival rate for each s value
figure;
hold on;
plot(lambda, mean_response_time2(1,:), 'b-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_response_time2(2,:), 'r-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_response_time2(3,:), 'm-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_response_time2(4,:), 'g-', 'LineWidth',1.5,'MarkerSize',6);
xlabel('Message Arrival Rate (messages/second)');
ylabel('Mean Response Time (second)');
title('Comparison of Eqation results vs Simulation results in the relationship of Mean Response Time and Message Arrival Rate')
plot(lambda, mean_response_time(1,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_response_time(2,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_response_time(3,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_response_time(4,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
legend('vMEC=14', 'vMEC=17', 'vMEC=20', 'vMEC=23','analytical result','Location','northwest');
grid on

