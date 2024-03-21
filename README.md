# update-eks-cluster

1. Create an EKS Cluster using the terraform script present in my GitHub Repo https://github.com/singhritesh85/terraform-eks-withaddons
2. Take the backup of eks cluster using velero with the help of shell script eks-backup-velero.sh. I have used velero CLI to install the velero server.
3. Take the backup of EBS of Nodes for NodeGroup using the shell script ebs-backup.sh.
4. Provide executable permission to the shell script before executing it.
5. To update EKS Cluster from 1.27 to 1.29 first of all it needs to be updated to 1.28 then to 1.29. EKS Cluster cannot be directly updated to 1.29 from 1.27.
```
   EKS Cluster 1.27 ---> EKS Cluater 1.28 ---> EKS Cluster 1.29 
```
6. In the terraform script after creation of EKS Cluster with version 1.27 open file terraform.tfvars in the directory terraform-eks-withaddons in the environment folder which you had used to create the cluster (If needed change the main.tf file as per your requirement) and change the version of kubernetes_version to 1.28 and release_version to 1.28.5-20240129. Then update the EKS Cluster version as 1.29 from 1.28, to achive this change the kubernetes_version to 1.29 and release_version to 1.29.0-20240129.
7. If you need to update Addons then use the updated version as per your requirement.
   For EKS Cluster 1.27, 1.28 and 1.29 I had used the Addons verion as written below.
```
   Addons                        1.27                    1.28                    1.29

   aws-ebs-csi                 v1.25.0-eksbuild.1     v1.28.0-eksbuild.1      v1.28.0-eksbuild.1
   GuardDuty                   v1.4.1-eksbuild.2      v1.5.0-eksbuild.1       v1.5.0-eksbuild.1
   kube-proxy                  v1.27.6-eksbuild.2     v1.28.6-eksbuild.2      v1.29.1-eksbuild.2
   VPC-CNI                     v1.15.1-eksbuild.1     v1.71.1-eksbuild.1      v1.17.1-eksbuild.1
   coredns                     v1.10.1-eksbuild.4     v1.10.1-eksbuild.7      v1.11.1-eksbuild.6
```

You can do the changes in kubernetes_version, release_version and addons version of terraform.tfvars file as shown in the screenshots below.

![image](https://github.com/singhritesh85/update-eks-cluster/assets/56765895/e9f7a744-abc1-4172-9f1a-18dc8d51c206)

![image](https://github.com/singhritesh85/update-eks-cluster/assets/56765895/eb9f0e79-aa6b-4155-b8f0-ba1a5a7d781f)

![image](https://github.com/singhritesh85/update-eks-cluster/assets/56765895/7f4918ef-411b-4cfc-8222-2037a6f0eea3)

Below are the changes in main.tf file

![image](https://github.com/singhritesh85/update-eks-cluster/assets/56765895/1e28ddb5-d186-4c53-ad80-ae94e6ff146b)

Below are the changes in cluster.tf file.

![image](https://github.com/singhritesh85/update-eks-cluster/assets/56765895/f52bd966-bf81-41e7-9b1f-56686f7d62e9)

![image](https://github.com/singhritesh85/update-eks-cluster/assets/56765895/3140d569-bcaf-4bea-b97b-945d7f2262f1)



