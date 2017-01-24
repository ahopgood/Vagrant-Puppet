#!/usr/bin/env bash
# Function to run a manifest on a vagrant box with the --noop command
# 1) Takes snapshot based on arg $3 (vn_name) and arg $4 (snapshot_name)
# 2) SSH's into vagrant box on arg $1 (port) with manifest arg $2 (manifest name .pp)
# 3) Saves result to file and the results array arg $5
function run_manifest {

    echo "Working on VM ["$3"] with snapshot ["$4"] and testing with manifest "$2
    /usr/bin/ssh -p$1 vagrant@localhost -i ~/.vagrant.d/insecure_private_key -o StrictHostKeyChecking=no 'sudo puppet apply /vagrant/tests/'$2' --noop' 2> $2"-errors.txt"
    #Save result to global array
    RESULTS_ARRAY[$5]=$2" result ["$?"]"
    echo "Result in array "${RESULTS_ARRAY[$5]}

    echo "Restoring snapshot ["$snapshot_name"] on VM ["vm_name"] after test run result ["${RESULTS_ARRAY[$5]}"]"
    #Reset the snapshot
    vagrant snapshot restore centos6_test virgin
}

cd ../
declare -a RESULTS_ARRAY
echo "Working in vagrant directory "$(pwd)

vm_name="centos6_test"
snapshot_name="virgin"
manifest_name="tomcat6.pp"
echo "Creating VM ["$vm_name"]"
vagrant up centos6_test

#Capture SSH port to use
port=$(vagrant ssh-config | grep Port | awk '{ print $2 }')

#Just in case the port numbers have changed per server then the saved key signature will be wrong so purge
ssh-keygen -f "~/.ssh/known_hosts" -R [localhost]:$port

#Take snapshot so we can work on a fresh OS per puppet manifest we apply
vagrant snapshot save centos6_test virgin

run_manifest $port $manifest_name $vm_name $snapshot_name $iteration

#Force vagrant to destroy the machine
vagrant destroy centos6_test -f

echo "Test results:"
echo ${RESULTS_ARRAY[*]}

