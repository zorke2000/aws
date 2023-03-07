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
  i = 1
  for policy in $(cat $2)
  do
    # The CSI (control sequence introducer) at the end of the echo below ('\033[0K'), is used to
    # erases the text from the cursor to the end of the line; '\r' – carriage return.
    echo -ne " Policy #$i: ${policy}...\033[0K\r"
    aws iam get-policy --policy-arn ${policy} --query "Policy.[AttachmentCount,Arn,Tags]" --output text >> $2_tags.txt
    ((i++))
  done
  echo -ne "Done. Total of $i policies were read.\033[0K\r"
else
  echo -e "\nWrong 'info_type'!\nOptions: 'all' - everything, 'arn' - only arn'."
  exit 1
fi

echo -e "\nTask is complete. The requested list is inside: $2."
