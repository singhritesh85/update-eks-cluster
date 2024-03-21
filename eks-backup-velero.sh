#!/bin/bash

BUCKET_NAME="velero-backup2024"                               ### Provide the Name of the s3 bucket into which the backup to be taken
REGION="us-east-2"                                            ### Provide the AWS Region
USER_NAME="velero"
POLICY_NAME="velero"

######################################### Create IAM User and use it for velero backup ###################################################
aws iam create-user --user-name $USER_NAME

cat > velero-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET_NAME}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET_NAME}"
            ]
        }
    ]
}
EOF

aws iam put-user-policy --user-name $USER_NAME --policy-name $POLICY_NAME --policy-document file://velero-policy.json
aws iam create-access-key --user-name $USER_NAME > user.json


ACCESS_KEY_ID=`head -4 user.json|tail -1 |cut -d ":" -f2| sed 's/.$//'| tr -d ' '`                     ### Provide Access Key
SECRET_ACCESS_KEY=`head -6 user.json|tail -1 |cut -d ":" -f2| sed 's/.$//'| tr -d ' '`                 ### Provide Access Secret Key
echo -e "[default]\naws_access_key_id=$ACCESS_KEY_ID\naws_secret_access_key=$SECRET_ACCESS_KEY" > ./credentials-velero

####################### Create S3 Bucket and Enable encryption with AES256 ##########################
aws s3 mb s3://$BUCKET_NAME --region $REGION
aws s3api put-bucket-encryption --bucket $BUCKET_NAME --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"},"BucketKeyEnabled":true}]}'


##################################### Install velero cli ############################################
wget https://github.com/vmware-tanzu/velero/releases/download/v1.8.1/velero-v1.8.1-linux-amd64.tar.gz -P /opt
tar -xvf /opt/velero-v1.8.1-linux-amd64.tar.gz --directory /opt
mv /opt/velero-v1.8.1-linux-amd64/velero /usr/local/bin/


#################################### Install velero server component ################################
velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.4.0 --bucket $BUCKET_NAME --backup-location-config region=$REGION --snapshot-location-config region=$REGION --use-restic --secret-file ./credentials-velero

velero backup create demo    ### Take full backup of EKS cluster
sleep 10
velero backup get            ### List the velero back
