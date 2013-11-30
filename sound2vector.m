function result = sound2vector()
%read wave file
    filepath = 'wavefiles/';
    TEST_DATA = dir([filepath, '*.wav']);
    
    TEST_class_labels = importdata('classLabel.mat');
    converted_data = zeros(length(TEST_class_labels),15883);
       
    for i=1 : length(TEST_class_labels)
        org_filename = TEST_DATA(i).name;
        converted_data_i = wavread([filepath, org_filename]);
             
        converted_data(i,:) = converted_data_i;
    end
    
    result = struct('converted_data',converted_data,'actual_class',TEST_class_labels(:,2));
end

