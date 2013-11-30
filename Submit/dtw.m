function Dist=dtw(t,r)

% count = 1;
% eps = 0.0000001;
% while abs(t(count)-0) < eps
%         count = count+1;
% end
% 
% tail = size(t,2);
% %tail
% while abs(t(tail) - 0) < eps
%         tail = tail-1;
% end
% %count
% %tail
% t = t(count:tail);
% %size(t,2)
% count = 1;
% while abs(r(count) - 0) < eps
%         count = count+1;
% end
% 
% tail = size(r,2);
% 
% while abs(r(tail) - 0) < eps
%         tail = tail-1;
% end
% 
% %count
% %tail
% r = r(count:tail);

     fileID = fopen('s1.txt','w');
     fprintf(fileID,'%f\t',t);
     fclose(fileID);
     fileID = fopen('s2.txt','w');
     fprintf(fileID,'%f\t',r);
     fclose(fileID);
     if size(t,2) > size(r,2)
          command = ['./UCR_DTW s1.txt s2.txt ',int2str(size(r,2)),' 0.05'];
     else
          command = ['./UCR_DTW s2.txt s1.txt ',int2str(size(t,2)),' 0.05'];
     end
%    % [status,out] =system('./UCR_DTW s1.txt s2.txt 15883 0.2');
%     command
    [status,out] =system(command);
    Dist = str2double(out);
%Dist = cdtw_dist(t, r, inf);
end