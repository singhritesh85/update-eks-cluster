# update-eks-cluster

1. Create an EKS Cluster using the terraform script present in my GitHub Repo https://github.com/singhritesh85/terraform-eks-withaddons
2. Take the backup of eks cluster using velero with the help of shell script eks-backup-velero.sh.
3. Take the backup of EBS of Nodes for NodeGroup using the shell script ebs-backup.sh.
4. Provide executable permission to the shell script before executing it.
5. To update EKS Cluster from 1.27 to 1.29 first of all it needs to be updated to 1.28 then to 1.29. EKS Cluster cannot be directly updated to 1.29 from 1.27.
```
   EKS Cluster 1.27 ---> EKS Cluater 1.28 ---> EKS Cluster 1.29 
```
6. In the terraform script after creation of EKS Cluster with version 1.27 open file terraform.tfvars in the directory terraform-eks-withaddons in the environment folder which you had used to create the cluster and change the version of kubernetes_version to 1.28 and release_version to 1.28.5-20240129. Then update the EKS Cluster version as 1.29 from 1.28, to achive this change the kubernetes_version to 1.29 and release_version to 1.29.0-20240129.
7. If you need to update Addons then use the updated version as per your requirement.
   For EKS Cluster 1.27, 1.28 and 1.29 I had used the Addons verion as written below.
   ```
#   Addons                        1.27                    1.28                    1.29
   aws-ebs-csi                 v1.25.0-eksbuild.1     v1.28.0-eksbuild.1      v1.28.0-eksbuild.1
   GuardDuty                   v1.4.1-eksbuild.2      v1.5.0-eksbuild.1       v1.5.0-eksbuild.1
```
