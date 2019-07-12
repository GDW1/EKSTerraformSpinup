# Terraform and Ansible EKS cluster 

## Purpose

The purpose of this code is to do two things:

1. To provision the nessessary resources on AWS to create the cluster and nessessary tools to configure it
2. To configure the application to run a simple application

## Used Tools

The following tools were used to create these tools

* Terraform
* AWS CLI
* Kubernetes
* Ansible
* Kubectl
* Docker desktop

## How provision the cluster

Follow the instructions to provision the cluster

1. login to the AWS CLI
2. Clone this repo: `git clone https://github.com/GDW1/EKSTerraformSpinup.git`
3. Go into the folder
4. Plan the Terraform: `terraform plan`
5. Assuming that there were no errors you can apply: `terraform apply`. This should take around 13 minutes.

Upon completion there should be two outputs:
* a kubeconfig
* a nodeconfig

Place the kubeconfig where kubectl keeps its config (usually ~/.kube/config) and
put the nodeconfig in a yaml file and run `kubectl apply -f {path-to-yaml-file}`

You can verify the initialization of the cluster by entering `kubectl get nodes` into terminal and seeing if any nodes show up.

## The Golang applications

The applications that will run on the cluster are go applications two simple Golang applications. One application just listens
for a request on port 80 and returns a simple message. The Other application is also called by request but it pings the other application.

## Deploying the Backend

For the backend, you can either pull the backend from the docker repo `guydw/counter:latest` or build it manually

If you choose to do it manually go into the folder called responder and run the command `docker build -t {your-docker-username}/{the name of the image} .` (make sure that docker desktop is running).
Then run `docker push {your-docker-username}/{the name of the image}`




