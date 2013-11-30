function SVDplot(ts,TEST_class_labels)
%plot using SVD
    C = get_class_color( TEST_class_labels );
    [U,S,V] = svd(ts,'econ');
    
    SS = zeros(2);
    SS(1,1) = S(1,1);
    SS(2,2) = S(2,2);
    P = U(:,1:2)*SS;
    %P = U*S
    X = P(:,1);
    Y = P(:,2);
    scatter(X,Y,10,C);

end

