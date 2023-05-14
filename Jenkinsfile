pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = "ritikvirus/repodoc"
        IMAGE_NAME = "pipelinedockerimage"
        SSH_CREDENTIAL_ID = "SSH_CREDENTIALS"
        DOCKER_CREDENTIALS_ID = "Docker_Cred"
        APP_PORT = "3000"
    }
    
    stages {
        stage('Clone repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    app = docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push Docker image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        app = docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:latest")
                    }
                }
            }
        }

        
        stage('Deploy to SSH server') {
            steps {
                sshagent(credentials:['SSH_CREDENTIALS']) {
                    sh 'ssh ubuntu@65.2.169.55 uptime "whoami"'
                }
            }
        }

        stage('Deploy to server') {
            steps {
                if (sh 'ssh ubuntu@65.2.169.55 uptime "whoami"') {
                    echo "success login"
                } else {
                    fail("Failed to login to remote server")
                }
            }
        }
    }
}
