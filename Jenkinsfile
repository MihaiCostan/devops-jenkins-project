pipeline{
    agent any
    environment {
        DOCKER_USER = 'mihai2312'
        IMAGE_NAME = 'devops_python_project'
        TAG = 'latest'
    }

    stages{
        stage('1. Install & Test') {
            steps {
                echo '=== Rulare teste automate (Pytest) ==='
                sh '''
                    python3 -m venv .venv
                    . .venv/bin/activate
                    pip install -r requirements.txt
                    pytest --junitxml=test_results.xml
                '''
            }
        }
        stage('2. Build Docker Image') {
            steps{
                echo '=== Construire imagine Docker (x86/amd64) ==='
                sh 'docker build --platform linux/amd64 -t ${DOCKER_USER}/${IMAGE_NAME}:${TAG} .'
            }
        }
        stage('3. Push to DockerHub') {
            steps{
                echo '=== Push imagine pe Docker Hub ==='

                withCredentials([usernamePassword(credentialsId: 'Docker_credential', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                    sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                    sh "docker push ${DOCKER_USER}/${IMAGE_NAME}:${TAG}"
                }
            }
        }
        stage('4. Deploy to AWS EC2') {
            steps{
                echo '=== Deploy app to AWS EC2 instance'
                withCredentials([sshUserPrivateKey(credentialsId:'EC2_SSH_KEY', keyFileVariable: 'SSH_KEY', usernameVariable: 'EC2_USER')]),
                usernamePassword(credentialsId: 'Docker_credential', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS') {
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $EC2_USER@18.195.224.87 "
                        #1. Login to docker
                        echo $DH_PASS | sudo docker login -u $DH_USER --password-stdin
                        
                        #2. Download the last image from DockerHub
                        sudo docker pull ${DOCKER_USER}/${IMAGE_NAME}:${TAG}

                        #3. Stop and delete old working containers
                        sudo docker stop app || true
                        sudo docker rm app || true

                        #4. Run new container
                        sudo docker run -d --name app -p 8000:8000 --restart always ${DOCKER_USER}/${IMAGE_NAME}:${TAG}
                        "
                    '''
                }
            }
        }
    }
    post{
        always {
            echo '=== Curățare mediu de lucru ==='
            sh 'rm -rf .venv'
            echo '=== Afisare rezultate teste(junit) ==='
            junit 'test_results.xml'
        }
        success {
            echo ' Pipeline-ul s-a executat cu succes!'
        }
        failure {
            echo ' Pipeline-ul a eșuat!'
        }
    }
}