function  test_classification()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    data = sound2vector();
    correct = 0;
    converted_data = data.converted_data;
    size(converted_data,1);
    size(converted_data,2);
    TEST_class_labels = data.actual_class;
    
      
    
    da = dbaux(4);
    for i=1 : length(TEST_class_labels)
       % converted_data(i,:) = filter(da,1,converted_data(i,:));
      t = converted_data(i,:);

      %[D1,D2,D3,D4,D5,A1,A2,A3,A4,A5] = wav_extract(t);
      %D1=abs(D1/norm(D1));
      %D2=abs(D2/norm(D2));
%       D3=abs(D3/norm(D3));
%       D4=abs(D4/norm(D4));
%       D5=abs(D5/norm(D5));
%       A1=std(A1/norm(A1));
%       A2=std(A2/norm(A2));
%       A3=std(A3/norm(A3));
%       A4=std(A4/norm(A4));
%       A5=std(A5/norm(A5)); 
      
      %[ca,cb] = dwt(t,'db12');
      %da = dwt(ca,'db12');
      %ea = dwt(da,'db12');
      %fa = dwt(ea,'db12');
      %[C,L] = wavedec(converted_data(i,:),6,'db12');
      %ea = normc(ea);
        
%       w = 'db12';
%       [ct,L]=wavedec(t,5,w);
%       index = (L(1)+1):length(ct);
%       ct = ct(index);
      f = fft(t);
      %f = rceps(t); 
      f = abs(f); % magnitude 
      %transform_data(i,:) = [A1 A2 A3 A4 A5];
    end
    
    %converted_data = converted_data(1:10,:);
    %TEST_class_labels = data.actual_class(1:10);
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
                this_distance = cosine_distance(classify_object,compare_object);
                
                %this_distance = sum(abs(compare_object-classify_object)); 
                %this_distance = sum(abs(compare_object-classify_object)./max(abs(classify_object),0.01));
                
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

