load("NN_Values.mat")
Classifier_Folders=["1","2",'3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
[baseName, folder] = uigetfile({'*.png'});
fullFileName = fullfile(folder, baseName);
inputImg=imread(fullFileName);


ImageIdentification(inputImg, Classifier_Folders)
