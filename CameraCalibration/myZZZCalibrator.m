clc;
clear;
close all
% CC stands for the result
rootFolder = fullfile('C:\Users\MAC\Desktop\matlabhw\SLAM\CameraCalibration\test');
imgSets = imageSet(rootFolder);
count=imgSets.Count(1,1);
row=7;                                % The number of rows in Chessboard
col=10;                               % The number of columns in Chessboard
rho=5;                                % rho stands for the 
lengthofsquare=17.5;                  % Length of the edge of the Chessboard
theta=8.75;                           % Angle Steps
jd=cell(1,count);
for img=1:count
    I=read(imgSets,img);              % Read the 'i'th image for process
    I=rgb2gray(I);
    [BW,thresh]=edge(I,'canny',[0.08,0.3],5.3);
%      figure;imshow(I,[]);
%      figure;imshow(BW,[]);

    % Hough transformation for the Vertical lines
%     [H,T,R]=myHough(I);
    [H,T,R]=hough(BW,'RhoResolution',rho,'Theta',-10:theta:10);
    P=houghpeaks(H,col+3,'threshold',ceil(0.2*max(H(:))));
    lines=houghlines(BW,T,R,P,'FillGap',lengthofsquare*1.5,'MinLength',lengthofsquare*3);
    vertical=[];
    ps=[];
    for k=1:length(lines)
        xy=[lines(k).point1;lines(k).point2];
        dis=(xy(1,1)+xy(2,1))/2;
        vertical=[vertical,dis];
        tmp=0;
        if length(vertical)>1
            for i=1:length(vertical)-1
                if abs(dis-vertical(i))<rho*2.5
                    vertical(end)=[];             % Delete the repeated Hough lines
                    tmp=1;
                    break
                end
            end
        end
        if tmp
            continue
        end
        t=lines(k).theta;
        r=lines(k).rho;
        p=[-tan(t*pi/180),r/cos(t*pi/180)]; % Evade the infinity situation
        ps=[ps;p];
    end
    switch length(vertical)
        case col+1
            for u=1:2
                [m1,index1]=max(vertical);
                m1=size(I,2)-m1;
                [m2,index2]=min(vertical);
                if m1<m2
                    ps(index1,:)=[];
                    vertical(index1)=[];
                else
                    ps(index2,:)=[];
                    vertical(index2)=[];
                end
            end
        case col
            [m1,index1]=max(vertical);
            m1=size(I,2)-m1;
            [m2,index2]=min(vertical);
            if m1<m2
                ps(index1,:)=[];
                vertical(index1)=[];
            else
                ps(index2,:)=[];
                vertical(index2)=[];
            end
    end
    if length(vertical)<col-1
        disp(strcat('The',num2str(img),'th Chessboard is missed from inspection'));
    end
        
    % Hough transformation for the horizontal lines
    [H,T,R]=hough(BW,'RhoResolution',rho,'Theta',[-90:theta:-80,80:theta:90-theta]);
    P=houghpeaks(H,row+3,'threshold',ceil(0.2*max(H(:))));
    lines=houghlines(BW,T,R,P,'FillGap',lengthofsquare*1.5,'MinLength',lengthofsquare*3);
    horizontal=[];
    ph=[];
    for k=1:length(lines)
        xy=[lines(k).point1;lines(k).point2];
        dis=(xy(1,2)+xy(2,2))/2;
        horizontal=[horizontal,dis];
        tmp=0;
        if length(horizontal)>1
            for i=1:length(horizontal)-1
                if abs(dis-horizontal(i))<rho*2.5
                    horizontal(end)=[];
                    tmp=1;
                    break
                end
            end
        end
        if tmp
            continue
        end
        t=lines(k).theta;
        r=lines(k).rho;
        p=[-cot(t*pi/180),r/sin(t*pi/180)];
        ph=[ph;p];
    end
    switch length(horizontal)
        case row+1
            for u=1:2
                [m1,index1]=max(horizontal);
                m1=size(I,1)-m1;
                [m2,index2]=min(horizontal);
                if m1<m2
                    ph(index1,:)=[];
                    horizontal(index1)=[];
                else
                    ph(index2,:)=[];
                    horizontal(index2)=[];
                end
            end
        case row
            [m1,index1]=max(horizontal);
            m1=size(I,1)-m1;
            [m2,index2]=min(horizontal);
            if m1<m2
                ph(index1,:)=[];
                horizontal(index1)=[];
            else
                ph(index2,:)=[];
                horizontal(index2)=[];
            end
    end
    if length(horizontal)<row-1
        disp(strcat('The',num2str(img),'th Chessboard is missed from inspection'));
    end

    % Calculate the intercept point for the vertical and horizontal lines
    corner0=zeros(2,(row-1)*(col-1));
    for i=1:row-1
        for j=1:col-1
            n=(i-1)*(col-1)+j;
            corner0(1,n)=(ps(j,1)*ph(i,2)+ps(j,2))/(1-ps(j,1)*ph(i,1));
            corner0(2,n)=(ph(i,1)*ps(j,2)+ph(i,2))/(1-ph(i,1)*ps(j,1));
        end
    end

    % Calculate for the precise corner points
    if rho>10
        Image=imresize(I,1/2);
        C=corner(Image,'FilterCoefficients',fspecial('gaussian',[5 1],3));
%         figure,imshow(Image,'InitialMagnification',60);
%         hold on
%         plot(C(:,1), C(:,2), 'rx');
        C=C.*2;
    else
        Image=I;
        C=corner(Image,'FilterCoefficients',fspecial('gaussian',[5 1],3));
%         figure,imshow(Image,'InitialMagnification',30);
%         hold on
%         plot(C(:,1), C(:,2), 'rx');
    end
    C0=corner0';
    CC=zeros(size(C0));
    % finds the nearest neighbor in C for each point in C0
    [nv,d]=knnsearch(C,C0,'k',2);
    for i=1:size(corner0,2)
        a=C(nv(i,:),:);
        CC(i,:)=mean(a(d(i,:)<rho+5,:),1);
    end
    figure;
    imshow(I,'InitialMagnification',30);
    title('Corner Points Exibition');
    grid on;
    axis on;
    hold on;
    plot(CC(:,1),CC(:,2),'rx');
    jd{1,img}=CC;
end