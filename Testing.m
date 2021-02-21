ResultMatrix=zeros(size(B_o,1)+1);
Classifier_Folders=["1","2",'3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

Classifier_Folders=["1","2",'3','4','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','O','P','Q','R','T','U','V','W','X','Y'];
tic
for i=1:size(Testing_Data,2)
   % START - DATA SELECTION ################
    Data_Index=i;
    Input_Layer=Testing_Data(1:size(W_i_h1,2),Data_Index);
    Class_Index=Testing_Data(end,Data_Index);
    % END - DATA SELECTION ##################
    for imrot=1:4
        quad_Input_Layer(:,imrot)=reshape(rot90(reshape(Input_Layer,[25,25]),imrot),625,[]);
    end
    % START - FEEDFORWARD ###################
    quad_Output_Layer=feedforward(quad_Input_Layer,W_i_h1,B_h1,W_h1_h2,B_h2,W_h2_o,B_o);
    % END - FEEDFORWARD ##################### 
    
    [~,maxIndex]=max(quad_Output_Layer);
    mode_maxIndex=mode(maxIndex);
    
    ResultMatrix(Class_Index,mode_maxIndex)=ResultMatrix(Class_Index,mode_maxIndex)+1;
end
toc/(35*500)
pcolor(ResultMatrix/500)
xlabel("Network Prediction","Interpreter","latex","FontSize",15)
ylabel("Ground Truth","Interpreter","latex","FontSize",15)
title("Probability of Correct Character Identification on Unseen Images (Oct 2nd 2020)","Interpreter","latex","FontSize",20)
xticklabels([Classifier_Folders,""])
yticklabels([Classifier_Folders,""])
xticks(1:36)
yticks(1:36)
colormap jet
colorbar
axis ij
caxis([0,1])
drawnow;


[values,IndexGuessFreq]=sort(ResultMatrix(1:end-1,1:end-1)');

Extraction=diag(ResultMatrix);
disp("Individual Character Accuracy")
disp([Classifier_Folders',Extraction(1:end-1)/500,Classifier_Folders(IndexGuessFreq(end-1,:))',values(end-1,:)'/500]);
disp("Overall Network Accuracy on Unseen Data")
disp(mean(Extraction(1:end-1)/500))