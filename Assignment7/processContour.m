% This script is written by Prof. Lo. Modified some (with* comment)
% this script loads paraView processed free surface location contour .csv 
% files, and save the results as a .mat file
%close all, 
%clear,

% [CHANGE THESE VALUES] user inputs 
SAVE_NAME=['contour' num2str(meshtype) '.mat']; % file name to save .MAT *
t=linspace(0,10,201); % time instants of saved data *
h0=0.2; % still water depth

% initialization
nt=length(t); % get temporal node numbers
FS=cell(nt,1); % free surface elevation contour line with alpha=0.5
% use cell because num of points in contour line is not always the same

%=== PROCESS ALL CSV FILES ===
for ti=1:nt-1 %
    
    % load CSV file
    FILE_NAME=['datacontour' num2str(meshtype) '/contour0.' num2str(ti) '.csv']; %*
    data = csvread(FILE_NAME,1,0); % skip first line header
    
    % set sizes
    nd=length(data(:,2)); % get number of nodes of contour line
    FS{ti}=zeros(3,nd); % initialize size of FS{ti}
    
    % get data from CSV
    FS{ti}(1,:)=data(:,2); % x coordinate of contour line
    FS{ti}(2,:)=data(:,4); % z coordinate of contour line
    FS{ti}(3,:)=data(:,1); % fluid volume fraction of cell the FS is in 
    [~, sortIdx] = sort(FS{ti}(1,:));
    FS{ti} = FS{ti}(:, sortIdx);

    % display progress
    fprintf('@@@@@ contour processing progress: %d of %d @@@@@\n',ti,nt);
    
    % set z=0 as the still water level
    FS{ti}(2,:)=FS{ti}(2,:)-h0;
    
end
save(SAVE_NAME,'t','FS');
%% [DEMONSTRATION] plotting the contour
%%
%figure(1),
figure
ti_list = linspace(0,200,11)+1;
plot(FS{ti_list(5)}(1,:),FS{ti_list(5)}(2,:),'b.','MarkerSize',3,'DisplayName', sprintf("%f",ti)),
if meshtype ==1; hold on; end
% save results as .MAT

