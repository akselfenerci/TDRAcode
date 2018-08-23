function [aa,d,RFa,Covaa,d0,lb,ub,vred,x0]=LeastSquaresFitAerodynamicDerivatives(vred,AD,d0,varargin)
%% Description
% This routine curve fit rational functions to the esperimental data of the
% aerodynamic derivatives. The curv fit is done in two steps. First the a
% coefficients are determined for a given set of d coefficients using
% linear least squares. Then nonlinear least squares is performed to fine
% better estimates of the d coefficients. The procedure is repeated until
% convergence

% 28.10.2013  Ole Andre Øiseth

%% Define parameters
p=inputParser;
addParameter(p,'ub_d',10,@isnumeric);                     %Upper boud for the d cefficients
addParameter(p,'lb_d',0.1,@isnumeric);                    %Lower boud for the d cefficients
addParameter(p,'PlotIterations','No',@ischar);            %Plot the curve fits during iterations
parse(p,varargin{:})
PlotOpt=p.Results.PlotIterations;
if strcmp(PlotOpt,'Yes'); plotAerodynamicDerivatives(vred,AD,'DataType','ExperimentalData'); end % Plot experimental data if selected
%% Perform nonlinear least squares
%% First find optimal d values
%Introduce bounds
tmp=[p.Results.lb_d d0 p.Results.ub_d];
for n=1:length(d0)
    ub(1,n)=d0(1,n)+0.75*0.5*(tmp(1,n+2)-tmp(1,n+1));
    lb(1,n)=d0(1,n)-0.75*0.5*(tmp(1,n+1)-tmp(1,n));
end
% Perform nonlinear fit considering only d
[d, ~,~,~,~,~,JJ] = lsqnonlin(@myfun,d0,lb,ub,[],vred,AD,PlotOpt);  %Nonlinear least squares to optimize d parameters
[~, aa, ~,~]=myfun(d,vred,AD,PlotOpt); % Calculate resulting aa values after optimization
%% Fully nonlinear least squares fit considering all parameters
x0=[aa' d];
p.Results.lb_d*ones(size(d));
p.Results.ub_d*ones(size(d));
ub=[Inf*ones(size(aa')), ub];
lb=[-Inf*ones(size(aa')), lb];
[x, ~,~,~,~,~,JJ] = lsqnonlin(@myfun2,x0,lb,ub,[],vred,AD,length(d));
d=x(length(x0)-length(d0)+1:end);
aa=x(1:length(x0)-length(d0))';
[~, ~, ~, Covaa]=myfun(d,vred,AD,PlotOpt); % Calculate resulting d values after optimization

Ncoeff=2+length(d);              % Number of coefficient used for each component
RFa=zeros(3,3,Ncoeff);
cont=0;
for n=1:3
    for m=1:3
        cont=cont+1;
        RFa(n,m,:)=aa(Ncoeff*(cont-1)+1:Ncoeff*(cont),1);
    end
end
return

save leastSquares_result.mat d0 lb ub vred d x0 

function [F, aa, CC,Covaa]=myfun(d0,vred,AD,PlotOpt)
%% Description
% This function calculates the total sum of squares for aerodynamic
% derivatives. This is used to fin common d parameters for all AD's
%% Linear Curve fit to the experimental results
d=d0;
posAD=[1 5 2   11 7 8  17 13 14;   4 6 3    12 10 9   18 16 15];
[CC]=CmatrixRationalFunctionsWindLoad(vred,d);
DD=[];
for n=1:9
    DD=[DD; AD(posAD(2,n),:)'; AD(posAD(1,n),:)'] ;
end
% aa=CC\DD;
[aa,~,~,Covaa]=mvregress(CC,DD);
F=(CC*aa-DD);

%% Calulcate and plot the current curve fit
if strcmp(PlotOpt,'Yes')    
    vredp=linspace(0,6,20);
    ADp=zeros(18,length(vredp));
    
    [Cp]=CmatrixRationalFunctionsWindLoad(vredp,d);
    tmp=Cp*aa;
    tmp=vec2mat(tmp,length(vredp));
    ADp(posAD(2,:),:)=tmp(1:2:18,:);
    ADp(posAD(1,:),:)=tmp(2:2:18,:);
    
    plotAerodynamicDerivatives(vredp,ADp)
end
return

save myfun1.mat d0 lb ub vred d x0 

function [F, aa, CC]=myfun2(x0,vred,AD,Nexp)
%% Description
% This function calculates the total sum of squares for aerodynamic
% derivatives. This is used to fin common d parameters for all AD's
%% Linear Curve fit to the experimental results
d=x0(length(x0)-Nexp+1:end);
aa=x0(1:length(x0)-Nexp)';
posAD=[1 5 2   11 7 8  17 13 14;   4 6 3    12 10 9   18 16 15];
[CC]=CmatrixRationalFunctionsWindLoad(vred,d);
DD=[];
for n=1:9
    DD=[DD; AD(posAD(2,n),:)'; AD(posAD(1,n),:)'] ;
end
F=(CC*aa-DD);
size(F);