pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = "ritikvirus"
        IMAGE_NAME = "repodoc"
        SSH_CREDENTIAL_ID = "SSH_CREDENTIALS"
        DOCKER_CREDENTIALS_ID = "Docker_Cred"
        APP_PORT = "3000"
        PEM_KEY_PATH = "/home/ubuntu/jenkins1.pem"
    }
    
    stages {
        stage('Clone repository') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Docker image') {
            steps {
                script {
                    def imageTag = "${DOCKER_REGISTRY}/${IMAGE_NAME}:latest"
                    
                    // Build Docker image
                    docker.build(imageTag).push()

                    // Push Docker image to Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        docker.image(imageTag).push()
                    }
                }
            }
        }
        
      stage('Deploy to server') {
            steps {
                sshagent(['SSH_CREDENTIALS']) {
                    sh '''
                    
                        ssh -i ${PEM_KEY_PATH} ubuntu@65.2.169.55 << EOF
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
