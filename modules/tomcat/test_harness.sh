#!/usr/bin/env bash
# Function to run a manifest on a vagrant box with the --noop command
# 1) Takes snapshot based on arg $3 (vn_name) and arg $4 (snapshot_name)
# 2) SSH's into vagrant box on arg $1 (port) with manifest arg $2 (manifest name .pp)
# 3) Saves result to file and the results array arg $5
function run_manifest {

    #variables
    port=$1
    manifest_name=$2
    vm_name=$3
    snapshot_name=$4
    iteration=$5


    echo "Working on VM ["$vm_name"] with snapshot ["$snapshot_name"] and testing with manifest "$manifest_name
    /usr/bin/ssh -p$port vagrant@localhost -i ~/.vagrant.d/insecure_private_key -o StrictHostKeyChecking=no 'sudo puppet apply /vagrant/tests/'$manifest_name' --noop' 2> $manifest_name"-errors.txt"
    #Save result to global array
    RESULTS_ARRAY[$5]=$manifest_name" result ["$?"]"
    echo "Result in array "${RESULTS_ARRAY[$iteration]}
}

declare -a RESULTS_ARRAY
echo "Working in vagrant directory "$(pwd)

vm_name="CentOS_6_test"
snapshot_name="virgin"
echo "Creating VM ["$vm_name"]"
vagrant up $vm_name

#Capture SSH port to use
port=$(vagrant ssh-config | grep Port | awk '{ print $2 }')

#Just in case the port numbers have changed per server then the saved key signature will be wrong so purge
ssh-keygen -f $HOME"/.ssh/known_hosts" -R [localhost]:$port

#Take snapshot so we can work on a fresh OS per puppet manifest we apply
vagrant snapshot save $vm_name virgin

#MANIFESTS=("tomcat6.pp" "tomcat7.pp" "tomcat8.pp")
# Get list of manifests from the tests/ directory
MANIFESTS=($(ls -m tests | tr "," " "))
for ((i=0; i < "${#MANIFESTS[*]}"; i++));
do
    run_manifest $port ${MANIFESTS[i]} $vm_name $snapshot_name i
    echo "Restoring snapshot ["$snapshot_name"] on VM ["$vm_name"] after test run result ["${RESULTS_ARRAY[$iteration]}"]"

    #Reset the snapshot
    vagrant snapshot restore $vm_name virgin

done

#Force vagrant to destroy the machine
vagrant destroy $vm_name -f

echo "Test results:"
echo ${RESULTS_ARRAY[@]}

