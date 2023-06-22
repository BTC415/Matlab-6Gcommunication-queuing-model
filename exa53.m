% Define the model parameters
s = [14, 17, 20, 23]; % number of servers
mu = 1 / 0.00001; % service rate (messages per second)
K = 600; % buffer size

% Define the range of message arrival rates
lambda = 1300000:100000:2500000; % message arrival rates (messages per second)

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
        mean_msg_requ(i,j)=0;
        for ii=1:s(i)
            mean_msg_requ(i,j)=mean_msg_requ(i,j)+ii*p_0(i,j)*rho(i,j)^ii/factorial(ii);
        end
        for iii=s(i)+1:K
            mean_msg_requ(i,j)=mean_msg_requ(i,j)+p_0(i,j)*iii*epsilon(i,j)^(iii-s(i))*rho(i,j)^(s(i))/factorial(s(i));
        end
    end
end

% Set the JMT simulation result points.
mean_msg_requ2 = [36.1372, 448.2709, 604.4290, 609.5042, 611.0202, 612.1450, 612.2992, 612.7632, 613.5447, 613.4673, 614.2219, 613.9967, 614.2976;
                  27.7774, 31.1058, 35.6129, 45.5727, 366.2270, 599.8439, 611.3228, 614.6429, 614.7070, 615.1051, 616.4094, 616.5185, 617.0064;
                  27.2861, 29.5792, 32.1488, 34.4917, 38.2366, 43.1211, 55.4350, 293.9357, 601.7387, 612.5882, 618.4006, 620.7390, 619.7454;
                  27.0137, 29.1379, 32.0862, 34.2656, 36.0955, 39.0952, 42.6568, 46.9772, 53.4866, 70.5881, 331.0303, 613.1030, 623.2177];

% Plot the resource usage (R_M^y) as a function of message arrival rate for each s value
figure;
hold on;
plot(lambda, mean_msg_requ2(1,:), 'b-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_msg_requ2(2,:), 'r-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_msg_requ2(3,:), 'm-', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_msg_requ2(4,:), 'g-', 'LineWidth',1.5,'MarkerSize',6);
xlabel('Message Arrival Rate (messages/second)');
ylabel('Mean number of requests(Messages)');
title('Comparison of Eqation results vs Simulation results in the relationship of Mean number of requests and Message Arrival Rate')
plot(lambda, mean_msg_requ(1,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_msg_requ(2,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_msg_requ(3,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
plot(lambda, mean_msg_requ(4,:), 'k--', 'LineWidth',1.5,'MarkerSize',6);
legend('vMEC=14', 'vMEC=17', 'vMEC=20', 'vMEC=23','analytical result','Location','southeast');
grid on

