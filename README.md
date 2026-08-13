What i've done (linkin park)

1. Prepared a Dockerfile.jenkins for a prepeared jenkins image, containing:
- docker.io (for helping push new image to dockerhub)
- python3, python3-pip, python3-venv (for python scrips, applications & tests)
- junit (for showing tests results, also integrated in Jenkins GUI for graphs etc.)

2. Prepared a Dockerfile for the python app image to be created & pushed.

3. Prepared a Jenkinsfile for the Jenkins pipeline stages(using Groovy syntax): python tests, build docker image build and push it to dockerhub.

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