function [ AD_Rational,RFa,d,aa ] = get_ADs_rational( RedV,ADs,vredp )

d=[0.1 1];
[aa,d,RFa]=LeastSquaresFitAerodynamicDerivatives(RedV,ADs,d, 'PlotIterations','No');
posAD=[1 5 2   11 7 8  17 13 14;   4 6 3    12 10 9   18 16 15];
[Cp]=CmatrixRationalFunctionsWindLoad(vredp,d);
tmp=Cp*aa;
tmp=vec2mat(tmp,length(vredp));
AD_Rational(posAD(2,:),:)=tmp(1:2:18,:);
AD_Rational(posAD(1,:),:)=tmp(2:2:18,:);

end

