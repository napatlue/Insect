function MDSplot( Dcs, TEST_class_labels)
%plot using MDS
      [Y,eigvals] = cmdscale(Dcs);
      C = get_class_color( TEST_class_labels );
      scatter(Y(:,1),Y(:,2),10,C);

end

