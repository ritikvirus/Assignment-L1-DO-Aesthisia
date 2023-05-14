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
                sshagent([SSH_CREDENTIAL_ID]) {
                    sh '''
                        ssh ubuntu@65.2.169.55 << EOF
                            set +x
                            export DOCKER_USERNAME=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Username')
                            export DOCKER_PASSWORD=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Secret')
                            docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD
                            docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                            docker run -d -p $APP_PORT:$APP_PORT ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                        EOF
                    '''
                }
            }
        }
    }
}
    
