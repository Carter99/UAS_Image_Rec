Duration=input('How many mins to run for?: ')*60;
multiple=1;

if ~exist('Training_Data','var'); load('DATA'); end
if ~exist('Learning_Rate','var'); Learning_Rate=0.01; end
if ~exist('Cost','var'); UAS_NN_V4_Network_Setup; end
if ~exist('iterations','var'); iterations=0; end
Training_Data_Count=size(Training_Data,2);
averagesmooth=2500;
saveInterval=4e5;

tic
while toc<Duration
    iterations=iterations+1;
    if mod(iterations,averagesmooth)==0
        disp(strcat(num2str(100*toc/Duration),"% Trained... Current Average Accuracy = ",num2str(round(100*mean(Correct(end-averagesmooth+1:end)),3)),"%")) 
        %Learning_Rate=(1-mean(Correct(end)))/100;
    end
    if mod(iterations,saveInterval)==0
        save(strcat("Intermediary_",num2str(iterations),".mat"),'W_i_h1','B_h1','W_h1_h2','B_h2','W_h2_o','B_o');
    end
    %   disp(strcat(num2str(100*toc/Duration),"% Trained... Current Average Accuracy = ",num2str(round(100*mean(Correct(end-1000:end)),3)),"%")) 
    %   Learning_Rate=(1-mean(Correct(end-900:end)))/80;
    %end
    %START - DATA SELECTION ################
    Data_Index=ceil(rand(1,multiple)*Training_Data_Count);
    Input_Layer=Training_Data(1:size(W_i_h1,2),Data_Index);
    Class_Index=Training_Data(end,Data_Index);
    %Desired_Output=zeros(size(B_o,1),1);
    %Desired_Output(Class_Index)=1;
    Desired_Output=zeros(31,multiple);
    indx=sub2ind([31,multiple],Class_Index,[1:multiple]);
    Desired_Output(indx)=1;
    %END - DATA SELECTION ##################

    %START - FEEDFORWARD ###################
    Hidden_Layer_1=Sigmoid(W_i_h1*Input_Layer+B_h1);
    Hidden_Layer_2=Sigmoid(W_h1_h2*Hidden_Layer_1+B_h2);
    Output_Layer=Sigmoid(W_h2_o*Hidden_Layer_2+B_o);
    %END - FEEDFORWARD #####################

    %START - BACKPROP - OUTPUT -> HIDDEN2 ##
    Output_Error = Desired_Output-Output_Layer;
    Output_Gradient=Learning_Rate*Output_Error.*Output_Layer.*(1-Output_Layer);
    Delta_W_h2_o=Output_Gradient*Hidden_Layer_2';
    %END - BACKPROP - OUTPUT -> HIDDEN2 ####

    %START - BACKPROP - HIDDEN2 -> HIDDEN1 #
    Hidden_2_Error=W_h2_o'*Output_Error;
    Hidden_2_Gradient=Learning_Rate*Hidden_2_Error.*Hidden_Layer_2.*(1-Hidden_Layer_2);
    Delta_W_h1_h2=Hidden_2_Gradient*Hidden_Layer_1';
    %END - BACKPROP - HIDDEN2 -> HIDDEN1 ###

    
    %START - BACKPROP - HIDDEN1 -> INPUT ###
    Hidden_1_Error=W_h1_h2'*Hidden_2_Error;
    Hidden_1_Gradient=Learning_Rate*Hidden_1_Error.*Hidden_Layer_1.*(1-Hidden_Layer_1);
    Delta_W_i_h1=Hidden_1_Gradient*Input_Layer';
    %END - BACKPROP - HIDDEN1 -> INPUT #####

    W_h2_o=W_h2_o+Delta_W_h2_o;
    W_h1_h2=W_h1_h2+Delta_W_h1_h2;
    W_i_h1=W_i_h1+Delta_W_i_h1;

    B_o=B_o+sum(Output_Gradient,2);
    B_h2=B_h2+sum(Hidden_2_Gradient,2);
    B_h1=B_h1+sum(Hidden_1_Gradient,2);
   
    Cost(end+1)=sum(mean(Output_Error.^2,2));
    
    [~,maxIndex]=max(Output_Layer);
    Correct(end+1)=mean(maxIndex==Class_Index);
end
disp(strcat(num2str(iterations)," iterations completed"))

SmoothingValue=10000;

subplot(1,2,1)
plot(movmean(Cost,SmoothingValue))
xlabel("Iterations")
ylabel("System Error")
ylim([0,4])

subplot(1,2,2)
plot(movmean(Correct,SmoothingValue))
xlabel("Iterations")
ylabel("Rolling Average Correct Probability")
ylim([0,1])