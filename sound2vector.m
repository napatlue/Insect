function result = sound2vector()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    filepath = 'wavefiles/';
    TEST_DATA = dir([filepath, '*.wav']);
    
    TEST_class_labels = importdata('classLabel.mat');
    converted_data = zeros(length(TEST_class_labels),15883);
   
    
    for i=1 : length(TEST_class_labels)
        org_filename = TEST_DATA(i).name;
        converted_data_i = wavread([filepath, org_filename]);
             
        converted_data(i,:) = converted_data_i;
    end
    
    %converted_data=converted_data(:,5000:10000);
    %tmp = sum(converted_data,1);
    
%     for i=1:length(tmp)
%       if tmp(i) ~= 0
%         disp(i);
%         break;
%       end
%     end
    %disp(converted_data(i,:));
    %test write file

    
    result = struct('converted_data',converted_data,'actual_class',TEST_class_labels(:,2));
end

