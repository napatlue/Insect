function testInstanceLabel = PartitionHeldOut(classLabel ,numTest, numClass)
%Seperate test set and training set
    trainSize = size(classLabel,1);
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

