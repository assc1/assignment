# k3s
## This we can use deploy sample nginx on k3s cluster. 
## We are using the terraform for provisioning the infrastructure on AWS, 
This terraform script will create the one security group with all the required inbound and outbound rules and two ec2 instances. 
And we are setting up the k3s cluster on EC2 istances at the time of creation. One EC2 will acts as a master and other will acts as Node. 
## To run the code, use below commands 
``` terraform init ```
``` terraform validate ```
``` terraform plan ```
``` terraform apply ```
## With the above commands it will create the required infrastructure on AWS. 
# we have to login to master ec2 instaces through shell and copy the k3s join_token, which is used for to add the nodes into the k3s clustrer 
# Run the below command other ec2 instance to add it to k3s cluster. 
## We can get the token from master server from this location /var/lib/rancher/k3s/server/node-token 
copy the above token replace it in below command and run the below command on node machine
``` sudo curl -sfL http://get.k3s.io | K3S_URL=https://<master_IP>:6443 K3S_TOKEN=<join_token> sh -s ```
## We are done with the cluster setup. Now we have to run the Manifest file to deploy the application to k3s cluster. 
## use below commands to deploy nginx into above cluster 
``` sudo kubectl apply -f rc.yml ``` 
``` sudo kubectl apply -f svc.yml ``` 
