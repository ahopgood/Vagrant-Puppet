#!/usr/bin/env bash
# Function to run a manifest on a vagrant box with the --noop command
# 1) Takes snapshot based on arg $3 (vn_name) and arg $4 (snapshot_name)
# 2) SSH's into vagrant box on arg $1 (port) with manifest arg $2 (manifest name .pp)
# 3) Saves result to file and the results array arg $5
function run_manifest {
    # Add input checks for args 1, 2, 3, 4 & 5
    #variables
    port=$1
    manifest_name=$2
    vm_name=$3
    snapshot_name=$4
    iteration=$5


    echo "Working on VM ["$vm_name"] with snapshot ["$snapshot_name"] and testing with manifest "$manifest_name
    /usr/bin/ssh -p$port vagrant@localhost -i ~/.vagrant.d/insecure_private_key -o StrictHostKeyChecking=no 'sudo puppet apply /vagrant/tests/'$manifest_name' --noop --detailed-exitcodes' 2> $manifest_name"_"$vm_name"-errors.txt"
    #Save result to global array
    RESULTS_ARRAY[$iteration]=$manifest_name" "$vm_name" result ["$?"]"
    echo "Result in array "${RESULTS_ARRAY[$iteration]}
}

# Brings up vagrant box for specified profile, figures out the port, creates snapshot, iterates through list of manifests in the tests/ folder
function run_vm {
# Add input checking for args 1 & 2
    vm_name=$1
    vm_iterator=$2
    # Get VM Name
    snapshot_name="virgin"
    echo "Creating VM ["$vm_name"]"
    #Could add 1> /dev/null to sink output from vagrant elsewhere?
    vagrant up $vm_name

    #Bail out here if we get a failure
#    if [$?==0]:
#    exit $?;

    #Capture SSH port to use
    port=$(vagrant ssh-config $vm_name | grep Port | awk '{ print $2 }')

    #Just in case the port numbers have changed per server then the saved key signature will be wrong so purge
    ssh-keygen -f $HOME"/.ssh/known_hosts" -R [localhost]:$port

    #Take snapshot so we can work on a fresh OS per puppet manifest we apply
    vagrant snapshot save $vm_name virgin

    # Get list of manifests from the tests/ directory
    MANIFESTS=($(ls -m tests | tr "," " "))

    #Create a count based on the vm number / iterator multiplied by the total number of manifests we'll run so we can insert them in the results array correctly
    iterator=$((${#MANIFESTS[*]} * $vm_iterator))

    for ((i=0; i < "${#MANIFESTS[*]}"; i++));
    do
#        vagrant up $vm_name
#        port=$(vagrant ssh-config $vm_name | grep Port | awk '{ print $2 }')
#        ssh-keygen -f $HOME"/.ssh/known_hosts" -R [localhost]:$port

        run_manifest $port ${MANIFESTS[i]} $vm_name $snapshot_name $(($iterator + i))

        #Reset the snapshot
        echo "Restoring snapshot ["$snapshot_name"] on VM ["$vm_name"] after test run result ["${RESULTS_ARRAY[$(($iterator + i))]}"]"
        vagrant snapshot restore $vm_name virgin
        #vagrant destroy $vm_name -f
    done

    #Force vagrant to destroy the machine
    vagrant destroy $vm_name -f
}

# Enters the specified module folder and runs the vm for the Vagrant file contained there
function run_module {
    ORIGINAL_DIR=$(pwd)
    cd $1
    echo "In run_module for $1... "$(pwd)
    VMs=($(vagrant status | grep -E "*test" | awk '{ print $1 }'))
    if [ ! -z $2 ];then
        VMs=($2)
        echo "Using specific vagrant profile $2"
    fi
    #Handle vagrant not being installed
    echo "Using Vagrant Profiles:"${VMs[@]}
    for ((j=0; j < "${#VMs[*]}"; j++));
    do
        echo "Starting run for "${VMs[j]}
        run_vm ${VMs[j]} j
    done
    cd $ORIGINAL_DIR
    #Need to move out of the current directory
    echo "Leaving module $1..."
}

declare -a RESULTS_ARRAY
echo "Working in vagrant directory "$(pwd)
#cd $1
#echo "Using module directory $1"

VAGRANT_PROFILE=""
MODULES=($(ls -m | tr "," " "))

while getopts m:p: FLAG; do
    case $FLAG in
        m)
            echo "Setting module path to ["$OPTARG"]"
            MODULES=($OPTARG)
        ;;
        p)
            echo "Setting the vagrant profile to ["$OPTARG"]"
            VAGRANT_PROFILE=$OPTARG
        ;;
        \?)
            echo "Unsupported parameter :$OPTARG"
        ;;
    esac
done
# -m <modulename> or -p "<modulename1 modulename2>" the name of the module to run against, this is relative to the execution location of the script, optional argument, defaults to pwd (present working directory).
# -p <vagrant profile name> the name of the vagrant profile for your virtual machine, using the define keyword in vagrant, optional argument, defaults to all VM profiles returned by the vagrant status command

echo "Module list [${#MODULES[*]} modules]:"

for ((k = 0; k < "${#MODULES[*]}"; k++));
do
    if [ -d ${MODULES[k]} ];then
        echo "${MODULES[k]}"
        run_module ${MODULES[k]} $VAGRANT_PROFILE
#        echo "exit status $?"
    fi
#    run_module "tomcat"
    echo "exiting ${MODULES[k]}"
done
#Get list of VMs from vagrant file that end in _test
echo "Test results:"
echo ${RESULTS_ARRAY[@]}
