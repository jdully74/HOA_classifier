# HOA_classifier
This repository contains a pipeline that clusters and classifies patients with HOA using a ML approach. It includes the necessary eigenvectors and scalers to pre-process the data as well as the k-means results and the SVMs to cluster and classify the patients automatically.
Data needs to be stored in a matrix of size n_subjects x 1818. Where 1818 is the concatenated vector of each subject of all variables. The variables consist of 101 timepoints. The order of the variables needs to be:
1. Pelvic sagittal angle
2. Pelvic frontal angle
3. pelvic transversal angle
4. Hip flexion angle
5. Hip abduction angle
6. Hip rotation angle
7. Knee flexion angle
8. Knee abduction angle
9. Knee rotation angle 
10. Ankle flexion angle
11. Foot progression angle
12. Hip flexion moment
13. Hip abduction moment
14. Hip rotation moment
15. Knee flexion moment
16. Knee abduction moment
17. Knee rotation moment 
18. Ankle flexion moment

In  first step, the data hast to be z-normalized using the mean and standarddeviation of the healthy group
This data can then be mutliplied by the eigenvectors that result in the PC scores for the patients that can be used for the further model building.
All relevant models, preprocessing files and functions can be found in the folder 'Classifier and Function'
The other folders contain the same data, but split up.
