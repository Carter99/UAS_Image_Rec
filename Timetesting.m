%[baseName, folder] = uigetfile({'*.jpg'});
tic
%fullFileName = fullfile(folder, baseName);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%rgbImage=imresize(imread(fullFileName),Image_Dimensions);
rgbVector=reshape(rgbImage,[],1,3);
colourValues=mean(rgbVector);
%disp(colourValues)
[~,minIndex]=min(colourValues);

imageVector=double(rgbVector(:,:,minIndex));

imageMax=max(imageVector);
imageMin=min(imageVector);
dataRange=imageMax-imageMin;
imageVector=(imageVector-imageMin)/dataRange;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ImageMax=max(imageVector);
ImageMin=min(imageVector);
dataRange=ImageMax-ImageMin;
imageVector=(imageVector-ImageMin)/dataRange;

Input_Layer=imageVector;
Hidden_Layer_1=Sigmoid(W_i_h1*Input_Layer+B_h1);
Hidden_Layer_2=Sigmoid(W_h1_h2*Hidden_Layer_1+B_h2);
Output_Layer=Sigmoid(W_h2_o*Hidden_Layer_2+B_o);
[~,index]=max(Output_Layer);
toc
disp(strcat("Guess => ",Classifier_Folders(index)))

%bar(categorical(Classifier_Folders),Output_Layer)
%ylim([0,1])