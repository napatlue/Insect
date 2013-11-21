function insect_classification( distance_func )
    wave_path = 'wavefiles/';
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    %Distance_Algorithm = makeHandle(distance_func);
    %Distance_Algorithm = str2function(distance_func);
    TEST_DATA = dir([wave_path,'*.wav']);
    
    TEST_class_labels = importdata('classLabel.mat');
    correct = 0;
    
    for i=1 : length(TEST_class_labels)
        classify_filename = TEST_DATA(i).name;
        
        classify_object = wavread([wave_path, classify_filename]);
        
        actual_class = TEST_class_labels(i,2);
        best_distance = inf;
        
        for j=1 : length(TEST_DATA)
            if(j ~= i)
                compare_filename = TEST_DATA(j).name;               
                compare_object = wavread([wave_path, compare_filename]);
                %this_distance = Distance_Algorithm(classify_object,compare_object);
                this_distance = euclidian_distance(classify_object,compare_object);
                if(this_distance < best_distance)
                    best_distance = this_distance;
                    predicted_class = TEST_class_labels(j,2);
                end
                
                
            end
           
        end
        if(predicted_class == TEST_class_labels(j,2))
            correct = correct+1;
            disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), 'done, correctly classify ']);
        else
            disp([int2str(i), ' out of ', int2str(length(TEST_class_labels)), 'done, misclassified ']);
            
        end 
        
    end
    error_rate = (length(TEST_class_labels)-correct)/length(TEST_class_labels);
    
    disp(['Evaluation Result For ' distance_func '.']);
    disp(['The Data Set has ' int2str(length(unique(TEST_class_labels(:,2)))) 'Classses.']);
    disp(['The Data Set is of the Size ' int2str(length(TEST_class_labels)) '.']);
    disp(['The Error Rate was ' num2str(error_rate) '.']);
    
end

