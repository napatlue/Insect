function  test_classification()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    data = sound2vector();
    correct = 0;
    converted_data = data.converted_data;
    size(converted_data,1);
    size(converted_data,2);
    TEST_class_labels = data.actual_class;
     
    %da = dbaux(4);
    size(TEST_class_labels,1)
    
    %extracted = extract_feature(converted_data);    
    %for i=1 : length(TEST_class_labels)
       % converted_data(i,:) = filter(da,1,converted_data(i,:));
      %t = converted_data(i,:);
     %  t = extracted(i,:);

      %f = fft(t);
      %f = rceps(t); 
      %f = abs(f); % magnitude 
      
      
      %transform_data(i,:) = f';
      
      %transform_data(i,:) = [A1 A2 A3 A4 A5];
      %[COEFF,SCORE,latent] = princomp(f);
      %transform_data(i,:) = SCORE;
      
      
    %end
    %extracted = extract_feature(transform_data);
    %converted_data = converted_data(1:10,:);
    %TEST_class_labels = data.actual_class(1:10);
%    transform_data = extract_wavelet_coeff(converted_data,14,'db4');
 %     for i = 1:size(converted_data ,1)
 %         %[C(i,:),L] = wavedec(converted_data(i,:),14,'db4');
 %        [a1,d1] = dwt(converted_data(i,:),'db4');
 %        [a2,d2] = dwt(a1,'db4');
 %        [a3,d3] = dwt(a2,'db4');
 %        transform_data(i,:) = [a2,a3];
         
 %     end
    
    %coef = keep_feature(C,L,level);
    
  %  for i = 1:size(converted_data,1)
  %      transform_data(i,:) = abs(waverec(C(i,:),L,'haar'));
  %  end
  %  for i = 1:size(transform_data,1)
  %      transform_data(i,:) = abs(fft(transform_data(i,:)));
  %  end
    
    transform_data = converted_data;
    for i=1 : length(TEST_class_labels)
        %classify_object = converted_data(i,:);
        
        classify_object = transform_data(i,:);
        actual_class = TEST_class_labels(i);
        
        best_distance = inf;
        
        for j=1 : length(TEST_class_labels)
            if(j ~= i)
                %compare_object = converted_data(j,:);
                compare_object = transform_data(j,:);
                %this_distance = Distance_Algorithm(classify_object,compare_object);
                %this_distance = rand_distance(classify_object,compare_object);
                %this_distance = euclidian_distance(classify_object,compare_object);
                %this_distance = dtw(classify_object,compare_object);
                %this_distance = cosine_distance(classify_object,compare_object);
                
                %this_distance = sum(abs(compare_object-classify_object)); 
                %this_distance = sum(abs(compare_object-classify_object)./max(abs(classify_object),0.01));
                this_distance = 1 - ami(classify_object,compare_object);
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

