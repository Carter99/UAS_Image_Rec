x=imresize(imread("../UAS LETTERS/A/image0001.jpg"),[25,25]);
rgbList=reshape(x,[],1,3);
colourValues=mean(rgbList);
disp(colourValues)
[~,minIndex]=min(colourValues);

imageChoice=double(rgbList(:,:,minIndex));

imageMax=max(imageChoice);
imageMin=min(imageChoice);
dataRange=imageMax-imageMin;
imageChoice=(imageChoice-imageMin)/dataRange;