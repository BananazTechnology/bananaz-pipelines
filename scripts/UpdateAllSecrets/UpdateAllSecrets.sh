#!/bin/bash
# Variables for runtime
GH_ORG=BananazTechnology
TMP_FOLDER=tmp
mkdir -p ${TMP_FOLDER}
REPO_TMP_FILE=${TMP_FOLDER}/repos.txt
ENC_LIB=EncryptData.py
REQUEST_HEADERS_FILE=request_secrets
PIPELINE_SECRETS_FILE=pipeline_secrets
WAS_ERROR=false
LAST_ERROR_LOG=""
ERROR_COUNT=0
DEBUG=${DEBUG:-false}

# Get initial list of repos
REPO_URL="https://api.github.com/orgs/${GH_ORG}/repos?per_page=75&sort=updated&direction=desc"
REPOS_JSON=$(curl -s -X GET -H @${REQUEST_HEADERS_FILE} ${REPO_URL})
# Get the number of repos
REPO_COUNT=$(echo ${REPOS_JSON} | jq '. | length')
# Startup debug statement
if [ "${DEBUG}" = true ]; then
    echo "Found ${REPO_COUNT} repos"
fi
WRITE_REPOS=$(echo ${REPOS_JSON} | jq -r '.[].name' > ${REPO_TMP_FILE})
# Loop through the repos
while read REPO; do
    # Reading repo debug statement
    if [ "${DEBUG}" = true ]; then
        echo "Updating secrets for ${REPO}"
    fi
    # Get the repo public key
    SECRET_KEY_URL="https://api.github.com/repos/${GH_ORG}/${REPO}/actions/secrets/public-key"
    SECRET_ENC_KEY_JSON=$(curl -s -X GET -H @${REQUEST_HEADERS_FILE} ${SECRET_KEY_URL})
    # Get the repo public key id
    SECRET_KEY_ID=$(echo ${SECRET_ENC_KEY_JSON} | jq -r '.key_id')
    # Get the repo public key
    SECRET_ENC_KEY=$(echo ${SECRET_ENC_KEY_JSON} | jq -r '.key')
    # Read the pipeline secrets file
    while read SECRET; do
        [ -n "${SECRET}" ] && {
            # Get the secret name
            SECRET_NAME=$(echo ${SECRET} | cut -d'=' -f1)
            # Get the secret value
            SECRET_VALUE=$(echo ${SECRET} | cut -d'=' -f2)
            # Encrypt the secret value
            ENCRYPTED_SECRET=$(python3 ${ENC_LIB} -d "${SECRET_VALUE}" -k "${SECRET_ENC_KEY}")
            # Update the secret
            SECRET_UPDATE_URL="https://api.github.com/repos/${GH_ORG}/${REPO}/actions/secrets/${SECRET_NAME}"
            SECRET_UPDATE_BODY="{\"key_id\":\"${SECRET_KEY_ID}\",\"encrypted_value\":\"${ENCRYPTED_SECRET}\"}"
            LAST_ERROR_LOG="${TMP_FOLDER}/${GH_ORG}.${REPO}.${SECRET_NAME}.error.log"
            SECRET_RESPONSE_CODE=$(curl -o "${LAST_ERROR_LOG}" -w "%{http_code}" -s -X PUT -H @${REQUEST_HEADERS_FILE} -d ${SECRET_UPDATE_BODY} ${SECRET_UPDATE_URL})
            # if string response code is not 204 or 201 then error occured
            if [ "${SECRET_RESPONSE_CODE}" != "204" ] && [ "${SECRET_RESPONSE_CODE}" != "201" ]; then
                WAS_ERROR=true
                ERROR_COUNT=$((ERROR_COUNT+1))
            fi
            # Log finish msg
            if [ "${DEBUG}" = true ]; then
                echo "Finished updating ${SECRET_NAME} for ${REPO}"
            fi
        }
    done < ${PIPELINE_SECRETS_FILE}
done < ${REPO_TMP_FILE}
# Cleanup
# If WAS_ERROR boolean is true then exit with error code
# If error occured then print error log
if [ "${WAS_ERROR}" = true ]; then
    echo "Error occured while updating secrets"
    echo "Error count: ${ERROR_COUNT}"
    echo "Error log:"
    cat ${LAST_ERROR_LOG}
    exit ${ERROR_COUNT}
# Else delete tmp dir
else
    rm -rf ${TMP_FOLDER}
fi