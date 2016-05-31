clc
clear variables
% 
% %% Getting the supported file formats
% form = imformats;
% formats = '\w\.(';
% for i = 1:size(form,2)
%     if size(form(i).ext,2) > 1 % We have different extension for same format
%         for j = 1:size(form(i).ext,2)
%             if i~=1 || j~=1
%                 formats = strcat(formats,'|',form(i).ext(j));
%             else
%                 formats = strcat(formats,form(i).ext(j));
%             end
%         end
%     else
%         if i~=1
%             formats = strcat(formats,'|',form(i).ext);
%         else
%             formats = strcat(formats,form(i).ext);
%         end
%     end
% end
% formats = strcat(formats,')$');
% if ~cellfun(@isempty, regexpi('yoloy.png', formats, 'start'))
%     display('YES') % IT MATCHES
% end

datasetName='chokepoint';
if strcmp(getenv('OS'),'Windows_NT')
    separator = '\';
else
    separator = '/';
end
if regexp(datasetName, '^(chokepoint|colorferet|CroppedYale|ExtendedYaleB|ORL)$')
    datasetPath = [pwd separator 'database' separator 'dataset_' datasetName];
    if strcmp(datasetName, 'chokepoint')
        datasetPath = uigetdir(datasetPath,'Choose a database');
    elseif strcmp(datasetName, 'colorferet')
        error('Cannot use colorferet, not implemented yet')
        return;
    end
elseif strcmpi(datasetName, 'null')
    datasetPath = uigetdir(pwd,'Choose a database');
else
    error(['Database name: %s \nPlease check spelling (case sensitive)' ...
        'and your current folder if not using ''null'''], datasetName);
    return;
end