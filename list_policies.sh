#!/bin/bash

# Check correct usage of the script
if [ $# -ne 2 ]; then
  echo -e "\nWrong usage! Script must have 2 arguments. (you provided $#)"
  echo -e "Usage:\n   ./list_policies.sh info_type output_file"
  echo -e "Where:\n   info_type - which info to retrieve:"
  echo -e "      'all' - everything\n      'arn' - only arn\n      'arn-tags' - arn's only + Tags for each policy in separate file ($2_Tags)"
  echo -e "   output_file - the file where the list will be saved to"
  exit 1
fi

if [ $1 = "all" ]; then
  echo -e "\nGathering ALL the info for Local Policies..."
  aws iam list-policies --scope Local --output text > $2
elif [ $1 = "arn" ]; then
  echo -e "\nGathering only the Arn's for Local Policies..."
  aws iam list-policies --scope Local --query "Policies[].Arn" --output text > $2
elif [ $1 = "arn-tags" ]; then
  echo -e "\nGathering only the Arn's for Local Policies..."
  aws iam list-policies --scope Local --query "Policies[].Arn" --output text > $2  
  echo -e "Done.\nGathering the Tags per policy..."
  for policy in $(cat $2)
  do
    echo -e "\033[2K ARN: ${policy}..."
    aws iam get-policy --policy-arn ${policy} --query "Policy.[AttachmentCount,Arn,Tags]" --output text >> $2_tags.txt
  done
  echo -e "Done."
else
  echo -e "\nWrong 'info_type'!\nOptions: 'all' - everything, 'arn' - only arn'."
  exit 1
fi
echo -e "\nTask is complete. The requested list is inside: $2."

