tic
Classifier_Folders=["1","2",'3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
%Relative_Folder="../UAS LETTERS/";
Local_Relative_Folder="../UAS LETTERS/";

Local_Image_Dimensions=[25,25];
Local_image_VectorLength=prod(Local_Image_Dimensions);
Training_Data=[];
Testing_Data=[];

for Local_Class_Index=1:length(Classifier_Folders)
    disp(strcat(Classifier_Folders(Local_Class_Index),"=>",num2str(100*(Local_Class_Index-1)/length(Classifier_Folders)),"% Loaded"))
    Local_Class=Classifier_Folders(Local_Class_Index);
    Local_filepath=strcat(Local_Relative_Folder,Local_Class,'/');
    Local_dinfo=dir(Local_filepath);
    Local_names={Local_dinfo.name};
    Local_rel_names=strcat(Local_filepath, Local_names);
    Local_rel_names=Local_rel_names(3:end);
    
        for Local_imageIndex=1:length(Local_rel_names)
            Local_imageFilePath=Local_rel_names(Local_imageIndex);
            Local_imageFilePath=[Local_imageFilePath{:}];
            if Local_imageFilePath(end-8:end)~=".DS_Store"
                %disp(imageFilePath)
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Local_rgbImage=imresize(imread(Local_imageFilePath),Local_Image_Dimensions);
                %imshow(Local_rgbImage)
                
                %Local_BWimage=mean(Local_rgbImage-imresize(Local_rgbImage,[1,1]),3)>0;
                %Local_imageVector=reshape(Local_BWimage,[Local_image_VectorLength,1]);
                %imshow(Local_BWimage)
                
                Local_rgbImage=imresize(imread(Local_imageFilePath),Local_Image_Dimensions);
                Local_rgbVector=reshape(Local_rgbImage,[],1,3);
                Local_colourValues=mean(Local_rgbVector);
                %disp(colourValues)
                [~,Local_minIndex]=min(Local_colourValues);

                Local_imageVector=double(Local_rgbVector(:,:,Local_minIndex));

                Local_mean=mean(Local_imageVector);
                Local_imageVector=Local_imageVector>Local_mean;
                %imshow(reshape(Local_imageVector,[25,25]))
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                if Local_imageIndex<=500
                    Testing_Data(1:Local_image_VectorLength,end+1)=Local_imageVector;
                    Testing_Data(Local_image_VectorLength+1,end)=Local_Class_Index;
                else
                    Training_Data(1:Local_image_VectorLength,end+1)=Local_imageVector;
                    Training_Data(Local_image_VectorLength+1,end)=Local_Class_Index;
                end
            end
        end
            
end
Training_Data_Count=size(Training_Data,2);
disp("100% Loaded")
toc
clear Local_*