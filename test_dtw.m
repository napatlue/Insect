function  test_dtw()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    data = sound2vector();
    correct = 0;
    converted_data = data.converted_data;
    size(converted_data,1)
    size(converted_data,2)
    TEST_class_labels = data.actual_class;
    
    testInstanceLabel = PartitionHeldOut(TEST_class_labels,20,11);
    sum(testInstanceLabel)
    
    [XTrain,YTrain] = GetXYTrain(converted_data, TEST_class_labels, testInstanceLabel);
    [XTest,YTest] = GetXYTest(converted_data, TEST_class_labels, testInstanceLabel);
    
    size(XTrain)
    size(YTrain)
    size(XTest)
    %converted_data = converted_data(1:10,:);
    %TEST_class_labels = data.actual_class(1:10);
    for i=1 : length(YTest)
        classify_object = XTest(i,:);
        actual_class = YTest(i);
        best_distance = inf;
        predicted_class = 0;
        for j=1 : length(YTrain)
                compare_object = XTrain(j,:);
                %this_distance = Distance_Algorithm(classify_object,compare_object);
                %this_distance = rand_distance(classify_object,compare_object);
                %this_distance = euclidian_distance(classify_object,compare_object);
                this_distance = dtw(classify_object,compare_object);
                size(compare_object);
                size(classify_object);
                %this_distance = cosine_distance(classify_object,compare_object);
                
                if(this_distance < best_distance)
                    best_distance = this_distance;
                    predicted_class = YTrain(j);
                end
        end
        if(predicted_class == actual_class)
            correct = correct+1;
            disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), 'done, correctly classify ']);
        else
            disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), 'done, misclassified ']);
            
        end 
        
    end
    error_rate = (length(YTest)-correct)/length(YTest);
    
    %disp(['Evaluation Result For ' distance_func '.']);
    disp(['The Data Set has ' int2str(length(unique(TEST_class_labels))) 'Classses.']);
    disp(['The Data Set is of the Size ' int2str(length(TEST_class_labels)) '.']);
    disp(['The Error Rate was ' num2str(error_rate) '.']);

end



