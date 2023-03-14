clear all 
clc
G_1=readtable('bottom_mine_detailed.csv'); %Read the csv file of the detailed 3D geometry of the upper mine
WF=readtable('WF_bottom_mine_detailed.csv'); %Read the csv file of the work fronts coordinates of the upper mine 
nodes=readtable("nodes_2d_bottom_mine_detailed.csv"); %Read the csv file of the 2d projection (x,y) of the nodes of the upper mine

G_1=G_1{:,:}; % (x,y,z) coordinates matrix of the detailed geometry of the upper mine
WF=WF{:,:}; % (x,y,z) coordinates matrix of the work fronts of the upper mine
nodes=nodes{:,:}; % (x,y) coordinates matrix of the nodes of the upper mine

x_node=nodes(:,2); %x-component vector of the nodes matrix 
y_node=nodes(:,3); %y-component vector of the nodes matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S{1}=G_1(1:3,:);
S{2}=G_1(4:6,:);
S{3}=G_1(7:9,:);
S{4}=G_1(10:11,:);
S{5}=G_1(12:16,:);
S{6}=G_1(18:18,:);
S{7}=G_1(19:20,:);
S{8}=G_1(21:22,:);
S{9}=G_1(23:24,:);
S{10}=G_1(25:28,:);
S{11}=G_1(29:30,:);
S{12}=G_1(31:32,:);
S{13}=G_1(33:34,:);
S{14}=G_1(35:37,:);
S{15}=G_1(38:41,:);
S{16}=G_1(42:43,:);
S{17}=G_1(44:46,:);
S{18}=G_1(47:48,:);
S{19}=G_1(49:50,:);
S{20}=G_1(51:54,:);
S{21}=G_1(55:59,:);
S{22}=G_1(60:61,:);
S{23}=G_1(62:64,:);
S{24}=G_1(65:67,:);
S{25}=G_1(68:69,:);
S{26}=G_1(70:71,:);
S{27}=G_1(72:75,:);
S{28}=G_1(76:79,:);
S{29}=G_1(80:81,:);
S{30}=G_1(82:84,:);
S{31}=G_1(85:88,:);
S{32}=G_1(89:91,:);
S{33}=G_1(92:94,:);
S{34}=G_1(95:96,:);
S{35}=G_1(97:98,:);
S{36}=G_1(99:102,:);
S{37}=G_1(103:106,:);
S{38}=G_1(107:109,:);
S{39}=G_1(110:112,:);
S{40}=G_1(113:115,:);
S{41}=G_1(116:117,:);
S{42}=G_1(118:120,:);
S{43}=G_1(121:122,:);
S{44}=G_1(123:124,:);
S{45}=G_1(126:127,:);
S{46}=G_1(128:129,:);
S{47}=G_1(130:132,:);

data = dir('Revision\*.xlsx');
numdata = length(data);

for i_1=1:numdata
    baseFileName = data(i_1).name;
    fullFileName = fullfile(data(i_1).folder, baseFileName);
    mydata{i_1} = readtable(fullFileName);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=[1 2 3 4 5 6 7 8 9 2 11 12 13 14 15 16 17 18 19 11 21 22 23 24 25 26 5 7 8 12 14 15 16 17 18 21 22 23 32 24 33 34 25 36 26 32 34];
t=[2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 3 4 6 7 9 31 13 15 32 16 33 34 17 36 19 36 33 35];

G=graph(n,t);

WF_2D=WF(:,(1:2));  

for i=1:1:size(WF_2D,1)
    temp_wf(i)=WF_2D(i);
    for j=1:1:size(nodes,1)
        if temp_wf(i)==nodes(j,2)
            A(i,j)=j;
        else
            A(i,j)=0;
        end
    end
end
A=A';
A(A==0)=[];

for k=1:1:size(A,2)
   paths{k}=allpaths(G,1,A(k),'MaxPathLength',11);
end

plot(G,'XData',x_node','YData',y_node')

Mydata_2={mydata{:,:};S{:,:}};

for ii=1:1:size(paths,2)
    for jj=1:1:size(paths{1,ii},1)
        temp_paths=paths{1,ii}{jj,1};
        for e=1:1:size(temp_paths,2)
            s=find(nodes(:,1)==temp_paths(e));
            paths{1,ii}{jj,1}(2,e)=nodes(s,2);
            paths{1,ii}{jj,1}(3,e)=nodes(s,3);
            paths{1,ii}{jj,1}(4,e)=nodes(s,4);
        end
      
        for e_2=1:1:(size(temp_paths,2)-1)
            paths_2{1,ii}{jj,1}{1,e_2}=(paths{1,ii}{jj,1}(2:end,e_2:e_2+1))';
            
            for e_3=1:1:size(S,2)
                tf_1=isequal(paths_2{1,ii}{jj,1}{1,e_2}(1,:),S{1,e_3}(1,1:3)) && isequal(paths_2{1,ii}{jj,1}{1,e_2}(end,:),S{1,e_3}(end,1:3));
                tf_2=isequal(paths_2{1,ii}{jj,1}{1,e_2}(1,:),S{1,e_3}(end,1:3)) && isequal(paths_2{1,ii}{jj,1}{1,e_2}(end,:),S{1,e_3}(1,1:3));

                if tf_1==1
                    T_temp=S{1,e_3};
                    Data_temp=Mydata_2{1,e_3};
                elseif tf_2==1
                    T_temp=flipud(S{1,e_3});
                    Data_temp=flipud(Mydata_2{1,e_3});
                elseif tf_1==0
                    T_temp=[];
                    Data_temp=[];
                elseif tf_2==0
                    T_temp=[];
                    Data_temp=[];
                end

                if e_2==1 && e_3==1
                    T=T_temp;
                    Data=Data_temp;
                else
                    T=[T;T_temp];
                    Data=[Data;Data_temp];
                end
                M{1,ii}{jj,1}=T;
                F{1,ii}{jj,1}=Data;
            end
            
            F_temp=table2array(F{1,ii}{jj,1});
            Delta_traj=sum(M{1,ii}{jj,1}(:,4))/size(F_temp,1);
            
            Delta_vel=1.25+0.3.*randn(size(F_temp,1),1); %normal distribution of walk velocity in m/s
            Delta_time=Delta_traj./Delta_vel; %Delta time 
            
            F_temp(:,5)=cumsum(Delta_time); %cummulative time of trajectory in s
            
            X{1,ii}{jj,1} = F_temp(:,4:5);
            
        end
    end
