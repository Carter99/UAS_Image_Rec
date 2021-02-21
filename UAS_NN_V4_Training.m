%load('NN_Values.mat')
%UAS_NN_V4_Network_Setup
%if ~exist('B_o','var')
%    input("No current Weights/Biases found. Do you wish to load or start")

if ~exist('Cost','var'); Cost=zeros(1,1); end
if ~exist('Correct','var'); Correct=zeros(1,1); end

Learning_Rate=0.01;% Good initial base learning rate
Learning_Rate=0.0001;
Itterations=0.1e7; %1e5=45s 1e6=420s (7m) 1e7=4200s (1h10m)
tic
for i=1:Itterations
    if mod(i,(Itterations/100))==0&&i>10000
       disp(strcat(num2str(i/(Itterations/100)),"% Trained... Current Average Accuracy = ",num2str(round(100*mean(Correct(end-10000:end)),3)),"%"))
       %Testing
    end
    if i==10000
        disp(strcat("Estimated Compute Time = ",num2str(toc*Itterations/10000)," Seconds"))
    end
    % START - DATA SELECTION ################
    Data_Index=ceil(rand*Training_Data_Count);
    Input_Layer=Training_Data(1:size(W_i_h1,2),Data_Index);
    Class_Index=Training_Data(end,Data_Index);
    Desired_Output=zeros(size(B_o,1),1);
    Desired_Output(Class_Index)=1;
    % END - DATA SELECTION ##################

    % START - FEEDFORWARD ###################
    Hidden_Layer_1=Sigmoid(W_i_h1*Input_Layer+B_h1);
    Hidden_Layer_2=Sigmoid(W_h1_h2*Hidden_Layer_1+B_h2);
    Output_Layer=Sigmoid(W_h2_o*Hidden_Layer_2+B_o);
    % END - FEEDFORWARD #####################

    % START - BACKPROP - OUTPUT -> HIDDEN2 ##
    Output_Error = Desired_Output-Output_Layer;
    Output_Gradient=Learning_Rate*Output_Error.*Output_Layer.*(1-Output_Layer);
    Delta_W_h2_o=Output_Gradient*Hidden_Layer_2';
    % END - BACKPROP - OUTPUT -> HIDDEN2 ####

    % START - BACKPROP - HIDDEN2 -> HIDDEN1 #
    Hidden_2_Error=W_h2_o'*Output_Error;
    Hidden_2_Gradient=Learning_Rate*Hidden_2_Error.*Hidden_Layer_2.*(1-Hidden_Layer_2);
    Delta_W_h1_h2=Hidden_2_Gradient*Hidden_Layer_1';
    % END - BACKPROP - HIDDEN2 -> HIDDEN1 ###

    
    % START - BACKPROP - HIDDEN1 -> INPUT ###
    Hidden_1_Error=W_h1_h2'*Hidden_2_Error;
    Hidden_1_Gradient=Learning_Rate*Hidden_1_Error.*Hidden_Layer_1.*(1-Hidden_Layer_1);
    Delta_W_i_h1=Hidden_1_Gradient*Input_Layer';
    % END - BACKPROP - HIDDEN1 -> INPUT #####

    W_h2_o=W_h2_o+Delta_W_h2_o;
    W_h1_h2=W_h1_h2+Delta_W_h1_h2;
    W_i_h1=W_i_h1+Delta_W_i_h1;

    B_o=B_o+Output_Gradient;
    B_h2=B_h2+Hidden_2_Gradient;
    B_h1=B_h1+Hidden_1_Gradient;
   
    Cost(end+1)=sum(Output_Error.^2);
    
    [~,maxIndex]=max(Output_Layer);
    Correct(end+1)=(maxIndex==Class_Index);
end
toc
%save("NN_Values.mat",'W_i_h1','B_h1','W_h1_h2','B_h2','W_h2_o','B_o')

SmoothingValue=10000;

subplot(1,2,1)
temp=movmean(Cost,SmoothingValue);
plot(temp(1:1000:end));
xlabel("Itterations")
ylabel("System Error")
ylim([0,4])

subplot(1,2,2)
temp=movmean(Correct,SmoothingValue);
plot(temp(1:1000:end));
xlabel("Itterations")
ylabel("Rolling Average Correct Probability")
ylim([0,1])



partialRunResult=100*mean(Correct(end-10000:end));
partialRunCorrect=movmean(Correct,10000)';