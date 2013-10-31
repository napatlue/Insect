function  test_classification()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    data = sound2vector();
    correct = 0;
    converted_data = data.converted_data;
    size(converted_data,1);
    size(converted_data,2);
    TEST_class_labels = data.actual_class;
    
    %converted_data = converted_data(1:10,:);
    %TEST_class_labels = data.actual_class(1:10);
    for i=1 : length(TEST_class_labels)
        classify_object = converted_data(i,:);
        actual_class = TEST_class_labels(i);
        best_distance = inf;
        
        for j=1 : length(TEST_class_labels)
            if(j ~= i)
                compare_object = converted_data(j,:);
                %this_distance = Distance_Algorithm(classify_object,compare_object);
                %this_distance = rand_distance(classify_object,compare_object);
                %this_distance = euclidian_distance(classify_object,compare_object);
                this_distance = dtw(classify_object,compare_object);
                %this_distance = cosine_distance(classify_object,compare_object);
                if(this_distance < best_distance)
                    best_distance = this_distance;
                    predicted_class = TEST_class_labels(j);
                end
                
     
            end
           
            disp([int2str(correct), ' out of ', int2str(i)]);
        end
        if(predicted_class == actual_class)
            correct = correct+1;
            disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), 'done, correctly classify ']);
        else
            disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), 'done, misclassified ']);
            
        end 
        
    end
    error_rate = (length(TEST_class_labels)-correct)/length(TEST_class_labels);
    
    %disp(['Evaluation Result For ' distance_func '.']);
    disp(['The Data Set has ' int2str(length(unique(TEST_class_labels))) 'Classses.']);
    disp(['The Data Set is of the Size ' int2str(length(TEST_class_labels)) '.']);
    disp(['The Error Rate was ' num2str(error_rate) '.']);

end

