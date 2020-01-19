close all;
clear all;

Data = csvread("dataset_noclass.csv",1); 
%% initialize random weights;
initialweights = rand(2,3);
weights = initialweights;
ci = 0.5; % initial learning rate
e = 0.1;
% epoch loops
for i = 1:1000
    % change learning rate with each epoch
    c = ci*exp(-0.001*i);
    for j = 1:length(Data)
        % calculate distance
        Distance = weights - [Data(j,:);Data(j,:)];
        Distance = sum(Distance.^2,2);
        % find minimum distance
        [O,I] = min(Distance);
        % adjust "winning node"
        delta = (Data(j,:)-weights(I,:));
        weights(I,:) = weights(I,:)+c*delta;
    end
    
    % if weights are not significantly changing stop traning
    if (sum(abs(delta))<e)
        break;
    end
    
end

%% plot data
figure;
label = zeros(1000,1);
count1 = 0;
count2 = 0;
for i = 1:length(Data)
    Out = weights * Data(i,:)';
    [O,I] = max(Out);
    if (I == 1)
        count1 = count1+1;
        scatter3(Data(i,1),Data(i,2),Data(i,3),'b')
        hold on;
    else
        count2 = count2+1;
        scatter3(Data(i,1),Data(i,2),Data(i,3),'r')
        hold on; 
    end
    label(i) = I;
end
error1 = 0;
error2 = 0;
for k = 1:length(Data)
    Distance = weights - [Data(k,:);Data(k,:)];
    Distance = sum(Distance.^2,2);
    [O,I] = min(Distance)
    if (I ==1)
        error1 = error1 + Distance(1);
    else
        error2 = error2 + Distance(2);
    end
end
csvwrite('clusterdata_Kohonen.csv',[Data,label]);
