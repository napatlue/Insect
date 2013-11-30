function [XTrain,YTrain] = GetXYTrain( Xtrain,Ytrain,testInstanceLabel )
%get train set
    count = 0;
    for i = 1:size(testInstanceLabel,1)
       if(testInstanceLabel(i) == 0)
           count = count+1;
           XTrain(count,:) = Xtrain(i,:);
           YTrain(count,:) = Ytrain(i,:);
           
           
       end
        
    end

end