%% Project Frequency Bins onto Hypervectors
D = 100;
M = 10;
for v = 1:10
    if (v == 1)
        BaseVectors(v,:) = randi([0,1],1,100);
    else
        BaseVectors(v,:) = BaseVectors(v-1,:);
        rand = randi(D,(D/M-v),1);
        for i = 1:length(rand)
            BaseVectors(v,rand(i)) = ~BaseVectors(v,rand(i));
        end
    end
end

for e = 1:100
    IDVectors(e,:) = randi([0,1],1,1000);
end

BaseVectors
