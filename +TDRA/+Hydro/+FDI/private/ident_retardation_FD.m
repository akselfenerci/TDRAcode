function [KsNum,KsDen]=ident_retardation_FD(W,Kw,order,MethOpt,PlotOpt)
%Script for the indentification of a parametric
%radiation convolution model. The non parametric
%data Kw(jw) is used to estimate the parameters of a parametric model
%K(s) = P(s)/Q(s), and the parameters of P(s) and Q(s) are estimated
%from a LS problem:
%
%Theta_opt = argmin Sum_i |Kw(jwi)-P(Theta,jwi)/Q(Theta,jwi)|^2
%
% Use: [KsNum,KsDen]=ident_retardation_FD(W,Kw,order,MethOpt,PlotOpt)
%
% Output:
% KsNum,KsDen - the indetified transfer function numerator and denominator
%                 polynomials.
%
% Inputs:
% W,Kw - are the vectors of frequencuies and the complex 
%        frequency response Kw(jw) = (B(w)-Binf)+jw*[A(w)-Ainf].
% order -order of the parametric model to identify.
% MethOpt - [method,iter] method options for LS freq dom regression: 
%           1-quasilinar, 2-iterative quasilinear
%           3 - nonlinear iterative. (see fit_siso_fresp.m)
% PlotOpt - Ploting options for the indetified model freq response
%           PlotOpt= [PlotFlag,LogScale,wsFactor,wminFactor,wmaxFactor]
%           PlotFlag = 1-plot/0-no plot.
%           LogScale = 1-logaritmic/0-linear.
%           wsFactor = sampling freq as a factor of W(2)-W(1);
%           wminFactor = min freq as a factor of W(1);
%           wmaxFactor = max freq as a factor of W(N);
%
%           Example: PlotOpt=[1,1,0.1,0.5,2], plots in logaritmic scale
%           the sampling freq to compute the frequency response is 
%           ws=0.1*(W(2)-W(1)); wmin = 0.5*W(1), and wmax=2*W(N).
%
%Author: Tristan Perez
%Created: 2007-8-6
%Revised:
%
% Copyright (C) 2007 Thor I. Fossen and Tristan Perez
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
% 
% E-mail: contact@marinecontrol.org
% URL:    <http://www.marinecontrol.org>



%Identification settings:
method     = MethOpt(1);
iter       = MethOpt(2);
PlotFlag   = PlotOpt(1);
LogScale   = PlotOpt(2);
wsFactor   = PlotOpt(3);
wminFactor = PlotOpt(4);
wmaxFactor = PlotOpt(5);
 
%Prepare the data for identification
Scale=max(abs(Kw));
Kws = Kw/Scale;
Fresp= Kws./complex(0,W); %remove the zero at s=0 from the data

%Frequency response fitting
ord_den = order;
ord_num = order-2;
[Num,Den,Fresp_hat,stable]=fit_siso_fresp(W,Fresp,[],ord_num,ord_den,method,iter);

%Rescale and incorporate the zero
Num=Scale*[Num 0];
%Plot
if PlotFlag
    ws=wsFactor*(W(2)-W(1));
    wmax=W(length(W));
    Wext =[wminFactor*W(1):ws:wmaxFactor*wmax];
    Kw_hat=freqs(Num,Den,Wext);
    %  
    %log-scale
    figure
    if LogScale,
        subplot(211)
        semilogx(W,20*log10(abs(Kw)),'o',Wext,20*log10(abs(Kw_hat)),'LineWidth',1.5)
        grid on
        legend('Data',['Estimate, order = ',num2str(order)])
        xlabel('W [rad/s]')
        ylabel('|H(jw)| [dB]')
        title('Frequency response Identification')
        %
        subplot(212)
        semilogx(W,(180/pi)*angle(Kw),'o',Wext,(180/pi)*angle(Kw_hat),'LineWidth',1.5)
        grid on
        legend('Data','Estimate')
        xlabel('W [rad/s]')
        ylabel('Ang(H(jw)) [deg]')
    else
        subplot(211)
        plot(W,abs(Kw),'o',Wext,abs(Kw_hat),'LineWidth',1.5)
        grid on
        legend('Data',['Estimate, order = ',num2str(order)])
        xlabel('W [rad/s]')
        ylabel('|H(jw)|')
        title('Frequency response Identification')
        %
        subplot(212)
        plot(W,(180/pi)*angle(Kw),'o',Wext,(180/pi)*angle(Kw_hat),'LineWidth',1.5)
        grid on
        legend('Data','Estimate')
        xlabel('W [rad/s]')
        ylabel('Ang(H(jw)) [deg]')
    end
end
KsNum=Num;
KsDen=Den;