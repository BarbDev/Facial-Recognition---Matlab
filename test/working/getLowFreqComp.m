function [ pos, neg ] = getLowFreqComp( normalizedPatches )
%GETLOWFREQCOMP Summary of this function goes here
%   Detailed explanation goes here

[vSize, nbrFeature] = size(normalizedPatches);
%center = vSize/2; % Get column size (btw its only a column)
%lowFreqComps = zeros(15, nbrFeature); % Memory allocation
pos = zeros(15, nbrFeature);
neg = zeros(15, nbrFeature);
%temp = zeros(vSize);

for i = 1:nbrFeature
    %vec = unique(nonzeros(normalizedPatches(:,i))); % do unique rather than just sorting ?
    %lowFreqComps(:,i) = vec(uint8(center-7):uint8(center+7));
    vec = normalizedPatches(:,i);
    temp = sort(vec(vec>0), 'ascend');
    if size(temp) < 15
        pos(:,i) = [temp(1:end) zeros([(15 - size(temp)) 1])];
    else
        pos(:,i) = temp(1:15);
    end
    temp = sort(vec(vec<0), 'descend');
    if size(temp) < 15
        neg(:,i) = [temp(1:end) zeros([(15 - size(temp)) 1])];
    else
        neg(:,i) = temp(1:15);
    end
end

end

