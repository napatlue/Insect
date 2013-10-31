function testInstanceLabel = PartitionHeldOut(classLabel ,numTest, numClass)
%randomly select k equal size partition and use one of them
% to be your testing set. You should output a binary vector testInstanceLabel, indicating which
% instances are used as testing, it should have same length as Xtrain and Ytrain and has n
% k
% elements to be 1, where n is the number of instance
    trainSize = size(classLabel,1);
    %setSize = trainSize/k;
    %numZero = trainSize-setSize;
    %tmp = [ones(setSize,1); zeros(numZero,1)];
    %ran = randperm(size(tmp,1));
    testInstanceLabel = zeros(trainSize,1);
    class = zeros(numClass);
    
    for i=1 : trainSize
        label = classLabel(i);
        
        if class(label) < numTest
            class(label) = class(label) +1;
            testInstanceLabel(i) = 1;
        end
            
    end
    
end

