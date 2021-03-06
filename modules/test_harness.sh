#!/usr/bin/env bash

#function to remove a grep regex pattern from an input file
function remove_warning(){
    grep -v "$1" $OUTPUT_FILE > $OUTPUT_FILE".mod"
    mv $OUTPUT_FILE".mod" $OUTPUT_FILE
}
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

    RUN_MANIFEST_PREFIX=$PREFIX"\e[32mrun_manifest: \e[39m"

    echo -e $RUN_MANIFEST_PREFIX"Working on VM ["$vm_name"] with snapshot ["$snapshot_name"] and testing with manifest "$manifest_name
    /usr/bin/ssh -p$port vagrant@localhost -i ~/.vagrant.d/insecure_private_key -o StrictHostKeyChecking=no 'sudo puppet apply --parser=future /vagrant/tests/'$manifest_name' --detailed-exitcodes' 2> $manifest_name"_"$vm_name"-errors.txt"
    RESULT=$?
    # Save result to global array
    OUTPUT_FILE=$manifest_name"_"$vm_name"-errors-"$RESULT".txt"
    echo -e $RUN_MANIFEST_PREFIX"Renaming error file to reflect exit code "$OUTPUT_FILE
    mv $manifest_name"_"$vm_name"-errors.txt" $OUTPUT_FILE

    #Check for benign "known" warnings and errors and remove from file
    remove_warning "Warning: Config file /etc/puppet/hiera.yaml not found, using Hiera defaults"
    remove_warning "Warning: Permanently added '\[localhost\]:[0-9]\{4\}' (RSA\|ECDSA) to the list of known hosts."
    remove_warning "Warning: alias is a metaparam; this value will inherit to all contained resources in the [a-zA-Z:_]* definition"
    remove_warning "Warning: You cannot collect exported resources without storeconfigs being set; the collection will be ignored on line [0-9]* in file [a-zA-Z/]*.pp"
    remove_warning "Warning: You cannot collect exported resources without storeconfigs being set; the collection will be ignored at [a-zA-Z/]*.pp:[0-9]*:"

    remove_warning "Warning: Not collecting exported resources without storeconfigs"
    remove_warning "Warning: The package type's allow_virtual parameter will be changing its default value from false to true in a future release. If you do not want to allow virtual packages, please explicitly set allow_virtual to false."
    remove_warning "   (at /usr/lib/ruby/site_ruby/1.8/puppet/type/package.rb:430:in \`default')"
    remove_warning "   (at /usr/share/ruby/vendor_ruby/puppet/type/package.rb:430:in \`.*')"
    remove_warning "   (at /usr/lib/ruby/vendor_ruby/puppet/type/package.rb:430:in \`.*')"
    remove_warning "Warning: Non-string values for the file mode property are deprecated. It must be a string, either a symbolic mode like 'o+w,a+r' or an octal representation like '0644' or '755'."
    
   "(at /usr/lib/ruby/vendor_ruby/puppet/type/file/mode.rb:69:in \`.*')"
    remove_warning "   (at /usr/lib/ruby/site_ruby/1.8/puppet/type/file/mode.rb:69:in \`.*')"
    remove_warning "   (at /usr/share/ruby/vendor_ruby/puppet/type/file/mode.rb:69:in \`.*')"
    remove_warning "   (at /usr/lib/ruby/vendor_ruby/puppet/type/file/mode.rb:69:in \`.*')"
    FILE_SIZE=$(ls -l $OUTPUT_FILE | awk '{ print $5 }')

    if [ $FILE_SIZE == 0 ];then
        echo -e $RUN_MANIFEST_PREFIX"Removing empty error file "$OUTPUT_FILE
        rm $OUTPUT_FILE
    fi
    if [ $RESULT == 0 ];then
        echo -e $RUN_MANIFEST_PREFIX"Removing empty error file "$OUTPUT_FILE
        rm $OUTPUT_FILE
    fi

    RESULTS_ARRAY[$iteration]=$manifest_name" "$vm_name" result ["$RESULT"]"
    echo -e $RUN_MANIFEST_PREFIX"Result in array "${RESULTS_ARRAY[$iteration]}
}

