#!/bin/bash

# If DEBUG is true
if [ "$DEBUG" = true ]; then
    # Print the command before executing it
    set -x
fi

# Setup environment variables
FOLDER_OF_ITEMS_TO_UPLOAD=$2
ORACLE_BUCKET_NAME=$1
ORACLE_BUCKET_NAMESPACE="idqd9f17v1z5"

# Verify FOLDER_OF_ITEMS_TO_UPLOAD was provided
if [ -z "$FOLDER_OF_ITEMS_TO_UPLOAD" ]; then
    echo "A param of folder location is required"
    exit 1
fi
# Verify the folder in FOLDER_OF_ITEMS_TO_UPLOAD exists
if [ ! -d "$FOLDER_OF_ITEMS_TO_UPLOAD" ]; then
    echo "The folder $FOLDER_OF_ITEMS_TO_UPLOAD does not exist"
    exit 1
fi
# Count the files in the directory
NUMBER_OF_FILES=$(ls -1q "$FOLDER_OF_ITEMS_TO_UPLOAD" | wc -l)
# Verify there are files in the directory
if [ "$NUMBER_OF_FILES" -eq 0 ]; then
    echo "The folder $FOLDER_OF_ITEMS_TO_UPLOAD does not contain any files"
    exit 1
fi

# Loop through files in FOLDER_OF_ITEMS_TO_UPLOAD
for FILE in "$FOLDER_OF_ITEMS_TO_UPLOAD"/*; do
    oci os object put \
        --namespace $ORACLE_BUCKET_NAMESPACE \
        --bucket-name $ORACLE_BUCKET_NAME \
        --file "$FILE" \
        --no-multipart \
        --force
done