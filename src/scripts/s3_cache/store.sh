#!/bin/bash

# inputs
# - BUCKET_NAME
# - SOURCE
# - DIR

# Set the S3 bucket name and directory path
S3_BUCKET_NAME=${BUCKET_NAME}
S3_DIRECTORY_PATH=CACHE_DIRECTORY/

# add trailing slash if not present
S3_DIRECTORY_PATH=${S3_DIRECTORY_PATH%/}/

# Set the prefix to search for (e.g. "source1-source2")
# SOURCE=${SOURCE}
PATH_=${DIR}

# check if path exists
if [ ! -e "${PATH_}" ]; then
  echo "${PATH_}" does not exist.
  exit 0
fi

# echo current timestamp
timestamp=$(date +%s)

# remove hyphen at the ending of SOURCE if exists
SOURCE=${SOURCE%-}

# check if $SOURCE-- exists in s3 directory
if aws s3 ls s3://"${S3_BUCKET_NAME}"/${S3_DIRECTORY_PATH}"${SOURCE}"--*; then
  echo "${SOURCE}"--* exists in s3.
  exit 0
fi

# SOURCE with timestamp
KEY_TIMESTAMP=${SOURCE}--${timestamp}

echo s3://"${S3_BUCKET_NAME}"/${S3_DIRECTORY_PATH}"${KEY_TIMESTAMP}"

# upload path directory to s3
aws s3 cp "${PATH_}" s3://"${S3_BUCKET_NAME}"/${S3_DIRECTORY_PATH}"${KEY_TIMESTAMP}"/ --recursive

# upload path to s3
echo "${PATH_}" | aws s3 cp - s3://"${S3_BUCKET_NAME}"/${S3_DIRECTORY_PATH}"${KEY_TIMESTAMP}"/path.txt