# Brings up vagrant box for specified profile, figures out the port, creates snapshot, iterates through list of manifests in the tests/ folder
function run_vm {
RUN_VM_PREFIX=$PREFIX"\e[36mrun_vm: \e[39m"
# Add input checking for args 1 & 2
    vm_name=$1
    vm_iterator=$2
    # Get VM Name
    snapshot_name="blank"
    echo -e $RUN_VM_PREFIX"Creating VM ["$vm_name"]"
    #Could add 1> /dev/null to sink output from vagrant elsewhere?
    vagrant up $vm_name
    #Capture SSH port to use
    port=$(vagrant ssh-config $vm_name | grep Port | awk '{ print $2 }')
    #Just in case the port numbers have changed per server then the saved key signature will be wrong so purge
    ssh-keygen -f $HOME"/.ssh/known_hosts" -R [localhost]:$port
    #Take snapshot so we can work on a fresh OS per puppet manifest we apply
    vagrant snapshot save $vm_name $snapshot_name

    # Get list of manifests from the tests/ directory
    if [ ! -z "$3" ]; then
        MANIFESTS=($3)
    else
        MANIFESTS=($(ls -m tests | tr "," " "))
    fi
    echo -e $RUN_VM_PREFIX"Using manifests ${MANIFESTS[@]}"
    #Create a count based on the vm number / iterator multiplied by the total number of manifests we'll run so we can insert them in the results array correctly
    iterator=$((${#MANIFESTS[*]} * $vm_iterator))

    for ((i=0; i < "${#MANIFESTS[*]}"; i++));
    do
#        if [ ! -z SNAPSHOT ]; then
#        vagrant up $vm_name
#        port=$(vagrant ssh-config $vm_name | grep Port | awk '{ print $2 }')
#        ssh-keygen -f $HOME"/.ssh/known_hosts" -R [localhost]:$port
        echo -e $RUN_VM_PREFIX"Manifest ${MANIFESTS[i]}"
        run_manifest $port ${MANIFESTS[i]} $vm_name $snapshot_name $(($iterator + i))

        #Reset the snapshot
        echo -e $RUN_VM_PREFIX"Restoring snapshot ["$snapshot_name"] on VM ["$vm_name"] after test run result ["${RESULTS_ARRAY[$(($iterator + i))]}"]"
        vagrant snapshot restore $vm_name $snapshot_name
#        vagrant destroy $vm_name -f
    done

    #Force vagrant to destroy the machine
   vagrant destroy $vm_name -f
}

# Enters the specified module folder and runs the vm for the Vagrant file contained there
function run_module {
    RUN_PREFIX=$PREFIX"\e[35m"$FUNCNAME": \e[39m"
    local OPTIND FLAG a
    while getopts m:p:t: FLAG; do
        case $FLAG in
            m)
                echo -e $RUN_PREFIX"Using module path ["$OPTARG"]"
                MODULE=($OPTARG)
            ;;
            p)
                echo -e $RUN_PREFIX"Using the vagrant profiles ["$OPTARG"]"
                if [ -z "$OPTARG" ]; then
                    VMs=""
                else
                    VMs=($OPTARG)
                fi
            ;;
            t)
                echo -e $RUN_PREFIX"Using test manifests ["$OPTARG"]"
                if [ -z "$OPTARG" ]; then
                    TEST_MANIFESTS=""
                else
                    TEST_MANIFESTS="$OPTARG"
                fi
            ;;
            \?)
                echo -e $RUN_PREFIX"Unsupported parameter :$OPTARG"
            ;;
        esac
    done

    ORIGINAL_DIR=$(pwd)
    cd $MODULE
    echo -e $RUN_PREFIX"for $MODULE... "$(pwd)
    if [ -z $VMs ];then
        VMs=($(vagrant status | grep -E "*test" | awk '{ print $1 }'))
    fi
    #Handle vagrant not being installed
    echo -e $RUN_PREFIX"Using Vagrant Profiles:"${VMs[@]}
    for ((j=0; j < "${#VMs[*]}"; j++));
    do
        echo -e $RUN_PREFIX"Starting run for "${VMs[j]}" with manifests ${TEST_MANIFESTS[@]}"
        run_vm ${VMs[j]} j "$TEST_MANIFESTS"
    done
    cd $ORIGINAL_DIR
    #Need to move out of the current directory
    echo -e $RUN_PREFIX"Leaving module $MODULE..."
}

