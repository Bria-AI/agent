#!/bin/bash

# Function to install azcopy if not already installed
install_az_cli() {
    if ! command -v az &>/dev/null; then
        echo "az cli is not installed. Installing..."
        curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    fi
}

# Function to display script usage
usage() {
    echo "Usage: $0 -g <RESOURCE_GROUP_NAME> -n <FUNCTION_NAME> -z <ZIP_FILE>"
    echo "Example: $0 -g <RESOURCE_GROUP_NAME> -n <FUNCTION_NAME> -z <ZIP_FILE>"
    exit 1
}

# Function to handle errors and cleanup
handle_error() {
    local error_message=$1
    echo "Error: $error_message"
    exit 1
}

# Function to perform the blob copy operation
deploy_func() {
    local RESOURCE_GROUP_NAME=$1
    local FUNCTION_NAME=$2
    local ZIP_FILE=$3

    azFunctionDeploy="az functionapp deployment source config-zip --resource-group $RESOURCE_GROUP_NAME --name $FUNCTION_NAME --src $ZIP_FILE  --build-remote true --verbose"
    echo "$azFunctionDeploy"

    # Perform the blob copy operation using azcopy
    if ! $azFunctionDeploy; then
        handle_error "Function $FUNCTION_NAME Deployment failed"
    fi

}

# Parse command line options
while getopts ":g:n:z:h" opt; do
    case ${opt} in
        g)
            RESOURCE_GROUP_NAME=${OPTARG}
            ;;
        n)
            FUNCTION_NAME=${OPTARG}
            ;;
        z)
            ZIP_FILE=${OPTARG}
            ;;
        h | *)
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if all required parameters are provided
if [[ -z $RESOURCE_GROUP_NAME || -z $FUNCTION_NAME || -z $ZIP_FILE  ]]; then
    handle_error "Missing required parameters."
fi

# Install azcopy
install_az_cli

# Copy blobs
deploy_func "$RESOURCE_GROUP_NAME" "$FUNCTION_NAME" "$ZIP_FILE"
