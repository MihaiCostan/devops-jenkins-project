What i've done

1. Prepared a Dockerfile.jenkins for a prepeared jenkins image, containing:
- docker.io (for helping push new python app image to dockerhub)
- python3, python3-pip, python3-venv (for python scrips, applications & tests)
- junit (for showing tests results, also integrated in Jenkins GUI for graphs etc.)

2. Prepared a Dockerfile for the python app image to be created & pushed.

3. Prepared a Jenkinsfile for the Jenkins pipeline stages(using Groovy syntax): python tests, build docker image and push it to dockerhub.

4. Prepared a docker-compose.yaml file for the Dockerfile.jenkins image to be auto-created with credentials, ports, volumes & other conditions

5. Prepared a Jenkins Pipeline with credentials for Github (for private repo access by using Github Personal Access Token) and Docker (also for repo access, by using Docker Personal Access Token), automated by Poll SCM schedules (2 mins check for github push on branch main), using the Jenkinsfile for pipeline stages.

6. .dockerignore & .gitignore for unwanted files in the imgae / repo



Phase 2 (day 2)

Main goal: Launch EC2 instance by jenkins with the docker image uploaded on dockerhub

1. Changed the building architecture for the docker image from arm64 to linux/amd64 so t3.micro would be compatible with the version (in Jenkinsfile)

2. Developed terraform IaC for creating a AWS EC2 instance (t3.micro) to run the docker container with the image form DockerHub (uploaded by jenkins pipeline)
- installed packets (docker) and pulled the image + run the container on the fastAPI port (8000)
- settings for AWS firewall (opened ports 22, 8000 and 80 for ssh, fastapi app + http)
- selected the system image (ubuntu)
- generated outputs for the server ip & the url for fastapi app access (http with port 8000)

3. Prepared SSH credentials for Jenkins connection to AWS EC2 instance (with ssh RSA .pem keys directly to Jenkins ssh credentials), used in code at the Deploy to AWS EC2 stage, where also the Docker credentials are "passed" to the EC2 instance for pulling the private repo image from DockerHub

4. SSH to EC2 where connection to docker is commited, pull the image + cleanup from old containers and also run the new container

5. FastAPI app is now accessible from anywhere on the internet now!

Phase 3 (day 2)

1. I want to add security, because i have port 22 open for all the internet. i have 2 ways (maybe more):
    1. I can use aws ssm (with iam role & aws ssm send-command from jenkins pipeline) so i have to update the jenkins packets with awscli
    2. I can open port 22 only for the jenkins server
        - here could be a problem, because i run jenkins locally so it means i should open port 22 for the public ip address of my network, which means that it would be vulnerable to the devices connected on the sam LAN
        - also secured because i am using ssh keys
    I will go with the aws ssm, maybe i ll implement open port 22 later

2. Edited from ssh to aws ssm send-command, but firstly sended credentials

3. encountered a security warning, Warning: A secret was passed to "sh" using Groovy String interpolation, which is insecure. Affected argument(s) used the following variable(s): [DH_PASS] that will be fixed later.