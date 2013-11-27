function result = preProcessWave(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        for i = 1:size(data ,1)
 %         %[C(i,:),L] = wavedec(converted_data(i,:),14,'db4');
         [a1,d1] = dwt(data(i,:),'db16');
         datax(i,:) = a1;
         
      end



    result =zeros(size(datax,1),floor(size(datax,2)/2)-1);
    for i=1:size(datax,1)
        
        %minHeight = max(data(i,:))/3;
        
        
        %[pks,locs] = findpeaks((data(i,:)),'MINPEAKHEIGHT',minHeight, 'NPEAKS',1,'minpeakdistance',3);
        
        %tmp = circshift(data(i,:),[0 -(locs(1)-1500)]);
        tmp = abs(fft(datax(i,:)));
        result(i,:) = tmp(2:floor(end/2)); %ignore f0
        
    end

    
     %     for i = 1:size(converted_data ,1)
 %         %[C(i,:),L] = wavedec(converted_data(i,:),14,'db4');
 %        [a1,d1] = dwt(converted_data(i,:),'db4');
 %        [a2,d2] = dwt(a1,'db4');
 %        [a3,d3] = dwt(a2,'db4');
 %        transform_data(i,:) = [a2,a3];
         
 %     end
    
    
end

