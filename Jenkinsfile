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
            def builtImage = docker.build(imageTag)

            // Log in to Docker Hub and push
            docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                builtImage.push()
            }
        }
    }
}
        
        
      stage('Deploy to server') {
            steps {
                sshagent(['SSH_CREDENTIALS']) {
                    sh '''
                    
                        ssh -T ${PEM_KEY_PATH} ubuntu@13.232.61.6 << EOF
                            set +x
                            export DOCKER_USERNAME=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Username')
                            export DOCKER_PASSWORD=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Secret')
                            docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD
                            docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                            docker run -d -p 3000:3000 ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                        << EOF
                    '''
                }
            }
        }
    }
}
