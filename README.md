
**OpsSchool Project - by Doron Brand**

https://docs.google.com/presentation/d/1Yco1X2K-z9Zz67PkPZN9wc3n8eaqc28V_0HYF_yzyIc/edit#slide=id.g10a5d8eb51d_0_48

**Overview**

Infrastructure is deployed using Terraform on AWS:
* 1 main VPC
* 2 Private Subnets
* 2 Public Subnets
* backend state is handled on S3 bucket
* ALB targeting & exposing all services
* EKS-Kubernetes cluster:
  - 2 groups / 2 nodes each.
  - deployment of 'Kandula' web-app, running on ELB - using Flask listening on port 5000: https://github.com/Dorbra/Kandula-ops

**Installation & Usage**

1. git clone https://github.com/Dorbra/OpsSchool-project
2. cd terraform
3. terraform init
4. terraform apply --auto-approve

**Jenkins**

deployed with IAM Role, all required permissions { ec2:Describe*, eks:DescribeCluster... }
Access Jenkins Master: jenkins_server.kandula:8080

2 pipelines: 
  1. create-ami-image: create a snapshot from ebs > register AMI for 'latest' - to always have a "golden image".
    
  2. deploy-kandula-k8s: Git clone, Docker build & push to DockerHub, apply a K8s Deployment, Service & HPA,
     then Kubernetes script:
      - create secret
      - apply dnsutils
      - Helm install Consul from values.yaml
      - Helm install kube-prometheus
      - Filebeat

**Consul**

Access Consul ui: Load Balancer DNS hostname (redirects to :8500/ui)
3 Consul Servers & 1 Agent. userdata script installing clients and registering services

**Prometheus Node-Exporter**

All services running node-exporters.
K8s run kube-prometheus-stack



**Kubernetes**



