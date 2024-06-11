% Load raw images
data_dir = '...\bw_img';
file_names = dir(fullfile(data_dir, '*.jpg')); % Load .jpg files
num_images = numel(file_names);

images = cell(1, num_images);
for i = 1:num_images
    images{i} = imread(fullfile(data_dir, file_names(i).name));
end

% Visualize some of the faces
figure('Position', [50, 50, 700, 700])
subplot_rows = 10;
subplot_cols = 10;
for i = 1:min(subplot_rows*subplot_cols, num_images)
    subplot_width = 1 / subplot_cols;
    subplot_height = 1 / subplot_rows;
    x_position = mod(i - 1, subplot_cols) * subplot_width;
    y_position = 1 - ceil(i / subplot_cols) * subplot_height;
    
    % Create the subplot with adjusted position and size
    subplot('Position', [x_position, y_position, subplot_width, subplot_height]);
    % Plot your image or data in the subplot
    imshow(images{i});
    axis off;
end

% Calculate the mean face
images_array = cat(3, images{:});
face_matrix = reshape(images_array, [], num_images);
face_mean = mean(images_array, 3);
figure;
imshow(uint8(face_mean));
title('Mean face');

% Compute PCA
A = double(face_matrix) - mean(face_matrix,2);
C = A'*A;

[eigenvectors, eigenvalues] = eig(C);
% Choose the k highest eigenvalues and corresponding eigenvectors
k = 100; % Set the desired number of eigenfaces
[eigenvalues_sorted, idx] = sort(diag(eigenvalues), 'descend');
top_eigenvalues = eigenvalues_sorted(1:k);
top_eigenvectors = eigenvectors(:, idx(1:k));

% Calculate the eigenfaces
eigenfaces = A * top_eigenvectors;

% Normalize the eigenfaces
eigenfaces = eigenfaces ./ vecnorm(eigenfaces);


[height, width] = size(images{1});
% Calculate total energy (sum of all eigenvalues)
total_energy = sum(eigenvalues_sorted);

% Calculate energy percentage for each mode
energy_percentage = (eigenvalues_sorted / total_energy) * 100;

%Visualize some eigenfaces with energy percentages
figure('Name', 'Eigenfaces');
for i = 1:min(k, 9)
    subplot(3, 3, i);
    eigenface_i = eigenfaces(:, i);
    eigenface_i = eigenface_i - min(eigenface_i); % Normalize to [0, 255]
    eigenface_i = eigenface_i / max(eigenface_i) * 255;
    imshow(uint8(reshape(eigenface_i, size(images{1}))));
    title(sprintf('Eigenface %d\n(%.2f%% energy)', i, energy_percentage(i)));
end

%%
% Reconstruct an image using eigenfaces
img_idx = 6; % Choose an image index for reconstruction

img_vector = double(face_matrix(:, img_idx)); % Vectorize the image
%weights = eigenfaces' * img_vector; % Project the image onto eigenfaces

% Reconstruct the image using k eigenfaces
%reconstructed_img = mean(face_matrix,2) + eigenfaces * weights;

% Reshape the reconstructed image to its original dimensions
%reconstructed_img = reshape(reconstructed_img, size(images{1}));

% Reconstruct the image using ncomps to make it more clearer-doesn't work
%n_comps = 50; % Adjust this value to change the number of principal components used
%reconstructed_img = mean(face_matrix, 2) + eigenfaces(:, 1:n_comps) * weights(1:n_comps);
%reconstructed_img = reshape(reconstructed_img, size(images{1}));

% Display the original and reconstructed images
%figure;
%subplot(1, 2, 1);
%imshow(images{img_idx});
%title('Original Image');

%subplot(1, 2, 2);
%imshow(uint8(reconstructed_img));
%title('Reconstructed Image');

%Reconstructing using different number of modes
num_modes_list = [10, 50, 80]; % List of different numbers of modes to use for reconstruction
reconstructed_images = cell(1, numel(num_modes_list));

for j = 1:numel(num_modes_list)
    num_modes = num_modes_list(j);
    selected_eigenfaces = eigenfaces(:, 1:num_modes);
    weights = selected_eigenfaces' * img_vector; % Project the image onto eigenfaces

    % Reconstruct the image using the selected number of eigenfaces
    reconstructed_img = mean(face_matrix, 2) + selected_eigenfaces * weights;
    reconstructed_images{j} = reshape(reconstructed_img, size(images{1}));
end

% Display the original and reconstructed images
figure;
subplot(1, 4, 1);
imshow(images{img_idx});
title('Original Image');

for j = 1:numel(num_modes_list)
    subplot(1, 4, j + 1);
    imshow(uint8(reconstructed_images{j}));
    title([num2str(num_modes_list(j)), ' Modes']);
end
%%

% Calculate cumulative energy percentage
cumulative_energy_percentage = cumsum(energy_percentage);

% Plot the energy of modes vs. modes as a percentage of the total
num_modes_to_display = 100; % Number of modes to display
figure;

yyaxis left
plot(1:num_modes_to_display, energy_percentage(1:num_modes_to_display), 'LineWidth', 2);
ylabel('Individual Energy Percentage');
ylim([0, 100]); % Adjust ylim for better visualization

yyaxis right
plot(1:num_modes_to_display, cumulative_energy_percentage(1:num_modes_to_display), 'LineWidth', 2);
ylabel('Cumulative Energy Percentage');
ylim([0, 100]); % Cumulative percentage ranges from 0 to 100

xlabel('Modes');
title('Energy of Modes vs. Modes as Percentage of Total');
legend('Individual Energy Percentage', 'Cumulative Energy Percentage');
grid on;