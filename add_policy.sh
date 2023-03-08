#!/bin/bash

# This script is used for TESTING PURPOSES only!!!
# Purpose: to add a temp policy

# Check correct usage of the script
if [ $# -ne 1 ]; then
  echo -e "\nWrong usage! Script must have 1 argument. (you provided $#)"
  echo -e "Usage:\n   ./add_policies.sh policy_name"
  echo -e "Where:\n   policy_name - the name of the new TEST policy to be added to AWS"
  exit 1
else
  policy_name=$1
fi

# Create a policy document in JSON format
policy_document='{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::my-bucket"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::my-bucket/*"
        }
    ]
}'

# Create the policy
aws iam create-policy --policy-name $policy_name --policy-document "$policy_document"

