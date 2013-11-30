function [XTest,YTest] = GetXYTest( Xtrain,Ytrain,testInstanceLabel )
%Get test set
    count = 0;
    for i = 1:size(testInstanceLabel,1)
       if(testInstanceLabel(i) == 1)
           count = count+1;
           XTest(count,:) = Xtrain(i,:);
           YTest(count,:) = Ytrain(i,:);
           
           
       end
        
    end

end

