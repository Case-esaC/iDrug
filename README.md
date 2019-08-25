## iDrug: Integration of drug repositioning and drug-target prediction via cross-network embedding
iDrug is a computational pipeline to jointly predict novel drug-disease and drug-target interactions from heterogeneous network. iDrug adpot cross-network embedding to learn  low-dimensional feature space for drugs, targets, and diseases in the heterogeneous network.

### Quick start
We provide an example script to run experiments on our dataset: 

- Run `main.m`: predict drug-disease interactions, and evaluate the results with cross-validation. 



### Code and data
- `iDrug.m`: the optimization algorith to solve iDrug framework.
- `main.m`: demo code of running `iDrug.m` for drug repositioning.
- `auc.m`: evaluation script for AUPR measurement.


- `run_DCA.m`: example code of running `DCA.m` for feature learning
- `run_DTINet.m`: example code of running `DTINet.m` for drug-target prediction
- `train_mf.mexa64`: pre-built binary file of inductive matrix completion algorithm (downloaded from [here](http://bigdata.ices.utexas.edu/software/inductive-matrix-completion/))
- `download_imc.sh`: download the inductive matrix completion source and build the executable library from source.


### Contacts
If you have any questions or comments, please feel free to email Huiyuan Chen (hxc501[at]case[dot]com).
