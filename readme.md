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
* K8s go plugin https://github.com/ericchiang/k8s
* Openshift
* golang
* pip

## Intalling the nessessary tools

From the preceding list you'll need to manually install the:
* AWS cli: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
* pip3: https://www.python.org/downloads/
* Ansible: run in terminal `pip3 install ansible`
* Kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
* Docker Desktop: https://www.docker.com/products/docker-desktop
* Golang: https://golang.org/dl/
* K8s go plugin: `go get https://github.com/ericchiang/k8s`

## simple setup

if you want the simplest possible setup, install the nessessary tools above and change the execute this file appropriatly to point to the right destinations for the execturables in the file.

Then log into the AWS CLI and execute the `execute-this` executable and after around 13 minutes the cluster should be provisioned and configured to run the applications.

Alternatively use the following instructions to do the steps take in the executable file automatically


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

## (OPTIONAL) Building the Backend Manually

For the backend, if you don't want to the backend from the docker repo `guydw/responser:latest`, you can build it manually

If you choose to do it manually go into the folder called responder and run the command `docker build -t {your-docker-username}/{the name of the image} .` (make sure that docker desktop is running).
Then run `docker push {your-docker-username}/{the name of the image}`

## (OPTIONAL) Building the frontend Manually 

For the Frontend, if you don't want to the backend from the docker repo `guydw/apitest:v16`, you can build it manually

If you choose to do it manually go into the folder called requester and run the command `docker build -t {your-docker-username}/{the name of the image} .` (make sure that docker desktop is running).
Then run `docker push {your-docker-username}/{the name of the image}`

## Deploying the applications using Ansible

To deploy the application with ansible go into the folder labeled `ansible` and run the command `ansible-playbook full-set-up`

Now if you type into terminal `kubectl get svc` you should see a service called `apitest` and one called `counter`. apitest should have an external ip either pending or already attached and going to that external ip should bring up a screen that displays the message from the backend

*note*: if you built manually you will have to change the image in the yaml files.
*note*: If you want to deploy the frontend and backend seperatly, use the `set-up-frontend.yaml` and the `set-up-backend.yaml` respectively

## Tearing down the cluster

Before tearing down the cluster make sure that you tear down the anisble work first to insure that the only thing remaining was the work down with Terraform. To do this go into the ansible folder and run `ansible-playbook tear-down.yaml`

Then use the command `terraform plan -destroy` to make sure that it can correctly tear down the infastructure

Lastly run the command `terraform destroy` to delete the infastructure. This should take around 12 minutes 
