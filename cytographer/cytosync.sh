#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'


bucketPrefix="s3://dev-immunoscape-cytographer"
s3folder="origin"
dryrun="--dryrun"
echo "A script to sync local folder to Cytographer's S3 bucket"
mode="${YELLOW}DEVELOPMENT${NC} mode"

# -p = production
# -r = run, no dryrun
while getopts 'pr' flag; do
    case "${flag}" in
        p) mode="${RED}PRODUCTION${NC} mode"
            bucketPrefix="s3://immunoscape-cytographer";;
        r) echo "No dry run"
            dryrun="" ;;
    esac
done
printf "${mode}\n"
printf "dryrun: ${dryrun}\n"

# A script to sync local folder to cytographer's S3 bucket
echo "Enter Cytographer Project ID (e.g. 10): "
read projectId
pwd=`pwd`
echo "Full path of local folder to sync (leave blank for default: $pwd): "
read dir
dir="${dir:-`pwd`}"
echo "AWS profile (leave blank for default: immunoscape)"
read profile
s3dir=$bucketPrefix-$projectId/$s3folder
profile="${profile:-immunoscape}"
command="aws s3 sync $dir $s3dir  --profile=$profile ${dryrun}"

echo ""
echo "Please check the configurations once again. The following locations will be sync-ed."
printf "Dev/prod mode \t: ${mode} \n"
printf "S3 dry run? \t: ${dryrun} \n"
printf "S3 Bucket \t: ${s3dir} \n"
printf "local dir \t: ${dir} \n"
printf "AWS Profile \t: ${profile} \n"
printf "AWS CLI \t: ${GREEN}${command}${NC} \n"
echo ""
echo "Start sync by pressing 'Y/y' + enter: "
read confirm

if [ "$confirm" == "Y" ] || [ "$confirm" == "y" ] ; then
    echo ""
    echo "Sync-ing..."
    eval $command
else
    echo "Aborting"
fi