end

% 
% for r=1:1:size(paths,2)
%     for p=1:1:size(paths{1,r},1)
%         tamano{1,r}{p,1}=size(X{1,r}{p,1},1);
%         count{1,r}=max(cell2mat(tamano{1,r}));
%         standardsize=max(cell2mat(count));
%     end
% end
% 

figure 
for r=1:1:size(paths,2)
    subplot(2,1,2)
    hold on
    for p=1:1:size(paths{1,r},1)
        xrow=X{1,r}{p,1}(:,2);
        yrow=X{1,r}{p,1}(:,1);
        plot(xrow,yrow,'.');
        set(gca,"FontSize",12)
        xlabel('Time (s)','FontSize',14)
        ylabel('Methane Fraction (%)','FontSize',14)
        axis([0 180 0 0.16])
        box on
    end
    hold off

    subplot(2,1,1)
    hold on
    xvector=X{1,3}{7,1}(:,2);
    yvector=X{1,3}{7,1}(:,1);
    plot(xvector,yvector,'r.'); %Path A
    
    xvector2=X{1,3}{1,1}(:,2);
    yvector2=X{1,3}{1,1}(:,1);
    plot(xvector2,yvector2,'.','Color',[0.4940 0.1840 0.5560]); %Path B

    xvector3=X{1,7}{3,1}(:,2);
    yvector3=X{1,7}{3,1}(:,1);
    plot(xvector3,yvector3,'g.'); %Path C

    xvector4=X{1,7}{12,1}(:,2);
    yvector4=X{1,7}{12,1}(:,1);
    plot(xvector4,yvector4,'m.'); %Path C
    
    xvector5=X{1,1}{2,1}(:,2);
    yvector5=X{1,1}{2,1}(:,1);
    plot(xvector5,yvector5,'b.'); %Path D

    xvector6=X{1,4}{1,1}(:,2);
    yvector6=X{1,4}{1,1}(:,1);
    plot(xvector6,yvector6,'k.'); %Path F


    %xlabel('Time (s)','FontSize',14)
    set(gca,"FontSize",12,'XTick',[])
    ylabel('Methane Fraction (%)','FontSize',14)
    legend('Path A','Path B','Path C','Path D','Path E','Path F')
    axis([0 180 0 0.16])
    box on
    hold off

end


% 
% for r=1:1:size(paths,2)
%     for p=1:1:size(paths{1,r},1)
%         delta_increase=(4-X{1,r}{p,1}(end,2))/(standardsize-size(X{1,r}{p,1},1));
%         for k=size(X{1,r}{p,1})+1:1:standardsize
%             X{1,r}{p,1}(k,1)=X{1,r}{p,1}(k-1,1);
%             X{1,r}{p,1}(k,2)=X{1,r}{p,1}(k-1,2)+delta_increase;
%         end
%         X_2{1,r}{p,1}=flipud(X{1,r}{p,1});
%         X_2{1,r}{p,1 }(:,2)=8-X_2{1,r}{p,1}(:,2);
% 
%         X{1,r}{p,1}=[X{1,r}{p,1};X_2{1,r}{p,1}];
%         X{1,r}{p,1}(:,1)=X{1,r}{p,1}(:,1)*100;
% %         formatSpec = "Trajectory_%d_to_wf_%d"
% %         filename = sprintf(formatSpec,p,r);
% %         writematrix(X{1,r}{p,1},'trajectories_bottom_mine_detailed\'+filename); 
%     end
% end
% 
% for ii=1:1:size(paths,2)
%     for jj=1:1:size(paths{1,ii},1)
%         for kk=1:1:size(X{1,ii}{jj,1},1)/2
%             XX{1,ii}{jj,1}(kk,:)=X{1,ii}{jj,1}(kk*2-1,:);
%         end
%     end
% end
% 
% % vrow=(XX{1,3}{1,1}(1:800,2))';
% % vcol=(XX{1,3}{1,1}(1:800,1))';
% % 
% % figure
% % 
% % h=animatedline;
% % xlabel('Time (h)')
% % ylabel('% CH_4')
% % 
% % for rr=1:1:size(vrow,2)
% % addpoints(h,vrow(rr),vcol(rr));
% % drawnow; pause(0.01);
% % end
% 
