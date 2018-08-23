function settings = CurveFitADs( settings )

% unpack
target = settings.target;
vredp = settings.redv;
ADfile = settings.ADfile;
target_name = settings.target_name;
target_name_AD = settings.target_name_AD;

% Load forced oscillation experimental data
load(ADfile);

% fit rational functions using least squares
[ AD_Rational, RFa, d, aa ] = get_ADs_rational( RedV,ADs, vredp );

% write the matrices for coefficients A --> to fortran file (w/ .for
% extension)

DDD=[{'1'} {'1'} {'B'}; {'1'} {'1'} {'B'};{'B'} {'B'} {'B*B'}];
transMax=[1 1 -1;1 1 -1;-1 -1 1];

% write to a fortran file (includes mapping)
fid = fopen(strcat(target,'\',target_name,'.for'),'w');
fprintf(fid,'         d1=%f\n',d(1));
fprintf(fid,'         d2=%f\n',d(2));
Order=[1 2 4 5];
for k=1:length(Order)
    for i=1:3
        for j=1:3
            fprintf(fid,'         AA%d(%d,%d)=%f*%s*(%d)\n',Order(k),i+1,j+1,RFa(i,j,k),DDD{i,j},transMax(i,j));
        end
    end
end
fclose(fid);

% save the fitted ADs
save(strcat(target,'\',target_name_AD),'AD_Rational','vredp','RFa','d','aa');

% bury results into settings
settings.RFa = RFa;
settings.d = d;
