### Gold standard dataset
- The drug-disease dataset can be obtained from the reference : "Gottlieb, Assaf, et al. "PREDICT: a method for inferring novel drug indications with application to personalized medicine." Molecular systems biology 7.1 (2011)".t 
- The drug-target dataset can be downloaded from the DrugBank: https://www.drugbank.ca/

### Data in MatLab format
- `DrugDisease.mat`: the drug-disease interactions.
- `DrugTarget.mat`: the drug-target interactions.
- `DrugSimMat1.mat`: the drug-drug similarity in drug-disease domain.
- `DrugSimMat2.mat`: the drug-drug similarity in drug-target domain.
- `DiseaseSimMat.mat`: the disease-disease similarity.
- `TargetSimMat.mat`: the target-target similarity.
- `SMat.mat`: the mapping matrix to denote the anchor links across the two domains.

- `validTop20gold.csv`: the top-20 predicted results by our iDrug with validation

### Quick start
To run on this dataset, users just need to switch to this directory.
