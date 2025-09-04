function [scores,explained,idx_pos,idx_dir,idx_dist,baseline,mov_FR,idx_Ncycle,exec]=extract_trajectories_all(animal,region,timesmov)
% timesmov = array with timesmov(1) time relative to mov onset timesmov(2)
% time relative to mov end

%load(['.\Data_Russo\' animal '_tt.mat'])
load(['C:\Users\Acer\OneDrive - Universidad Adolfo Ibanez\Office computer\Dynamical_systems_Cortex\Data_Russo\' animal '_tt.mat'])
if strcmp(animal,'Cousteau')
    P=Pc;
    clear Pc
else
    P=Pd;
    clear Pd
end


%% M1 (‘.xA_raw’)
%% SMA (‘.uA_raw’)
%% EMG (‘.zA_raw’)

if strcmp(region,'M1')
    P.xA_raw=P.xA_raw;
elseif strcmp(region,'SMA')
    P.xA_raw=P.uA_raw;
elseif strcmp(region,'EMG')
    P.xA_raw=P.zA_raw;
else
    disp('Region not recorgnised (SMA, M1 or EMG)')
    keyboard
end


Ncycle=P.mask.cycleNum;
Ndistance=P.mask.dist;
condNum=P.mask.condNum;
Ncond=max(condNum);

%%select conditions before doing PCA
%here same direction, same starting positions, different number of cycles
selected_conditions=zeros(Ncond,1);

% find threshold for speed on distance 0.5 condition
speed=zeros(sum(Ndistance==0.5),4);

for i_ex=1:4
    speed(:,i_ex)=sqrt(P.vA(Ndistance==0.5,i_ex*2-1).^2+P.vA(Ndistance==0.5,i_ex*2).^2);
end

Threshold=mean(speed(1500,:));
Exec_half=double(mean(speed,2)>Threshold);
Mov_end=find(diff(Exec_half)==-1);

Exec_half(Exec_half==0)=nan;
Ncycle(Ndistance==0.5)=Exec_half;

for i=1:Ncond
    selected_conditions(i)= any(condNum==i & Ncycle>=1)*i;
end

selected_conditions(selected_conditions<1)=[];
Ncond=numel(selected_conditions);


idx_pos=[];
idx_Ncycle=[];
idx_dir=[];
idx_dist=[];
mov_FR=[];
baseline=[];
exec=[];

for i=1:Ncond
    idx=find(condNum==selected_conditions(i));
    baseline=[baseline;P.xA_raw(idx(1:100),:)];

    mov_onset=find(~isnan(Ncycle(idx)),1,'first');


    tstart=mov_onset+timesmov(1);
    tend=find(~isnan(Ncycle(idx)),1,'last')+timesmov(2);

    idx_Ncycle=[idx_Ncycle;Ncycle(idx(tstart:tend))];
    idx_pos=[idx_pos;P.mask.pos(idx(tstart:tend))*2+1];
    idx_dir=[idx_dir;P.mask.dir(idx(tstart:tend))/2+1.5];
    idx_dist=[idx_dist;Ndistance(idx(tstart:tend))];
    tmp_exec=zeros(tend-tstart+1,1);
    tmp_exec(-timesmov(1):end-timesmov(2))=1;
    exec=[exec;tmp_exec];

    mov_FR=[mov_FR;P.xA_raw(idx(tstart:tend),:)];

end


% exclude neurons with zero FR
selected_neurons=sum(mov_FR)>1e-6;
mov_FR=mov_FR(:,selected_neurons);
baseline=mean(baseline(:,selected_neurons),1);

% soft normalise
norm_factor=range(mov_FR)+5;
mov_FR=mov_FR./norm_factor;


%% pca subspace
[coeffs,scores,~,~,explained]=pca(mov_FR);
baseline=(baseline./norm_factor-mean(mov_FR,1))*coeffs;


%scores=scores-baseline;
%% video for seminar
%idx=find(idx_dir==1 & idx_pos==1 & idx_dist==4);
%play_video(scores(idx,:))

% colour_cycle=plasma(5);
% id_cycles=unique(idx_dist);
% figure
% hold on
% for i_cycle=1:numel(id_cycles)
%     idx=find(idx_dir==1 & idx_pos==1 & idx_dist==id_cycles(i_cycle));
%     plot3(scores(idx,1),scores(idx,2),scores(idx,3),'Color',colour_cycle(i_cycle,:),'LineWidth',2)
%     plot3(scores(idx(1),1),scores(idx(1),2),scores(idx(1),3),'o','MarkerFaceColor',colour_cycle(i_cycle,:),'MarkerEdgeColor',colour_cycle(i_cycle,:))
% 
% 
% end

% 
% plot3([min(scores(:,1)) max(scores(:,1))],[0 0],[0 0],'Color',[0.5 0.5 0.5],'Linewidth',2)
% plot3([0 0],[min(scores(:,2)) max(scores(:,2))],[0 0],'Color',[0.5 0.5 0.5],'Linewidth',2)
% plot3([0 0],[0 0],[min(scores(:,3)) max(scores(:,3))],'Color',[0.5 0.5 0.5],'Linewidth',2)
% 
% text(max(scores(:,1))-0.1,0.5,0.1,'PC 1','FontSize',14,'Color',[0.5 0.5 0.5]*1)
% text(0,min(scores(:,2))-0.2,-0.4,'PC 2','FontSize',14,'Color',[0.5 0.5 0.5]*1)
% text(-0.1,0,max(scores(:,3))+0.1,'PC 3','FontSize',14,'Color',[0.5 0.5 0.5]*1)
% 
% view(40,26)
% axis off

% colour_dir=[0 1 1; 1 0 0];
% figure
% hold on
% for i_dir=1:2
%     idx=find(idx_dir==i_dir & idx_pos==1 & idx_dist==4);
% plot3(scores(idx,4),scores(idx,5),scores(idx,6),'Color',colour_dir(i_dir,:),'LineWidth',2)
% plot3(scores(idx(1),4),scores(idx(1),5),scores(idx(1),6),'o','MarkerFaceColor',colour_dir(i_dir,:),'MarkerEdgeColor',colour_dir(i_dir,:))
% hold on
% plot3(baseline(:,4),baseline(:,5),baseline(:,6),'ok')
% end
%
% xlabel('PC 1')
% ylabel('PC 2')
% zlabel('PC 3')
end