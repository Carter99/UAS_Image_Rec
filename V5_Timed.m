Learning_Rate=1/size(Training_Data,2);
Duration=1*60;

if ~exist('Cost','var'); Cost=zeros(1,1); end
if ~exist('Correct','var'); Correct=zeros(1,1); end

tic
itterations=0;


% START - DATA SELECTION ################
% %Desired_Output=zeros(35,size(Training_Data,2));
% Desired_Output=zeros(31,size(Training_Data,2));
% %indx=sub2ind([35,size(Training_Data,2)],Class_Index,[1:size(Training_Data,2)]);
% indx=sub2ind([31,size(Training_Data,2)],Training_Data(end,:),[1:size(Training_Data,2)]);
% Desired_Output(indx)=1;
% Input_Layer=Training_Data(1:end-1,:);
% END - DATA SELECTION ##################

while toc<Duration
    itterations=itterations+1;
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

    B_o=B_o+sum(Output_Gradient,2);
    B_h2=B_h2+sum(Hidden_2_Gradient,2);
    B_h1=B_h1+sum(Hidden_1_Gradient,2);
   
    Cost(end+1)=mean(sum(Output_Error.^2));
    %toc
    
    [~,maxIndex]=max(Output_Layer);
    Correct(end+1)=mean(maxIndex==Training_Data(end,:));
end
disp(strcat(num2str(itterations)," itterations completed"))

SmoothingValue=10000;

subplot(1,2,1)
plot(movmean(Cost,SmoothingValue))
xlabel("Itterations")
ylabel("System Error")
ylim([0,4])

subplot(1,2,2)
plot(movmean(Correct,SmoothingValue))
xlabel("Itterations")
ylabel("Rolling Average Correct Probability")
ylim([0,1])