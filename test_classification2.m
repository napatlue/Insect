function  test_classification2()
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
    
    converted_data = preProcessWave(converted_data);
    
    %transform_data = extract_wavelet_coeff(converted_data,12,'db4');
%      for i = 1:size(converted_data ,1)
%          %[C(i,:),L] = wavedec(converted_data(i,:),14,'db4');
%         [a1,d1] = dwt(converted_data(i,:),'db12');
%         [a2,d2] = dwt(a1,'db12');
%         [a3,d3] = dwt(a2,'db12');
%         transform_data(i,:) = [a1,a2];
%          
%      end
    
%     for j=1:size(converted_data,1)
%         
%         [coefs,longs] = wavedec(converted_data(j,:),12,'db4');
% 
%         tmp = abs(coefs);
% 
%         r =zeros(1,100);
% 
%         for i = 1:100
%            [value, ind] = max(tmp);
%            r(i) = ind;
%            tmp(ind) = -inf;
%         end
% 
%         for i = 1:size(coefs,2)
%             if ~any(r==i)
%                 coefs(i) = 0;
%             end
% 
%         end
%         tmp = waverec(coefs,longs,'db4');
%         transform_data(j,:) = abs(fft(tmp));
%     end
    transform_data=zeros(1100,1);
     for i = 1:size(converted_data ,1)
        [ pks,locs,dist12,dist23] = getpeaks(converted_data(i,:));
        %transform_data(i,1) = dist12;
        
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
     
     D = pdist(transform_data,'cityblock');
     Dm = squareform(D);
     
     [Y,eigvals] = cmdscale(D);
     C = get_class_color( TEST_class_labels );
     scatter(Y(:,1),Y(:,2),10,C);
     
     
    %transform_data = abs(transform_data);
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
                
                %this_distance = cityblock_distance(classify_object,compare_object);
                this_distance = Dm(i,j);
                %this_distance = sum(abs(compare_object-classify_object)); 
                %this_distance = sum(abs(compare_object-classify_object)./max(abs(classify_object),0.01));
                %this_distance = 1 - ami(classify_object,compare_object);
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

