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

        stage('Deploy to server') {
            steps {
                sshagent(credentials:['SSH_CREDENTIALS']){
                    sh '''
                        ssh -i $SSH_KEY ubuntu@65.2.169.55 << EOF
                            set +x
                            docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                            docker run -d -p $APP_PORT:$APP_PORT ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                        EOF
                    '''
                }
            }
        }
    }
}
