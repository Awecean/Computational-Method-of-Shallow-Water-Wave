% pconvergence.m
% This program aims to analyze the numerical method is convergence with the
% space step decreases.
load("data\pdataflatfull1.mat",'eta')
eta_fine = eta{end};
errorlist = zeros(1,5);
dxlist = zeros(1,5);

for i = 1:5
    load(fullfile(folderPath, sprintf('pdataflatfull%d.mat',i)),'eta','dx','X','Y','nx');
    dxlist(i) = dx;

    eta_fine_temp = eta_fine(1:2^(i-1):end,1:2^(i-1):end);
    eta_target = eta{end};
    error = eta_fine_temp-eta_target;
    l = size(error,1);
    errorsqure = error.^2;
    errorlist(i) = sqrt(1/l/l*sum(errorsqure(:)));
end
%%
figure('Position', [100,100,550,500])
set(gcf, 'Color', 'White')
loglog(dxlist,errorlist','ko-','DisplayName', 'data');
hold on
errorend = errorlist(2)*(20/dxlist(2)).^(3); 

loglog([dxlist(2), 20], [errorlist(2),errorend],'r--', 'DisplayName', 'cubic trend','LineWidth',1.5);
loglog([20,20],[errorlist(2), errorend],'r-','HandleVisibility','off');
loglog([dxlist(2), 20], [errorlist(2), errorlist(2)],'r-','HandleVisibility','off')
text(19,sqrt(errorlist(2)*errorend),'3','color','red','FontSize',12);
text(sqrt(dxlist(2)*20),errorlist(2)*1.1,'1','color','red','FontSize',12);
axis([1.5,24,1e-4,3e-1])
grid on
xlabel(sprintf('\\Delta x, \\Delta y (m)'),'FontSize',12)
ylabel(sprintf('global error (m)'),'FontSize',12)
legend(location ='northwest',FontSize=12)
exportgraphics(gcf, "figure\Fig31a_convergencetest.pdf", 'ContentType', 'vector');
