function t = plot_class_fft( timeseries, class_label )
% plot FFTed timeseries that classified into class_label
    class_labels = importdata('classLabel.mat');
    res = zeros(1,1);
    for i=1:size(class_labels(:,1),1)
        if class_label == class_labels(i,2)            
           res = [res, class_labels(i,1)];
        end
    end
    
    figure('Name',['class ' int2str(class_label)]);
    %grid on;
    res(1) = [];
    for i=1:size(res,2)
        if res(1,i) ~= 0
            %res(1,i)
            t = timeseries(res(1,i),:);
            
            t = fft(t);
            %t = rceps(t);
            t = abs(t);
            
            
            subplot(6,2,i);
            %set(h,'position',[0.3    0.1100    0.1347    0.8150]) 

            plot(t(1:round(size(t,2))));

            dist = peak_distance(t(1:round(size(t,2)/2)))
            if i == 12
                break
            end
            
        end
    end   
    
end

