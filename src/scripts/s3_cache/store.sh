#!/bin/bash

# inputs
# - BUCKET_NAME
# - KEY
# - DIR

# Set the S3 bucket name and directory path
S3_BUCKET_NAME=${BUCKET_NAME}
S3_DIRECTORY_PATH=dl_key_cache/

# add trailing slash if not present
S3_DIRECTORY_PATH=${S3_DIRECTORY_PATH%/}/

# Set the prefix to search for (e.g. "key1-key2")
KEY=${KEY}
PATH_=${DIR}

# remove / at the ending of PATH_ if exists
PATH_=${PATH_%/}

# check if path exists
if [ ! -d ${PATH_} ]; then
  echo ${PATH_} does not exist.
  exit 0
fi

# echo current timestamp
timestamp=$(date +%s)

# remove hyphen at the ending of key if exists
KEY=${KEY%-}

# key with timestamp
KEY_TIMESTAMP=${KEY}--${timestamp}

echo s3://${S3_BUCKET_NAME}/${S3_DIRECTORY_PATH}${KEY_TIMESTAMP}

# upload path directory to s3
aws s3 cp ${PATH_} s3://${S3_BUCKET_NAME}/${S3_DIRECTORY_PATH}${KEY_TIMESTAMP}/ --recursive

# upload path to s3
echo ${PATH_} | aws s3 cp - s3://${S3_BUCKET_NAME}/${S3_DIRECTORY_PATH}${KEY_TIMESTAMP}/path.txt







