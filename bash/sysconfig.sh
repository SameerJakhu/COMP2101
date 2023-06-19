#!/bin/bash
# this script displays system information

##############
# FUNCTIONS
##############
# This function will send an error message to stderr
# Usage:
#   error-message ["some text to print to stderr"]
function error-message {
    echo "$@" >&2
}

# This function will send a message to stderr and exit with a failure status
# Usage:
#   error-exit ["some text to print to stderr" [exit-status]]
function error-exit {
    error-message "$1"
    exit "${2:-1}"
}

# This function displays help information if the user asks for it on the command line or gives us a bad command line
function displayhelp {
    echo "Help information:"
    # Add your help text here
    echo "..."
}

# This function will remove all the temp files created by the script
# The temp files are all named similarly, "/tmp/somethinginfo.$$"
# A trap command is used after the function definition to specify this function is to be run if we get a ^C while running
function cleanup {
    rm /tmp/*info.$$
}

# Trap handler for INT signal (Ctrl+C)
function handle_interrupt {
    echo "Interrupt received. Cleaning up..."
    cleanup
    exit 0
}

##############
# MAIN SCRIPT
##############

# Attach the interrupt handler to the INT signal
trap handle_interrupt INT

# process command line options
partialreport=
while [ $# -gt 0 ]; do
    case "$1" in
        -h|--help)
            displayhelp
            exit
            ;;
        --host)
            hostnamewanted=true
            partialreport=true
            ;;
        --domain)
            domainnamewanted=true
            partialreport=true
            ;;
        --ipconfig)
            ipinfowanted=true
            partialreport=true
            ;;
        --os)
            osinfowanted=true
            partialreport=true
            ;;
        --cpu)
            cpuinfowanted=true
            partialreport=true
            ;;
        --memory)
            memoryinfowanted=true
            partialreport=true
            ;;
        --disk)
            diskinfowanted=true
            partialreport=true
            ;;
        --printer)
            printerinfowanted=true
            partialreport=true
            ;;
        *)
            error-exit "$1 is invalid"
            ;;
    esac
    shift
done

# gather data into temporary files to reduce time spent running lshw
sudo lshw -class system >/tmp/sysinfo.$$ 2>/dev/null
sudo lshw -class memory >/tmp/memoryinfo.$$ 2>/dev/null
sudo lshw -class bus >/tmp/businfo.$$ 2>/dev/null
sudo lshw -class cpu >/tmp/cpuinfo.$$ 2>/dev/null

# Rest of the script...
# (The code after the trap command is not included here for brevity)

# cleanup temporary files
cleanup
