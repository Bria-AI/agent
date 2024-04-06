#!/bin/bash

# Function to install azcopy if not already installed
install_azcopy() {
    if ! command -v azcopy &>/dev/null; then
        echo "azcopy is not installed. Installing..."
        wget -O azcopy.tar.gz https://aka.ms/downloadazcopy-v10-linux
        tar -xvf azcopy.tar.gz --strip-components=1 --wildcards '*/azcopy'
        chmod +x azcopy
        sudo mv azcopy /usr/local/bin/
        rm azcopy.tar.gz
    fi
}

# Function to display script usage
usage() {
    echo "Usage: $0 -c <SPN_CLIENT_ID> -p <SPN_PASSWORD> -t <TENANT_ID> -a <SAS_TOKEN> -n <SOURCE_STORAGE_ACCOUNT_NAME> -d <DESTINATION_STORAGE_ACCOUNT_NAME> -x <SRC_CONTAINER_NAME> -y <DESTINATION_CONTAINER_NAME>"
    echo "Example: $0 -c <SPN_CLIENT_ID> -p <SPN_PASSWORD> -t <TENANT_ID> -a <SAS_TOKEN> -n source_storage_account -d destination_storage_account -x src_container -y dest_container"
    exit 1
}

# Function to handle errors and cleanup
handle_error() {
    local error_message=$1
    echo "Error: $error_message"
    # Remove azcopy if it was installed during the script execution
    if command -v azcopy &>/dev/null; then
        sudo rm /usr/local/bin/azcopy
    fi
    exit 1
}

# Function to perform the blob copy operation
copy_blobs() {
    local SPN_CLIENT_ID=$1
    local SPN_PASSWORD=$2
    local TENANT_ID=$3
    local SUBSCRIPTION_ID=$4
    local SAS_TOKEN=$5
    local SOURCE_STORAGE_ACCOUNT_NAME=$6
    local DESTINATION_STORAGE_ACCOUNT_NAME=$7
    local SRC_CONTAINER_NAME=$8
    local DESTINATION_CONTAINER_NAME=$9

#    random=$RANDOM
#    mkdir -p /tmp/$random/az_profile
#    export AZURE_CONFIG_DIR=/tmp/$random/az_profile
#    echo $AZURE_CONFIG_DIR
    export AZCOPY_SPA_CLIENT_SECRET="$SPN_PASSWORD"


    # Login to the Azure account using service principal
    if ! azcopy login --service-principal --application-id "$SPN_CLIENT_ID" --tenant-id "$TENANT_ID"; then
        handle_error "Azure login failed. Please check your credentials."
    fi

    # Set the source and destination endpoints
    SOURCE_ENDPOINT="https://${SOURCE_STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${SRC_CONTAINER_NAME}"
    DESTINATION_ENDPOINT="https://${DESTINATION_STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${DESTINATION_CONTAINER_NAME}"
    azCopyCommand="azcopy copy $SOURCE_ENDPOINT/* $DESTINATION_ENDPOINT/$SAS_TOKEN --recursive"
    echo "$azCopyCommand"

    # Perform the blob copy operation using azcopy
    if ! $azCopyCommand; then
        handle_error "Blob copy operation failed."
    fi

    # Logout from Azure account
    azcopy logout
#    unset AZURE_CONFIG_DIR
    unset AZCOPY_SPA_CLIENT_SECRET
}

# Parse command line options
while getopts ":c:p:t:a:n:d:x:y:h" opt; do
    case ${opt} in
        c)
            SPN_CLIENT_ID=${OPTARG}
            ;;
        p)
            SPN_PASSWORD=${OPTARG}
            ;;
        t)
            TENANT_ID=${OPTARG}
            ;;
        a)
            SAS_TOKEN=${OPTARG}
            ;;
        n)
            SOURCE_STORAGE_ACCOUNT_NAME=${OPTARG}
            ;;
        d)
            DESTINATION_STORAGE_ACCOUNT_NAME=${OPTARG}
            ;;
        x)
            SRC_CONTAINER_NAME=${OPTARG}
            ;;
        y)
            DESTINATION_CONTAINER_NAME=${OPTARG}
            ;;
        h | *)
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if all required parameters are provided
if [[ -z $SPN_CLIENT_ID || -z $SPN_PASSWORD || -z $TENANT_ID || -z $SAS_TOKEN || -z $SOURCE_STORAGE_ACCOUNT_NAME || -z $DESTINATION_STORAGE_ACCOUNT_NAME || -z $SRC_CONTAINER_NAME || -z $DESTINATION_CONTAINER_NAME ]]; then
    handle_error "Missing required parameters."
fi

# Install azcopy
install_azcopy

# Copy blobs
copy_blobs "$SPN_CLIENT_ID" "$SPN_PASSWORD" "$TENANT_ID" "$SUBSCRIPTION_ID" "$SAS_TOKEN" "$SOURCE_STORAGE_ACCOUNT_NAME" "$DESTINATION_STORAGE_ACCOUNT_NAME" "$SRC_CONTAINER_NAME" "$DESTINATION_CONTAINER_NAME"

# Remove azcopy if it was installed during the script execution
if command -v azcopy &>/dev/null; then
    sudo rm /usr/local/bin/azcopy
fi