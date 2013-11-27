


function [ accu ] = train_peak_dist( timeseries, classlabels )
    %Train data in the training set
    %20 percent of test data
    %11 total kinds of classlabels
    testInstances = PartitionHeldOut(classlabels, 20, 11);
    [XTrain, YTrain] = GetXYTrain(timeseries, classlabels, testInstances);
    [XTest, YTest] = GetXYTest(timeseries, classlabels, testInstances);
    train_dist_set = zeros(size(XTrain,1),2);
    
    ct = 1;
    for i=1:size(XTrain,1)
        t = XTrain(i,:);
        t = fft(t);
        t = abs(t);
        dist = peak_distance(t(1:round(size(t,2)/2)));
        if dist == 0 || dist > 1000           
            continue;
        else       
        trainlabel = YTrain(i);
        train_dist_set(ct,1) = trainlabel;
        
        train_dist_set(ct,2) = dist;
        ct = ct+1;
        end
    end
    
    [stds, means] = purify_mean(train_dist_set,3);
    correct = 0;
    for i=1:size(XTest,1)
        t = XTest(i,:);
        t = fft(t);
        t = abs(t);
        dist = peak_distance(t(1:round(size(t,2)/2)));
        min_dist = inf;
        
        for j=1:size(means,1)
            
            new_dist = abs(dist-means(j,2));
           if round(new_dist) < round(min_dist)
                min_dist = new_dist;
                asg_label = means(j,1);
           end
           
        end
        if asg_label == YTest(i,1)
            correct = correct + 1;
            %disp([int2str(i), ' out of ', int2str(size(XTest,1)), 'done, correctly classify ']);
        else
            %disp([int2str(i), ' out of ', int2str(size(XTest,1)), 'done, wrongly classify']);
            disp(['dist: ', int2str(round(dist)),' classified as ',int2str(asg_label), ' actual class ',int2str(YTest(i,1))]);
        end
    end
    stds
    means
    accu = correct/size(XTest,1);
    
end

