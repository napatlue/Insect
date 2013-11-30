function recons = extract_wavelet_coeff(time_series,level,name)
%Function to reconstruct time series after extract wavelet coefficient
    recons =zeros(size(time_series,1),size(time_series,2));    

    for i = 1:size(time_series,1)
        [C(i,:),L] = wavedec(time_series(i,:),level,name);
    end
    
    coef = keep_feature(C,L,level);
    
    for i = 1:size(time_series,1)
        recons(i,:) = waverec(coef(i,:),L,name);
    end

end
