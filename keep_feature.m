function result = keep_feature(C,L,level)
%keep some of wavelet coefficient
    result = zeros(size(C,1),size(C,2));
    result(:,1:L(1)) = C(:,1:L(1));
    
    currentLevel = 2;
    [Dj,e] = getCoef(C,L, currentLevel, level);
    enPlus = getEn(Dj);
    
    en(currentLevel) = enPlus;
    
    flag = true;
    
    j = 1;
    while j <= level
        currentLevel = j;
        [Dj,start,e] = getCoef(C,L, currentLevel, level);
        enCur = getEn(Dj);
        en(currentLevel) = enCur;

         if enCur > enPlus
            result(:, L(1)+1:start-1) = zeros(size(C,1),start-L(1)-1); 
            flag = false;
            break;
         end
        j = j+1;
    end
    
end

function energy = getEn(D)
    D = D.^2;
    tmp = sum(D,1);
    energy = sum(tmp,2);
end
