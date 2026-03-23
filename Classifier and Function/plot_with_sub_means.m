function plot_with_sub_means(HOA_classifier, new_data, subpop_idx)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
variable_names = {'Pelvic tilt' , 'Pelvic obliquity' , 'Pelvic rotation' , 'Hip flexion angle' , 'Hip abduction angle' , 'Hip rotation angle' , ...
     'Knee flexion angle' , 'Knee abduction angle' , 'Knee rotation angle' , 'Ankle dorsiflexion angle' , 'Foot progression angle'};
variable_namesdyn = {'Hip flexion moment' , 'Hip abduction moment' , 'Hip rotation moment' , ...
     'Knee flexion moment' , 'Knee abduction moment' , 'Knee rotation moment' , 'Ankle dorsiflexion moment'};
complete_names = [variable_names , variable_namesdyn];
axis_labels = {'Anterior(+)/ Posterior(-) Tilt [°]', 'Up(+)/ Down(-) Obliquity [°]' ,'Internal(+)/ External(-) Rotation [°]' ,...
    'Flexion(+)/ Extension(-) [°]', 'Adduction(+)/ Abduction(-) [°]' ,'Internal(+)/ External(-) Rotation [°]',...
    'Flexion(+)/ Extension(-) [°]', 'Adduction(+)/ Abduction(-) [°]' ,'Internal(+)/ External(-) Rotation [°]',...
    'Dorsi-(+)/ Plantar-(-) Flexion [°]', 'Intoeing(+)/ Outtoeing(-) [°]',...
    'Flexion(+)/ Extension(-) moment [Nm/kg]', 'Adduction(+)/ Abduction(-) moment [Nm/kg]' ,'Internal(+)/ External(-) Rotation moment [Nm/kg]',...
    'Flexion(+)/ Extension(-) moment [Nm/kg]', 'Adduction(+)/ Abduction(-) moment [Nm/kg]' ,'Internal(+)/ External(-) Rotation moment [Nm/kg]',...
    'Dorsi-(+)/ Plantar-(-) Flexion moment [Nm/kg]'};
subjects = 1:height(new_data);
figure();
t = tiledlayout(3,6,'TileSpacing','compact','Padding','compact');
mean_pre = HOA_classifier.plotting.(sprintf('means_subpopulation_%d_pre', subpop_idx)).(sprintf('mean_pre_%d', subpop_idx));
std_pre  = HOA_classifier.plotting.(sprintf('stds_subpopulation_%d_pre', subpop_idx)).(sprintf('std_pre_%d', subpop_idx));

mean_post = HOA_classifier.plotting.(sprintf('means_subpopulation_%d_post', subpop_idx)).(sprintf('mean_post_%d', subpop_idx));
std_post  = HOA_classifier.plotting.(sprintf('stds_subpopulation_%d_post', subpop_idx)).(sprintf('std_post_%d', subpop_idx));

mean_healthcomp = HOA_classifier.preprocessing.means.mean_health;
std_healthcomp  = HOA_classifier.preprocessing.stds.std_health;
vars = length(complete_names);

for i = 1:vars

    ax = nexttile;
    hold(ax,'on')

    idx = (i-1)*101 + (1:101);

    % PRE
    data_mean = mean_pre(:, idx);
    data_std  = std_pre(:, idx);

    % POST
    data_post_mean = mean_post(:, idx);
    data_post_std  = std_post(:, idx);

    % HEALTHY
    data_health_mean = mean_healthcomp(:, idx);
    data_health_std  = std_healthcomp(:, idx);

    x = 1:101;

    upper = data_mean + data_std;
    lower = data_mean - data_std;

    upper_post = data_post_mean + data_post_std;
    lower_post = data_post_mean - data_post_std;

    upper_h = data_health_mean + data_health_std;
    lower_h = data_health_mean - data_health_std;

    % HEALTHY
    h1 = fill(ax,[x fliplr(x)],[upper_h fliplr(lower_h)],[0.6 0.8 1],...
        'EdgeColor','none','FaceAlpha',0.4);
    h2 = plot(ax,x,data_health_mean,'b','LineWidth',1.5);

    % PRE
    h3 = fill(ax,[x fliplr(x)],[upper fliplr(lower)],[1 0.6 0.6],...
        'EdgeColor','none','FaceAlpha',0.4);
    h4 = plot(ax,x,data_mean,'Color',[1 0 0],'LineWidth',1.5);

    % POST
    h5 = fill(ax,[x fliplr(x)],[upper_post fliplr(lower_post)],[0.6 1 0.6],...
        'EdgeColor','none','FaceAlpha',0.4);
    h6 = plot(ax,x,data_post_mean,'Color',[0 0.6 0],'LineWidth',1.5);

    % SUBJECTS
    cmap = lines(size(new_data,1));
    h_subject = gobjects(1,size(new_data,1));
    for s = 1:size(new_data,1)
        h_subject(s) = plot(ax,x,new_data(s,idx),'Color',cmap(s,:),'LineWidth',1);
    end

    % Save legend handles only once
    if i == 1
        legend_handles = [h1 h2 h3 h4 h5 h6 h_subject];
    end

    title(complete_names{i},'FontSize',9)
    xlabel('Gait cycle (%)')
    ylabel(axis_labels{i})
    xlim([1 101])
    box on

end

base_labels = ["Healthy SD","Healthy Mean","Pre SD","Pre Mean","Post SD","Post Mean"];
subject_labels = "Subject " + string(subjects);

% Reserve space for legend by shrinking tiledlayout width
legendWidth = 0.18; % tweak if needed
t.Units = 'normalized';
t.Position = [0.05 0.06 0.92-legendWidth 0.90];

% Create an invisible axes in the same figure to host the legend
fig = gcf;
axLeg = axes(fig,'Units','normalized', ...
    'Position',[t.Position(1)+t.Position(3)+0.01, t.Position(2), legendWidth-0.02, t.Position(4)], ...
    'Visible','off');

lgd = legend(axLeg, legend_handles, [base_labels subject_labels], 'Location','northwest');
lgd.Box = 'on';
lgd.Interpreter = 'none';
end