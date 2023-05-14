pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = "ritikvirus/pipeline_docker"
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
                    app = sudo docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:$BUILD_NUMBER")
                }
            }
        }

        stage('Push Docker image') {
            steps {
                script {
                    sudo docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS_ID) {
                        app.push("$BUILD_NUMBER")
                    }
                }
            }
        }

        stage('Deploy to server') {
            steps {
                sshagent([SSH_CREDENTIAL_ID]) {
                    sh '''
                        sudo ssh ubuntu@65.2.169.55 << EOF
                            set +x
                            sudo export DOCKER_USERNAME=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Username')
                            sudo export DOCKER_PASSWORD=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Secret')
                            sudo docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD
                            sudo docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:$BUILD_NUMBER
                            sudo docker run -d -p $APP_PORT:$APP_PORT ${DOCKER_REGISTRY}/${IMAGE_NAME}:$BUILD_NUMBER
                        EOF
                    '''
                }
            }
        }
    }
}
