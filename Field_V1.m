function ImageIdentification(inputImg)
    t=40; %Threashold Pixel Intensity
    downSample1=1;
    downSample2=1;
    tic

    img=imresize(inputImg(:,:,1),1/downSample1);
    newimg=zeros(size(img));
    for y=4:size(img,1)-3
        for x=4:size(img,2)-3
            Ip=img(y,x);
            ThresholdUpper=Ip+t;
            ThresholdLower=Ip-t;
            I1=img(y-3,x);
            I9=img(y+3,x);
            if ~(I1>ThresholdLower&&I1<ThresholdUpper&&I9>ThresholdLower&&I9<ThresholdUpper)
                I5=img(y,x+3);
                I13=img(y,x-3);
                if ~(I5>ThresholdLower&&I5<ThresholdUpper&&I13>ThresholdLower&&I13<ThresholdUpper)
                    newimg(y,x)=1;
                end
            end
            %newimg(y,x)=
        end
    end
    imdown=imresize(newimg,1/downSample2);
    imdown=imdown>.1;
    if sum(sum(imdown))<4
        disp("No Label Found")
    else
    [y,x]=find(imdown);
    yrange=[min(y)*downSample1*downSample2: max(y)*downSample1*downSample2]-floor(downSample1*downSample2*0.5);
    xrange=[min(x)*downSample1*downSample2: max(x)*downSample1*downSample2]-floor(downSample1*downSample2*0.5);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Crops down the larger square down to only contain the center square and
    %border
    yrange=yrange(floor(length(yrange)/5):ceil(4*length(yrange)/5));
    xrange=xrange(floor(length(xrange)/5):ceil(4*length(xrange)/5));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    toc

    rgbImage=imresize(inputImg(yrange,xrange,:),[25,25]);
    %imshow(rgbImage)
    HSV=rgb2hsv(imresize(rgbImage,[1,1]));
    Hue=HSV(1);
    % ##########################################################################
    Local_rgbVector=reshape(rgbImage,[],1,3);
    Local_colourValues=mean(Local_rgbVector);
    %disp(colourValues)
    [~,Local_minIndex]=min(Local_colourValues);

    Local_imageVector=double(Local_rgbVector(:,:,Local_minIndex));

    Local_mean=mean(Local_imageVector);
    Local_imageVector=Local_imageVector>Local_mean;

    for imrot=1:4
        quad_Input_Layer(:,imrot)=reshape(rot90(reshape(Local_imageVector,[25,25]),imrot),625,[]);
    end
    % START - FEEDFORWARD ###################
    quad_Output_Layer=feedforward(quad_Input_Layer,W_i_h1,B_h1,W_h1_h2,B_h2,W_h2_o,B_o);
    % END - FEEDFORWARD ##################### 

    [~,maxIndex]=max(quad_Output_Layer);
    mode_maxIndex=mode(maxIndex);
    % ##########################################################################

    HueMarkers=[0:30:330];
    HueColours=["Red","Orange","Yellow","Chartreuse Green","Green","Spring Green","Cyan","Azure","Blue","Violet","Magenta","Rose"];

    if Hue>=(345/360)||Hue<(15/360)
        ColourDecision=HueColours(1);
    else
        for i=2:12
            minHue=mod(HueMarkers(i)-15,360)/360;
            maxHue=mod(HueMarkers(i)+15,360)/360;
            if Hue>=minHue&&Hue<maxHue
                ColourDecision=HueColours(i);
                break
            end
        end
    end

    %Timetesting
    end

    disp(strcat("Character Prediction: ",Classifier_Folders(mode_maxIndex)," Colour Prediction: ",ColourDecision))
    %imshow(reshape(Local_imageVector,[25,25]))
end