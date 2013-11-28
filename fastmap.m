function [X,Y] = fastmap(A,color) 
	warning off 
    M=ones(5,3);   
	[hA,lA]=size(A); 
	temp3=1; 
	maxIndex=1;    
	for i=1:5      
		M(i,1)=temp3;      
		M(i,2)= maxD(hA,temp3);     
		M(i,3)=max(sumD);     
		temp3=maxD(hA,temp3);
    end
	
	X=eachDist(hA,M,A); 
	Y=secD(A,hA,X); 
	%C=cat(1,X,Y) 
 	%[hC,lC]=size(C)
    %for s=1:lC 
	%	hold on; 
	%	plot(C(1,s),C(2,s),'.b'); 
	%	hold off; 
    %end 
 	%hold on; 
	%plot(C(1,150),C(2,150),'*r') 
 	%hold off; 
    scatter(X',Y',10,color);
    
	warning on 
    function maxIndex=maxD(hA,maxI) 
        
        for j=1:hA 
            D(j,:)=(A(maxI,1:lA-1)-A(j,1:lA-1)).^2; 
        end 
         
        sumD=sum(D,2); 
        [R,C]=max(sumD); 
        maxIndex=C; 

    end 
    function X=eachDist(hA,M,A) 
        a=M(5,1); 
        b=M(5,2); 
        for j=1:hA 
            Da(j,:)=(A(a,1:lA-1)-A(j,1:lA-1)).^2; 
            sDa=sqrt(sum(Da(j,:))); 
            Db(j,:)=(A(b,1:lA-1)-A(j,1:lA-1)).^2; 
            sDb=sqrt(sum(Db(j,:))); 
            X(j)=(sDa.^2+M(5,3)-sDb.^2)/(2*sqrt(M(5,3)));

		end 

		X=X; 
		 
	end 

	function Y=secD(A,hA,X) 
        e=0; 
        f=0;
        temp4=0;  
        for i=1:hA 
            for j=1:hA
                D2(i,j)=sum((A(i,:)-A(j,:)).^2); 
                X2(i,j)=(X(i)-X(j)).^2; 
                D2sec(i,j)=D2(i,j)-X2(i,j); 
             end 
        end 
        for  i=1:hA  
            for j=1:hA  
                if D2sec(i,j)>temp4 
                    temp4=D2sec(i,j);   
                    e=i; 
                    f=j;
                end 
            end 
        end 

        for j=1:hA 
            Y(j)=(D2sec(e,j).^2+temp4-D2sec(f,j).^2)/(2*sqrt(temp4)); 
        end 
        Y=Y; 

	end 

 
end

