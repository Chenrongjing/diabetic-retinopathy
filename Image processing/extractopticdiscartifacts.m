%% Extract optic disc from one image
tic
% Read image
retinaRGB = imread('E:/Dev/CAD/Diabetic Retinopathy/train/216_right.jpeg');
% Resize image
retinaRGB = resizeretina(retinaRGB, 752, 500);
% Get optic disc mask
closingThresholdValue = 0.64;
opticDiscDilationSize = 4;
artifactMinSize = 1100;
[opticDiscMask, artifactsMask] = getopticdiscartifacts(retinaRGB, ...
            closingThresholdValue, opticDiscDilationSize, artifactMinSize);
toc

%% Extract all optic discs and save them as files
% parpool(4);  % Set workers for paraller computations
tic

% List all images
directory = 'E:/Dev/CAD/Diabetic Retinopathy/train/';
filesLeft = dir(strcat(directory, '*_left.jpeg'));
filesRight = dir(strcat(directory, '*_right.jpeg'));
files = [filesLeft; filesRight];
% For each image
i = 1;
for file = files'
    fileName = strcat(directory, file.name);
    fprintf('Processing image %i / 35126, %s.\n', i, fileName);
    i = i + 1;
    
    % Read image
    retinaRGB = imread(fileName);
    % Resize image
    retinaRGB = resizeretina(retinaRGB, 752, 500);
    % Get optic disc mask
    closingThresholdValue = 0.64;
    opticDiscDilationSize = 4;
    artifactMinSize = 1100;
    [opticDiscMask, artifactsMask] = getopticdiscartifacts(retinaRGB, ...
            closingThresholdValue, opticDiscDilationSize, artifactMinSize);
    
    % Save the mask
    imwrite(opticDiscMask, strrep(fileName, '.jpeg', '_optic_disc_mask.png'))
    imwrite(artifactsMask, strrep(fileName, '.jpeg', '_artifacts_mask.png'))
    
end
toc
% delete(gcp);  % Close threads pool