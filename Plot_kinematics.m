function Plot_kinematics(animal,dataset_path)
%% Plot_kinematics plots the Y position of the hand for different number
% of cycles. By default the function plots the cycling forward starting from the
% bottom of the cycle
%
%% Input:
%
% animal: string containing the animal's name e.g. 'Drake' or 'Cousteau'
%
% dataset_path: folder path where recordings are stored
%
%
% 13/01/2025
% Andrea Colins Rodriguez


figure
i_dir=1;  % forward
i_pos=0;  % from the bottom

% timesmov = array with timesmov(1) time relative to mov onset timesmov(2)
% time relative to mov end

timesmov=[-1000 400];

load([dataset_path '\' animal '_tt.mat'])

if strcmp(animal,'Cousteau')
    P=Pc;
    clear Pc
else
    P=Pd;
    clear Pd
end

Ncycle=P.mask.cycleNum;
Ndistance=P.mask.dist;

% find threshold for speed on distance 0.5 condition
speed=zeros(sum(Ndistance==0.5),4);

for i_ex=1:4
    speed(:,i_ex)=sqrt(P.vA(Ndistance==0.5,i_ex*2-1).^2+P.vA(Ndistance==0.5,i_ex*2).^2);
end

Threshold=mean(speed(1500,:));
Exec_half=double(mean(speed,2)>Threshold);

Exec_half(Exec_half==0)=nan;
Ncycle(Ndistance==0.5)=Exec_half;

distances=unique(Ndistance);
Ndists=numel(distances);
color_dist=plasma(Ndists);

for i=1:Ndists

    idx=find(Ndistance==distances(i) & P.mask.pos==i_pos & P.mask.dir==i_dir);

    % align to movement onset
    mov_onset=find(~isnan(Ncycle(idx)),1,'first');
    tstart=mov_onset+timesmov(1);
    tend=find(~isnan(Ncycle(idx)),1,'last')+timesmov(2);
    Npoints=tend-tstart+1;
    xtime=(1:Npoints)+timesmov(1);

    %% plot Y pos in different subplots
    subplot(Ndists*2,2,2*i)
    
    plot(xtime,P.pA(idx(tstart:tend),2)*6.4,'Color',color_dist(i,:))
    box off 
    xlim([xtime(1) xtime(end)])
    ax=gca;
    ax.Position(3)= ax.Position(3)*Npoints/5000;

end
hold on
xlabel('Time to movement onset [ms]')
end