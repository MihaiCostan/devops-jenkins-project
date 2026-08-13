What i've done (linkin park)

1. Prepared a Dockerfile.jenkins for a prepeared jenkins image, containing:
- docker.io (for helping push new image to dockerhub)
- python3, python3-pip, python3-venv (for python scrips, applications & tests)
- junit (for showing tests results)

2. Prepared a Dockerfile for the python app image to be created & pushed.

3. Prepared a Jenkinsfile for the Jenkins pipeline stages(using Groovy syntax): python tests, build docker image build and push it to dockerhub.

4. Prepared a docker-compose.yaml file for the Dockerfile.jenkins image to be auto-created with credentials, ports, volumes & other conditions

5. Prepared a Jenkins Pipeline with credentials for Github (for private repo access by using Github Personal Access Token) and Docker (also for repo access, by using Docker Personal Access Token), automated by Poll SCM schedules (2 mins check for github push on branch main), using the Jenkinsfile for pipeline stages.

6. .dockerignore & .gitignore for unwanted files in the imgae / repo