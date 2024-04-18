#!/bin/bash

# Function to install azcopy if not already installed
install_packages() {
    if ! command -v git &>/dev/null; then
        echo "git is not installed. Installing..."
        if [[ $(uname) == "Darwin" ]]; then
            brew install git
        elif [[ $(uname) == "Linux" ]]; then
            sudo apt update -y
            sudo apt install git -y
        else
            echo "Unsupported operating system."
            exit 1
        fi
    fi
}

# Function to display script usage
usage() {
    echo "Usage: $0 -u <GIT_URL> -d <DESTINATION>"
    echo "Example: $0 -u <GIT_URL> -d <DESTINATION>"
    exit 1
}

# Function to handle errors and cleanup
handle_error() {
    local error_message=$1
    echo "Error: $error_message"
    exit 1
}

# Function to perform the blob copy operation
git_clone() {
    local GIT_URL=$1
    local DESTINATION=$2

    if [ -e "$DESTINATION" ]; then
        rm -fr "$DESTINATION"
    fi

    gitCloneCommand="git clone $GIT_URL $DESTINATION"
    echo "$gitCloneCommand"

    # Perform the blob copy operation using git
    if ! $gitCloneCommand; then
        handle_error "Git clone failed"
    fi

}

# Parse command line options
while getopts ":u:d:h" opt; do
    case ${opt} in
        u)
            GIT_URL=${OPTARG}
            ;;
        d)
            DESTINATION=${OPTARG}
            ;;
        h | *)
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if all required parameters are provided
if [[ -z $GIT_URL || -z $DESTINATION ]]; then
    handle_error "Missing required parameters."
fi

# Install git if needed
install_packages

# Copy blobs
git_clone "$GIT_URL" "$DESTINATION"
