function create_all_output_files

animal={'Cousteau','Drake'}; 
region_name={'SMA','M1','EMG'};

timesmov=[-1000 400]; %Ames used 1250:3250 => cycles 2 to 5
ndims=10;

for i_animal=1:numel(animal)
    for i_region=1:numel(region_name)
    [scores,explained,idx_pos,idx_dir,idx_dist,baseline,FR,idx_Ncycle,exec]=extract_trajectories_all(animal{i_animal},region_name{i_region},timesmov);
    scores=scores-baseline;
    scores=scores(:,1:ndims);

    %% sanity check
    
    this_cond=idx_dir==1 & idx_pos==1 & idx_dist==4;
    this_cond2=idx_dir==1 & idx_pos==1 & idx_dist==0.5;

    figure
    plot3(scores(this_cond,1),scores(this_cond,2),scores(this_cond,3),'k')
    hold on
    plot3(scores(this_cond2,1),scores(this_cond2,2),scores(this_cond2,3),'r')
    title(region_name{i_region})
    

    %% save into a file
    save(['.\Output_files\scores_' animal{i_animal} '_' region_name{i_region} '.mat'],'scores','explained', 'idx_dir','idx_Ncycle','idx_pos','idx_dist','FR','exec')

    end
end
end