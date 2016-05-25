function [ lowFreqComps ] = getLowFreqComp( normalizedPatches )
%GETLOWFREQCOMP Returns the 15 frequencies closest to 0
%   Detailed explanation goes here

nbrFeature = size(normalizedPatches,2);
lowFreqComps = zeros(15, nbrFeature); % Memory allocation

for i = 1:nbrFeature
    vec = sort(nonzeros(normalizedPatches(:,i))); % discard 0 + sorting
    [~,center] = min(abs(vec));
    if center - 7 < 1
        lowFreqComps(:,i) = vec(1:15);
    elseif center + 7 > size(vec,1) % Account for varying vector size due to the 0 discard
        lowFreqComps(:,i) = vec(size(vec,1)-14:size(vec,1));
    else
        % we are in the bounds of the vector, everything is ok
        lowFreqComps(:,i) = vec(center-7:center+7);
    end
end

end

