load("NN_Values.mat")
Classifier_Folders=["1","2",'3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
HueColours=["Red","Orange","Yellow","Chartreuse Green","Green","Spring Green","Cyan","Azure","Blue","Violet","Magenta","Rose"];

for i=[5,4,3,2,1]
    pause(1)
    disp(strcat("Camera turning on in: ",num2str(i)))
end


data=zeros(1,2);
if ~exist('cam','var'); cam=webcam(1); end
pause(1)


for i=1:100
inputImg=snapshot(cam);
tic
[class_index,hue_index]=ImageIdentification(inputImg,W_i_h1,W_h1_h2,W_h2_o,B_h1,B_h2,B_o);
data(i,:)=[class_index,hue_index];
toc
end
clear cam

disp(strcat("Character Prediction: ",Classifier_Folders(mode(data(:,1)))))
disp(strcat("Colour Prediction: ",HueColours(mode(data(:,2)))))