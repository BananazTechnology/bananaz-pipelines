#!/bin/bash
# Variables for runtime
GH_ORG=BananazTechnology
TMP_FOLDER=tmp
mkdir -p ${TMP_FOLDER}
REPO_TMP_FILE=${TMP_FOLDER}/repos.txt
ENC_LIB=EncryptData.py
REQUEST_HEADERS_FILE=request-secrets
PIPELINE_SECRETS_FILE=pipeline-secrets

# Get initial list of repos
REPO_URL="https://api.github.com/orgs/${GH_ORG}/repos?per_page=75&sort=updated&direction=desc"
REPOS_JSON=$(curl -s -X GET -H @${REQUEST_HEADERS_FILE} ${REPO_URL})
# Get the number of repos
REPO_COUNT=$(echo ${REPOS_JSON} | jq '. | length')
echo "Found ${REPO_COUNT} repos"
WRITE_REPOS=$(echo ${REPOS_JSON} | jq -r '.[].name' > ${REPO_TMP_FILE})
# Loop through the repos
while read REPO; do
    echo "Updating secrets for ${REPO}"
    # Get the repo public key
    SECRET_KEY_URL="https://api.github.com/repos/${GH_ORG}/${REPO}/actions/secrets/public-key"
    SECRET_ENC_KEY_JSON=$(curl -s -X GET -H @${REQUEST_HEADERS_FILE} ${SECRET_KEY_URL})
    # Get the repo public key id
    SECRET_KEY_ID=$(echo ${SECRET_ENC_KEY_JSON} | jq -r '.key_id')
    # Get the repo public key
    SECRET_ENC_KEY=$(echo ${SECRET_ENC_KEY_JSON} | jq -r '.key')
    # Read the pipeline secrets file
    while read SECRET; do
        # Get the secret name
        SECRET_NAME=$(echo ${SECRET} | cut -d'=' -f1)
        # Get the secret value
        SECRET_VALUE=$(echo ${SECRET} | cut -d'=' -f2)
        # Encrypt the secret value
        ENCRYPTED_SECRET=$(python3 ${ENC_LIB} -d "${SECRET_VALUE}" -k "${SECRET_ENC_KEY}")
        # Update the secret
        SECRET_UPDATE_URL="https://api.github.com/repos/${GH_ORG}/${REPO}/actions/secrets/${SECRET_NAME}"
        SECRET_UPDATE_BODY="{\"key_id\":\"${SECRET_KEY_ID}\",\"encrypted_value\":\"${ENCYPTED_SECRET}\"}"
        SECRET_RESPONSE=$(curl -s -X PUT -H @${REQUEST_HEADERS_FILE} -d ${SECRET_UPDATE_BODY} ${SECRET_UPDATE_URL})
    done < ${PIPELINE_SECRETS_FILE}
done < ${REPO_TMP_FILE}
# Remove tmp folder
rm -rf ${TMP_FOLDER}