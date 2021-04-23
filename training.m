%% Testing Train
clc; clear all; close all;

HV_set1(1,:) = [0,1,-1,0,1];
HV_set1(2,:) = [0,1,-1,0,1];
HV_set1(3,:) = [1,1,-1,-1,1];
HV_set2(:,:) = HV_set1;
HV_sets(:,:,1) = HV_set1;
HV_sets(:,:,2) = HV_set2;

class_HVs = Train(HV_sets);

%% Training Function
% Takes HV_sets, a three-dimensional array that represents the full set of
%       all of the hypervectors, where each is a one-dimensional array, and
%       they are organized into two-dimensional arrays based on the class.
% 
% Returns classHVs, a two-dimensional array of the trained class
%       hypervectors that are represented as one-dimensional arrays

function [classHVs] = Train(HV_sets)

    size(HV_sets,3);

    for i = 1:size(HV_sets,3)
        class_set = HV_sets(:,:,i);
        div_num = ((size(class_set,1) + 1)/2);
        
        for j = 1:size(class_set,2)
            col_sum = sum(class_set(:,j));
            classHVs(i,j) = fix(abs(col_sum/div_num));
        end
    end

end