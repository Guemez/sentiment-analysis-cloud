#! /bin/sh
rm hosts
touch hosts
for podIP in $(kubectl get pods -o json| jq -r '.items[].status.podIP');
   do
       echo "${podIP}" >> hosts
   done

for podname in $(kubectl get pods -o json| jq -r '.items[].metadata.name');
  
   do
       kubectl cp hosts "${podname}":/mpi/hosts;
   done
