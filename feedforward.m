function [Output_Layer]=feedforward(Input_Layer,W_i_h1,B_h1,W_h1_h2,B_h2,W_h2_o,B_o)
    Hidden_Layer_1=Sigmoid(W_i_h1*Input_Layer+B_h1);
    Hidden_Layer_2=Sigmoid(W_h1_h2*Hidden_Layer_1+B_h2);
    Output_Layer=Sigmoid(W_h2_o*Hidden_Layer_2+B_o);
end