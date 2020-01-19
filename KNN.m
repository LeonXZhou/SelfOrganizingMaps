close all;
clear all;
Data = csvread("dataset_noclass.csv",1);
initialweights = rand(2,3);
weights = initialweights;
e = 1.0; %error threshold
de =0.0001; %min change of centroid
%epoch loop
for i = 1:10000
    %different clusters
    cluster1 = zeros(1000,3);
    cluster2 = zeros(1000,3);
    %count of points in each cluster
    count1 = 0;
    count2 = 0;
    for j = 1:length(Data)
        % calculate distance and find winning node
        Distance = weights - [Data(j,:);Data(j,:)];
        Distance = sum(Distance.^2,2);
        [O,I] = min(Distance);
        % add point to winning node cluster
        if (I ==1)
            cluster1(j,:) = Data(j,:);
            count1 = count1+1;
        else
            cluster2(j,:) = Data(j,:);
            count2 = count2+1;
        end
        
        %if centroid is not changing stop traning
        if sum(abs(weights(1,:)-sum(cluster1)/count1)+abs(weights(2,:) - sum(cluster2)/count2))<de
            break;
        end
        
        %caclulate new centroids
        if count1 ~=0
            weights(1,:) = sum(cluster1)/count1;
        end
        if count2 ~=0
            weights(2,:) = sum(cluster2)/count2;
        end
        
        % calculate mean squared error
        error = 0;
        for k = 1:length(Data)
            Distance = weights - [Data(k,:);Data(k,:)];
            Distance = sum(Distance.^2,2);
            [O,I] = min(Distance);
            if (I ==1)
                error = error + Distance(1);
            else
                error = error + Distance(2);
            end
        end
        error = error/k;
        % if error is below threshold stop training
        if error <e
            break;
        end
    end
        if error <e
            break;
        end
        if sum((weights(1,:)-sum(cluster1)/count1)+(weights(2,:) - sum(cluster2)/count2))<de
            break;
        end
    
end
%% plot data and write to csv
figure;
label = zeros(1000,1);
count = 0;
for i = 1:length(Data)
    Out = weights * Data(i,:)';
    [O,I] = max(Out);
    if (I == 1)
        scatter3(Data(i,1),Data(i,2),Data(i,3),'b')
        hold on;
        count = count+1;
    else
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

csvwrite('clusterdata_Kmean.csv',[Data,label]);

