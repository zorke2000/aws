#!/bin/bash

# Check correct usage of the script
if [ $# -ne 2 ]; then
  echo -e "\nWrong usage! Script must have 2 argument. (you provided $#)"
  echo -e "Usage:\n   ./remove_policies.sh input_file output_file"
  echo -e "Where:\n   input_file - the text file where policies arn's are stored, one arn per line"
  echo -e "   output_file - the file where the logs will be written to"
  exit 1
else
  # args from user
  echo "inside else"
  input_file=$1
  out_file=$2
fi

clear
# Prompt an alert & verify the user wishes to proceed with the removal...
printf "\n\033[31m!!! NOTICE !!!\nThis script is about to remove AWS Policies! Be EXTRA carefull...\033[0m"
printf "\nAre you sure you want to proceed with this? ('Yes' to continue) > "
read choice
if [ $choice != "Yes" ]; then
  printf "*** Operation aborted by user (nothing was removed) ***\n"
  exit 0
fi

# File containing the list of policy ARNs, one per line
policy_arns_file=$input_file

printf "\n*** Starting to remove un-needed AWS policies... ***" | tee -a $out_file

# an index to count number of policies removed
total_policies=0
policies_removed=0

# Read the policy ARNs from the file
while read arn; do
  printf "\ntrying to remove: $arn..." | tee -a $out_file
  aws iam delete-policy --policy-arn $arn 
  if [ $? -ne 0 ]; then
    printf " \033[31m NOT removed!\033[0m" | tee -a $out_file
  else
    printf " \033[32m removed!\033[0m" | tee -a $out_file
    let policies_removed++
  fi
  let total_policies++
done < "$policy_arns_file"

printf "\n*** Operation complete! ***" | tee -a $out_file
printf "\nInfo:\n  Total policies read from file: $total_policies" | tee -a $out_file
printf "\n  Total policies removed: $policies_removed" | tee -a $out_file
printf "\n(you can find the log also in file: $2)" | tee -a $out_file
