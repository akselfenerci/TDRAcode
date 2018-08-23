function CurveFitHydro_Matrices( settings )

% unpack
wadam_folders = settings.wadam_folders;
wadam_file = settings.wadam_filename;
input_folder = settings.input_folder;

target = settings.target;
target_name = settings.target_name_matrices;


for j = 1:length(wadam_folders)
    
    % Import from WADAM
    [ADD_MASS, ADD_DAMP, HYD_KK1,T,MM0] = WADAM_Import(strcat(input_folder,'\',wadam_folders{j},'\',wadam_file));
    
    % Number of discrete frequencies where transfer functions are defined
    NoF=length(T);

    % loop over the frequencies and write frequency, added mass & damping
    for i = 1:NoF
        Freq1(i)=2*pi/T(NoF+1-i);
        AddMass1(:,:,i)=ADD_MASS(:,:,NoF+1-i);
        Damping1(:,:,i)=ADD_DAMP(:,:,NoF+1-i);
    end
    % save the matrices (mat-file)
    save(strcat(target,'\',target_name,num2str(j-1),'.mat'), 'AddMass1', 'Damping1','Freq1');
end




