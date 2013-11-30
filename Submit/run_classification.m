function run_classification()
% Run classification
    data = sound2vector();
    correct = 0;
    converted_data = data.converted_data;
    size(converted_data,1);
    size(converted_data,2);
    TEST_class_labels = data.actual_class;
        
    [converted_data,ori] = preProcessWave(converted_data);
    
    transform_data=zeros(1100,6);
     
    % Extract features
    for i = 1:size(converted_data ,1)
        [ pks,locs,dist12,dist23] = getpeaks(converted_data(i,:));
        
        transform_data(i,1) = locs(1);
        transform_data(i,2) = locs(2);
        transform_data(i,3) = dist12;
        transform_data(i,4) = pks(1);
        transform_data(i,5) = pks(2);
        transform_data(i,6) = size(pks,2)^2;
        
%         if(size(locs,2)>=3)
%             transform_data(i,3) = locs(3);
%         end
        
     end
     
     D = pdist(transform_data,'seuclidean');
     Dm = squareform(D);
     
     Dcs = pdist(converted_data,'seuclidean');
     Dmcs = squareform(Dcs);
     
     
     Dori = pdist(ori,'seuclidean');
     Dmori = squareform(Dori);
          
     
    for i=1 : length(TEST_class_labels)

        classify_object = transform_data(i,:);
        actual_class = TEST_class_labels(i);
        
        best_distance = inf;
        
        for j=1 : length(TEST_class_labels)
            if(j ~= i)
                compare_object = transform_data(j,:);
                %this_distance = Distance_Algorithm(classify_object,compare_object);
                %this_distance = rand_distance(classify_object,compare_object);
                %this_distance = euclidian_distance(classify_object,compare_object);
                %this_distance = dtw(classify_object,compare_object);
                %this_distance = cosine_distance(classify_object,compare_object);
                
                % combine distance
                this_distance = Dm(i,j)^3+Dmcs(i,j)^3+Dmori(i,j);
                
                if(this_distance < best_distance)
                    best_distance = this_distance;
                    predicted_class = TEST_class_labels(j);
                end
                
     
            end
           
            %disp([int2str(correct), ' out of ', int2str(i)]);
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

