function PlotADs( settings )

% unpack
target = settings.target;
ADfile = settings.ADfile;
fitted_AD = settings.target_name_AD;

% Load forced oscillation experimental data
load(ADfile);

% Load fitted ADs
load(strcat(target,'\',fitted_AD));

% position of ADs & Labels
posAD = settings.plot.posAD; 
label = settings.plot.label;

% create folder to save figures
mkdir(strcat(target,'\ADplots'));

cc = 1;
for i = 1:size(posAD,1)
    for j = 1:size(posAD,2)
        fig = figure; 
        hh = plot(RedV(posAD(i,j),:),ADs(posAD(i,j),:),'ro');
        hh.MarkerFaceColor = 'r';
        hold on; grid on;
        plot(vredp,AD_Rational(posAD(i,j),:),'b-','LineWidth',2);
        
        fig.Position = [3053 578 311 253];
        ax = gca;
        ax.FontSize = 14; 
        ax.FontName = 'Times';
        ax.YLabel.String = label{cc};
        ax.XLabel.String = 'U/B\omega';
        
        saveas(fig,strcat(target,'\ADplots\',label{cc}(1:3)));
        saveas(fig,strcat(target,'\ADplots\',label{cc}(1:3),'.emf'));
        close(fig);
        
        cc = cc+1;
    end
end
