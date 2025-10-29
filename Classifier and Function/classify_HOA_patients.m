function predictions = classify_HOA_patients(example_data , HOA_classifier)
disp('Have you read the ReadME for correct data structure?')
normed_data = (example_data - HOA_classifier.preprocessing.means.mean_health)./HOA_classifier.preprocessing.stds.std_health;

pcs = normed_data * HOA_classifier.preprocessing.eigenvectors.eigenvectors(: , 1:14);

distances = pdist2(pcs(: , 1:14), HOA_classifier.models.kmeans_centroids.centroids_reordered, 'squaredeuclidean');
[~, predicted_cluster] = min(distances, [], 2);

if length(predicted_cluster) < 2
    disp(['Patient belongs to subpopulation ' , num2str(predicted_cluster)])
end

idx1 = find(predicted_cluster == 1);
idx2 = find(predicted_cluster == 2);
idx3 = find(predicted_cluster == 3);

normed_gait_subpopulation_1 = normed_data(idx1 , :);
normed_gait_subpopulation_2 = normed_data(idx2 , :);
normed_gait_subpopulation_3 = normed_data(idx3 , :);

gait_subpopulation_1 = example_data(idx1 , :);
gait_subpopulation_2 = example_data(idx2 , :);
gait_subpopulation_3 = example_data(idx3 , :);

pcs_subpopulation_1 = pcs(idx1 , :);
pcs_subpopulation_2 = pcs(idx2 , :);
pcs_subpopulation_3 = pcs(idx3 , :);

if ~isempty(pcs_subpopulation_1)% ~= 0
    prediction_1 = HOA_classifier.models.svm_subpopulation_1.svm1.predict(pcs_subpopulation_1);
else
    disp('No Patients were clustered to Subpopulation 1')
end

if ~isempty(pcs_subpopulation_2)% ~= 0
    prediction_2 = HOA_classifier.models.svm_subpopulation_2.svm2.predict(pcs_subpopulation_2);
else
    disp('No Patients were clustered to Subpopulation 1')
end


if ~isempty(pcs_subpopulation_3)% ~= 0
    prediction_3 = HOA_classifier.models.svm_subpopulation_3.svm3.predict(pcs_subpopulation_3);
else
    disp('No Patients were clustered to Subpopulation 1')
end

predictions = struct()
predictions.subpopoulation_1.gait_data = gait_subpopulation_1;
predictions.subpopoulation_1.normed_gait_data = normed_gait_subpopulation_1;
predictions.subpopoulation_1.pcs = pcs_subpopulation_1;
predictions.subpopoulation_1.prediction = prediction_1;
predictions.subpopoulation_2.gait_data = gait_subpopulation_2;
predictions.subpopoulation_2.normed_gait_data = normed_gait_subpopulation_2;
predictions.subpopoulation_2.pcs = pcs_subpopulation_2;
predictions.subpopoulation_2.prediction = prediction_2;
predictions.subpopoulation_3.gait_data = gait_subpopulation_3;
predictions.subpopoulation_3.normed_gait_data = normed_gait_subpopulation_3;
predictions.subpopoulation_3.pcs = pcs_subpopulation_3;
predictions.subpopoulation_3.prediction = prediction_3;


end