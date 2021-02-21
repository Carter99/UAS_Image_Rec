for i=[1]
    pause(1)
    disp(strcat("Camera turning on in: ",num2str(i)))
end


data=zeros(1,2);
if ~exist('cam','var'); cam=webcam(1); end
pause(1)


limit=150;
tic
for i=1:100
    inputImg=snapshot(cam);
    imcutoff=mean((inputImg>limit),3)==1;
    imcutoffdownsize=imresize(imcutoff,1/8)==1;
    cornerdetect=zeros(size(imcutoffdownsize));
    for y=4:size(imcutoffdownsize,1)-3
        for x=4:size(imcutoffdownsize,2)-3
            I1=imcutoffdownsize(y-3,x);
            I9=imcutoffdownsize(y+3,x);
            if I1~=I9
                 I5=img(y,x+3);
                 I13=img(y,x-3);
                 cornerdetect(y,x)=I5~=I13;
            end
        end
    end
    
    
%             %luminosity=mean(mean(imcutoffdownsize([y-3:y+3],[x-3:x+3])));
%             %cornerdetect(y,x)=luminosity>0.2&luminosity<0.35;
%             
%             luminosity=sum([imcutoffdownsize(y+3,x),imcutoffdownsize(y+3,x+1),imcutoffdownsize(y+2,x+2),imcutoffdownsize(y+1,x+3),imcutoffdownsize(y,x+3),imcutoffdownsize(y-1,x+3),imcutoffdownsize(y-2,x+2),imcutoffdownsize(y-3,x+1),imcutoffdownsize(y-3,x),imcutoffdownsize(y-3,x-1),imcutoffdownsize(y-2,x-2),imcutoffdownsize(y-1,x-3),imcutoffdownsize(y,x-3),imcutoffdownsize(y+1,x-3),imcutoffdownsize(y+2,x-2),imcutoffdownsize(y+3,x-1)]);
%             cornerdetect(y,x)=luminosity>=3&luminosity<=5
% %             imcutoffdownsize(y-3,x)
% %             imcutoffdownsize(y+3,x)
% %             imcutoffdownsize(y,x-3)
% %             imcutoffdownsize(y,x+3)
   
    
    
%     t=40; %Threashold Pixel Intensity
%     downSample1=2;
%     downSample2=2;
%     img=imresize(inputImg(:,:,1),1/downSample1);
%     newimg=zeros(size(img));
%     for y=4:size(img,1)-3
%         for x=4:size(img,2)-3
%             Ip=img(y,x);
%             ThresholdUpper=Ip+t;
%             ThresholdLower=Ip-t;
%             I1=img(y-3,x);
%             I9=img(y+3,x);
%             if ~(I1>ThresholdLower&&I1<ThresholdUpper&&I9>ThresholdLower&&I9<ThresholdUpper)
%                 I5=img(y,x+3);
%                 I13=img(y,x-3);
%                 if ~(I5>ThresholdLower&&I5<ThresholdUpper&&I13>ThresholdLower&&I13<ThresholdUpper)
%                     newimg(y,x)=1;
%                 end
%             end
%         end
%     end
%     imdown=imresize(newimg,1/downSample2);
%     %imshow(imdown)
%     %imdown
%     imdown=imdown>.1;
%     if sum(sum(imdown))<4
%         disp("No Label Found")
%     else


%     [y,x]=find(imdown);
%     yrange=[min(y)*downSample1*downSample2: max(y)*downSample1*downSample2]-floor(downSample1*downSample2*0.5);
%     xrange=[min(x)*downSample1*downSample2: max(x)*downSample1*downSample2]-floor(downSample1*downSample2*0.5);
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %Crops down the larger square down to only contain the center square and
%     %border
%     yrange=yrange(floor(length(yrange)/5):ceil(4*length(yrange)/5));
%     xrange=xrange(floor(length(xrange)/5):ceil(4*length(xrange)/5));
    
    
    
    
%     subplot(4,1,1)
%     imshow(inputImg)
%     
%     subplot(4,1,2)
%     imshow(imcutoff)
%     
%     subplot(4,1,3)
%     imshow(imcutoffdownsize)
%     
%     subplot(4,1,4)
%     imshow(cornerdetect)
    
    %subplot(3,1,2)
    %imshow(imdown)
    
    %subplot(3,1,3)
    %imshow(imcontrast)
    %end
end


toc





clear cam