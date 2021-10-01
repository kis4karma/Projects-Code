%% Finite Difference Technique part 2
% by Sean Hanson

clear all;
clc;

rownum = 200;                               % number of rows and columns (nodes) in matrix in millimeters
iterationCount = 40000;                         % number of iterations to converge node difference to 0
volt = 50;                                  % voltage for particular nodes
voltrow = 26;                               % row to start adding volt value
voltcolumn = 16;                            % column to start adding volt value
b=1;
V_mat = zeros(rownum+2);                    % adds zeros to all nodes
for b =1:49                                 % 'for' loop to add 50 volts to each node
  voltcolumn = 16;                 
    
    for a = 1:159                            % 'for' loop to add 50 volt to nodes to row/columns
    V_mat(voltrow,voltcolumn) = 50;
    voltcolumn = voltcolumn + 1;
    
    end
    voltrow = voltrow+1;

end
  
for z= 1:iterationCount                     % for loop for iteration counter
 
V_mat_old = V_mat;                          
   for n = 1:100                         % loop that averages the nodes from surrounding nodes n = rows
        for m = 1:rownum                        % m = columns
            if n<25 || n>73
            V_mat(n+1,m+1)= 1/4 *(V_mat(n,m+1) +V_mat(n+2,m+1)+V_mat(n+1,m) ++V_mat(n+1,m+2));
            elseif (m<15 || m>173)       
            V_mat(n+1,m+1)= 1/4 *(V_mat(n,m+1) +V_mat(n+2,m+1)+V_mat(n+1,m) ++V_mat(n+1,m+2));
            end
        end
   end


    for g = 101:rownum                           % loop starting with the grounding pole g is rows
        for p = 1:rownum                         % p = columns
            if p<95 || p>105
            V_mat(g+1,p+1)= 1/4 *(V_mat(g,p+1) +V_mat(g+2,p+1)+V_mat(g+1,p) ++V_mat(g+1,p+2));
             end
        end
    end
 end

%Charge Density plot
%Charge Density formula is p = E0 * E
%E0 = Permitivity of air, 8.85 * 10 e^-12
%E = Voltage Potential at given point
bottomofcloud = V_mat(75,:);                        % Extract row 75
bottomofcloud = bottomofcloud(:,17:174);             % Extract columns 1-200, cloud covers columns 17-174


        
 E0 = 8.85;                                          %in picos
 chargedensity = bottomofcloud * E0;                 %bottom of cloud is in Volts
 cloudlength = 1:200;                                % in meters
 figure()

plot(cloudlength,chargedensity)

xlabel('Cloud length (m)')
ylabel('Charge Density (C/m)')
title('Charge density below cloud surface')
axis([20 176 0 455])

 
            




V_mat_new = V_mat;
Error = (V_mat_new - V_mat_old);            % difference between the old node value and new node value
figure()
surf(V_mat)                                 % graph of cloud with grounding pole
xlabel('width (m)')
ylabel('length(m)')
title('Cloud over a Grounding Pole')
Error =(sum(sum(Error)));                   % the summation of the difference between iterations
fprintf('At %d iterations the error converges to %d\n\n'  ,iterationCount,Error);
