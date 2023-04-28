#!/bin/bash

# inputs
# - BUCKET_NAME
# - SOURCE

# Set the S3 bucket name and directory path
S3_BUCKET_NAME=${BUCKET_NAME}
S3_DIRECTORY_PATH=CACHE_DIRECTORY/
PREFIXS=${SOURCE}

# add trailing slash if not present
S3_DIRECTORY_PATH=${S3_DIRECTORY_PATH%/}/


for PRE in $PREFIXS; do
    # Fetch all directories in the S3 directory matching the prefix
    S3_DIRECTORY_NAMES=$(aws s3api list-objects-v2 \
        --bucket "$S3_BUCKET_NAME" \
        --prefix "$S3_DIRECTORY_PATH$PRE" \
        --delimiter / \
        --query 'CommonPrefixes[].Prefix' \
        --output text \
        --region us-east-1)

    if [[ "$S3_DIRECTORY_NAMES" != 'None' ]]; then
        break
    fi
done

# Remove any directories that don't have a "path.txt" file
VALID_DIRECTORIES=""
for DIR in $S3_DIRECTORY_NAMES; do
    OBJECT_SOURCE="$DIR""path.txt"
    exists=$(aws s3 ls "s3://$S3_BUCKET_NAME/$OBJECT_SOURCE" --region us-east-1)
    if [[ -n "$exists" ]]; then
        VALID_DIRECTORIES+="$DIR"$'\n'
    fi
done

S3_DIRECTORY_NAMES=$VALID_DIRECTORIES
# echo $S3_DIRECTORY_NAMES


if [[ "$S3_DIRECTORY_NAMES" = 'None' ]]; then
    S3_DIRECTORY_NAMES=""
fi

# Extract the directory names and timestamps
DIRECTORY_NAMES_AND_TIMESTAMPS=""
for DIRECTORY_NAME in $S3_DIRECTORY_NAMES; do
    DIRECTORY_NAME_WITHOUT_PREFIX="${DIRECTORY_NAME//$S3_DIRECTORY_PATH/}"
    DIRECTORY_NAME_WITHOUT_PREFIX_AND_TIMESTAMP=$(echo "$DIRECTORY_NAME_WITHOUT_PREFIX" | rev | cut -d'-' -f2- | rev)
    DIRECTORY_TIMESTAMP=$(echo "$DIRECTORY_NAME" | rev | cut -d'-' -f1 | rev)
    DIRECTORY_NAMES_AND_TIMESTAMPS+="$DIRECTORY_NAME_WITHOUT_PREFIX_AND_TIMESTAMP $DIRECTORY_TIMESTAMP"$'\n'
done

# Find the latest directory timestamp
LATEST_DIRECTORY_TIMESTAMP=$(echo "$DIRECTORY_NAMES_AND_TIMESTAMPS" | sort -k2 -r | head -n1 | awk '{print $2}')

# Find the directory name with the latest timestamp
LATEST_DIRECTORY_NAME=$(echo "$DIRECTORY_NAMES_AND_TIMESTAMPS" | grep "$LATEST_DIRECTORY_TIMESTAMP$" | awk '{print $1}')

RESULT=$LATEST_DIRECTORY_NAME-$LATEST_DIRECTORY_TIMESTAMP

# save path.txt value to a variable named RESULT_PATH
url="s3://$S3_BUCKET_NAME/$S3_DIRECTORY_PATH$RESULT""path.txt"
RESULT_PATH=$(aws s3 cp "$url" -)

# download $RESULT in $RESULT_PATH
if [[ -n "$DIR" ]];
then
    aws s3 cp s3://"$S3_BUCKET_NAME"/$S3_DIRECTORY_PATH"$RESULT" "$DIR" --recursive
else
    aws s3 cp s3://"$S3_BUCKET_NAME"/$S3_DIRECTORY_PATH"$RESULT" "$RESULT_PATH" --recursive
fi