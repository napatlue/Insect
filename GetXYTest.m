function [XTest,YTest] = GetXYTest( Xtrain,Ytrain,testInstanceLabel )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    count = 0;
    for i = 1:size(testInstanceLabel,1)
       if(testInstanceLabel(i) == 1)
           count = count+1;
           XTest(count,:) = Xtrain(i,:);
           YTest(count,:) = Ytrain(i,:);
           
           
       end
        
    end

end

