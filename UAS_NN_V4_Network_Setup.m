Input_Nodes=625;
Hidden_Nodes_1=300;
Hidden_Nodes_2=300;
Output_Nodes=35;
Output_Nodes=31;
%Classifier_Folders=["1","2",'3','4','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','O','P','Q','R','T','U','V','W','X','Y'];
Classifier_Folders=["1","2",'3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];

% START - NETWORK ARCHITECTURE ##########
Input_Layer=zeros(Input_Nodes,1);

W_i_h1=rand(Hidden_Nodes_1,Input_Nodes)-0.5;
Hidden_Layer_1=zeros(Hidden_Nodes_1,1);
B_h1=zeros(Hidden_Nodes_1,1);

W_h1_h2=rand(Hidden_Nodes_2,Hidden_Nodes_1)-0.5;
Hidden_Layer_2=zeros(Hidden_Nodes_2,1);
B_h2=zeros(Hidden_Nodes_2,1);

W_h2_o=rand(Output_Nodes,Hidden_Nodes_2)-0.5;
Output_Layer=zeros(Output_Nodes,1);
B_o=zeros(Output_Nodes,1);
% END - NETWORK ARCHITECTURE ############

Cost=zeros(1,1);
Correct=zeros(1,1);