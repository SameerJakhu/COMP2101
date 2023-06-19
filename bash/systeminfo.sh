#!/bin/bash
# I have found out by error fixing that the script is executable by the command sudo bash systeminfo.sh
# Import the function library
source reportfunctions.sh

# Function for error message handling
function errormessage {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="$timestamp: $1"

    echo "$message" >&2

    if [[ $VERBOSE == true ]]; then
        echo "$message"
    fi

    echo "$message" >> /var/log/systeminfo.log
}

# Function to display help information
function display_help {
    echo "Usage: systeminfo.sh [OPTIONS]"
    echo "Options:"
    echo "  -h        Display help information"
    echo "  -v        Run verbosely, showing errors to the user instead of logging"
    echo "  -system   Run only computerreport, osreport, cpureport, ramreport, and videoreport"
    echo "  -disk     Run only diskreport"
    echo "  -network  Run only networkreport"
    echo
}

# Check for root permission
if [[ $EUID -ne 0 ]]; then
    errormessage "This script must be run as root"
    exit 1
fi

# Parse command line options
VERBOSE=false
RUN_ALL=true
RUN_SYSTEM=false
RUN_DISK=false
RUN_NETWORK=false

while getopts ":hvsdnu" opt; do
    case $opt in
        h)
            display_help
            exit 0
            ;;
        v)
            VERBOSE=true
            ;;
        s)
            RUN_ALL=false
            RUN_SYSTEM=true
            ;;
        d)
            RUN_ALL=false
            RUN_DISK=true
            ;;
        n)
            RUN_ALL=false
            RUN_NETWORK=true
            ;;
        u)
            RUN_ALL=true
            ;;
        \?)
            errormessage "Invalid option: -$OPTARG"
            display_help
            exit 1
            ;;
    esac
done

# Run the reports based on the command line options
if [[ $RUN_ALL == true || $RUN_SYSTEM == true ]]; then
    computerreport || errormessage "Failed to generate computer report"
    osreport || errormessage "Failed to generate OS report"
    cpureport || errormessage "Failed to generate CPU report"
    ramreport || errormessage "Failed to generate RAM report"
    videoreport || errormessage "Failed to generate video report"
fi

if [[ $RUN_ALL == true || $RUN_DISK == true ]]; then
    diskreport || errormessage "Failed to generate disk report"
fi

if [[ $RUN_ALL == true || $RUN_NETWORK == true ]]; then
    networkreport || errormessage "Failed to generate network report"
fi
