function [CC]=CmatrixRationalFunctionsWindLoad(vred,d)
if size(vred,1)==1
    vred=ones(18,1)*vred;
end
posAD=[1 5 2   11 7 8  17 13 14;   4 6 3    12 10 9   18 16 15];
CC=cell(9,9);
for n=1:9
    for m=1:9
        CC{n,m}=zeros(2*size(vred,2),length(d)+2);
    end
end
for n=1:9
    for k=1:size(vred,2)
        %Real part
        C(k,1)=vred(posAD(2,n),k)^2;
        for e=1:length(d)
            C(k,2+e)=vred(posAD(2,n),k)^2/((d(1,e)*vred(posAD(2,n),k))^2+1);
        end
        %Imaginary part
        C(k+size(vred,2),2)=vred(posAD(1,n),k);
        for e=1:length(d)
            C(k+size(vred,2),2+e)=d(1,e)*vred(posAD(1,n),k)^3/((d(1,e)*vred(posAD(1,n),k))^2+1);
        end
    end
    CC{n,n}=C;
end
CC=cell2mat(CC);
return