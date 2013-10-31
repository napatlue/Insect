function [XTrain,YTrain] = GetXYTrain( Xtrain,Ytrain,testInstanceLabel )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    count = 0;
    for i = 1:size(testInstanceLabel,1)
       if(testInstanceLabel(i) == 0)
           count = count+1;
           XTrain(count,:) = Xtrain(i,:);
           YTrain(count,:) = Ytrain(i,:);
           
           
       end
        
    end

end