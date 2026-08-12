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
                    pytest
                '''
            }
        }
        stage('2. Build Docker Image') {
            steps{
                echo '=== Construire imagine Docker ==='
                sh 'docker build -t ${DOCKER_USER}/${IMAGE_NAME}:${TAG} .'
            }
        }
        stage('3. Push to DockerHub') {
            steps{
                echo '=== Push imagine pe Docker Hub ==='
                sh 'docker push ${DOCKER_USER}/${IMAGE_NAME}:${TAG}'
            }
        }
    }
    post{
        always {
            echo '=== Curățare mediu de lucru ==='
            sh 'rm -rf venv'
        }
        success {
            echo ' Pipeline-ul s-a executat cu succes!'
        }
        failure {
            echo ' Pipeline-ul a eșuat!'
        }
    }
}