declare -a RESULTS_ARRAY
PREFIX="\e[34m$0: \e[39m"
echo -e $PREFIX"Working in directory "$(pwd)

VAGRANT_PROFILE=""
TEST_MANIFESTS=""
MODULES=($(ls -m | tr "," " "))
while getopts m:p:t:-: FLAG; do
    case $FLAG in
        m)
            if [ -z "$OPTARG" ];then
                MODULES=""
            else
                MODULES=($OPTARG)
            fi
            echo -e $PREFIX"Setting module path to ["$MODULES"]"
        ;;
        p)
            echo -e $PREFIX"Setting the vagrant profile to ["$OPTARG"]"
            if [ -z "$OPTARG" ];then
                VAGRANT_PROFILE=""
            else
                VAGRANT_PROFILE="$OPTARG"
            fi
        ;;
        t)
            echo -e $PREFIX"Setting the test manifests to ["$OPTARG"]"
            if [ -z "$OPTARG" ];then
                TEST_MANIFESTS=""
            else
                TEST_MANIFESTS="$OPTARG"
            fi
        ;;
        -)
            case "${OPTARG}" in
            h)
                echo -e $PREFIX"Supported parameters are:"
                echo -e $PREFIX"[-m module_name] a list of module names, reflecting the directory naming of the module"
                echo -e $PREFIX"[-p os_profile] a list of os profiles, reflecting the name of the vagrant defined profile"
                echo -e $PREFIX"[-t test_manifest] a list of test manifests, reflecting the file name of the test manifests"
                exit -1
            ;;
            help)
                echo -e $PREFIX"Supported parameters are:"
                echo -e $PREFIX"[-m module_name] a list of module names, reflecting the directory naming of the module"
                echo -e $PREFIX"[-p os_profile] a list of os profiles, reflecting the name of the vagrant defined profile"
                echo -e $PREFIX"[-t test_manifest] a list of test manifests, reflecting the file name of the test manifests"
                exit -1
            ;;
            *)
                echo -e $PREFIX"Unknown option --${OPTARG}"
                echo -e $PREFIX"Supported parameters are:"
                echo -e $PREFIX"[-m module_name] a list of module names, reflecting the directory naming of the module"
                echo -e $PREFIX"[-p os_profile] a list of os profiles, reflecting the name of the vagrant defined profile"
                echo -e $PREFIX"[-t test_manifest] a list of test manifests, reflecting the file name of the test manifests"
                exit -1
            ;;
       esac;;
        \?)
            echo -e $PREFIX"Unsupported option and/or parameter :"$OPTARG
            echo -e $PREFIX"Supported parameters are:"
            echo -e $PREFIX"[-m module_name] a list of module names, reflecting the directory naming of the module"
            echo -e $PREFIX"[-p os_profile] a list of os profiles, reflecting the name of the vagrant defined profile"
            echo -e $PREFIX"[-t test_manifest] a list of test manifests, reflecting the file name of the test manifests"
            exit -1
        ;;
    esac
done

echo -e $PREFIX"Module list [${#MODULES[*]} modules]:"

for ((k = 0; k < "${#MODULES[*]}"; k++));
do
    if [ -d ${MODULES[k]} ];then
        echo -e $PREFIX"run_module [-m ${MODULES[k]}] [-p $VAGRANT_PROFILE] [-t $TEST_MANIFESTS]"
        run_module -m ${MODULES[k]} -p "$VAGRANT_PROFILE" -t "$TEST_MANIFESTS"
    fi
    echo -e $PREFIX"exiting ${MODULES[k]}"
done
echo -e $PREFIX"Test results:"
for each in "${RESULTS_ARRAY[@]}"
do
  echo "$each"
done
