function [ADD_MASS, ADD_DAMP, HYD_KK,T,MM0]=WADAM_Import(str)
%%
fr = fopen(str);             %Fila som skal kopieres

start_m=10000;
stop_m=10000;
start_d=10000;
stop_d=10000;
start_K=0;
stop_K=0;
start_M0=100000;
stop_M0=1000000;
perpos=0;
P_RO=10000;
P_VOL=10000;
P_L=10000; 
P_G=10000;
teller1=0;
LNr=0;
while(1)
    LNr=LNr+1;
     tline = fgetl(fr);    
     if ~ischar(tline), break, end
     
     if isempty(strfind(tline,'MASS INERTIA COEFFICIENT MATRIX'))
     else
         teller5=0;
         start_M0=LNr+4;
         stop_M0=LNr+9;
         
     end
     
     if isempty(strfind(tline,'HYDROSTATIC RESTORING COEFFICIENT MATRIX'))
     else
         teller4=0;
         start_K=LNr+4;
         stop_K=LNr+9;
         
     end

     if isempty(strfind(tline,'ADDED MASS MATRIX'))
     else
         if size(tline,2)==131
             teller2=0;
             teller3=0;
             teller1=teller1+1;
             perpos=LNr+15;
             start_m=LNr+4;
             stop_m=LNr+9;
             start_d=LNr+25;
             stop_d=LNr+30;
         end         
     end
     
     if isempty(strfind(tline,'NON-DIMENSIONAL DEFINITIONS'))
     else
         P_RO=LNr+41;
         P_G=LNr+42;
         P_VOL=LNr+43;
         P_L=LNr+44;                
     end
     if LNr==P_RO;
         RO=str2num(tline(1,11:length(tline)));
     end
     if LNr==P_G;
         G=str2num(tline(1,11:length(tline)));
     end
     if LNr==P_VOL;
         VOL=str2num(tline(1,11:length(tline)));
     end
     if LNr==P_L;
         L=str2num(tline(1,11:length(tline)));
     end
         
     
     if LNr>= start_m && LNr<= stop_m
         teller2=teller2+1;         
         MM(teller2,:,teller1)=str2num(tline);
     end
     
     if LNr>= start_d && LNr<= stop_d  
         teller3=teller3+1;
         CC(teller3,:,teller1)=str2num(tline);
     end
     
     if LNr>= start_K && LNr<= stop_K  
         teller4=teller4+1;
         KK(teller4,:)=str2num(tline);
     end
     
     if LNr>= start_M0 && LNr<= stop_M0  
         teller5=teller5+1;
         MM0(teller5,:)=str2num(tline);
     end
     
     if LNr==perpos
         T(1,teller1)=str2num(tline(1,22:length(tline)));
     end     
end

fclose(fr);

MM02(1:3,1:3,:)=MM0(1:3,2:4,:)*RO*VOL;
MM02(1:3,4:6,:)=MM0(1:3,5:7,:)*RO*VOL*L;
MM02(4:6,1:3,:)=MM0(4:6,2:4,:)*RO*VOL*L;
MM02(4:6,4:6,:)=MM0(4:6,5:7,:)*RO*VOL*L^2;
MM0=MM02;

ADD_MASS(1:3,1:3,:)=MM(1:3,2:4,:)*RO*VOL;
ADD_MASS(1:3,4:6,:)=MM(1:3,5:7,:)*RO*VOL*L;
ADD_MASS(4:6,1:3,:)=MM(4:6,2:4,:)*RO*VOL*L;
ADD_MASS(4:6,4:6,:)=MM(4:6,5:7,:)*RO*VOL*L^2;

ADD_DAMP(1:3,1:3,:)=CC(1:3,2:4,:)*RO*VOL*sqrt(G/L);
ADD_DAMP(1:3,4:6,:)=CC(1:3,5:7,:)*RO*VOL*sqrt(G*L);
ADD_DAMP(4:6,1:3,:)=CC(4:6,2:4,:)*RO*VOL*sqrt(G*L);
ADD_DAMP(4:6,4:6,:)=CC(4:6,5:7,:)*RO*VOL*L*sqrt(G*L);

HYD_KK(1:3,1:3,:)=KK(1:3,2:4,:)*RO*VOL*G/L;
HYD_KK(1:3,4:6,:)=KK(1:3,5:7,:)*RO*VOL*G;
HYD_KK(4:6,1:3,:)=KK(4:6,2:4,:)*RO*VOL*G;
HYD_KK(4:6,4:6,:)=KK(4:6,5:7,:)*RO*VOL*G*L;

