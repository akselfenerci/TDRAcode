function CurveFitHydro_FDI( settings )

% unpack
target = settings.target;
target_name = settings.target_name_fits;
matrices_name = settings.target_name_matrices;

% unpack the curve fitting input (FDIopt)
WAMIT_No = settings.WAMIT_No;
Dof = settings.Dof;
FDIopt = settings.FDIopt;

% load
load(strcat(target,'\',matrices_name,num2str(WAMIT_No),'.mat'));

% call idenfication routine
Nf = length(Freq1);
W=Freq1';
Ainf=AddMass1(Dof(1),Dof(2),Nf);

A = squeeze(AddMass1(Dof(1),Dof(2),:));
B = squeeze(Damping1(Dof(1),Dof(2),:));

[KradNum,KradDen,Ainf_hat] = TDRA.Hydro.FDI.FDIRadMod(W,A,Ainf,B,FDIopt,Dof);

% save 
save(strcat(target,'\',target_name,num2str(WAMIT_No),'_Dof',num2str(Dof(1)),num2str(Dof(2)),'.mat'),'KradNum','KradDen','Ainf_hat');

end




