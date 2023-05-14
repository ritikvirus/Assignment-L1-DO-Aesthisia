pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = "ritikvirus/pipeline_docker"
        IMAGE_NAME = "pipelinedockerimage"
        SSH_CREDENTIAL_ID = "SSH_CREDENTIALS"
        DOCKER_CREDENTIAL_ID = "Docker_Cred"
        APP_PORT = "3000"
    }

    stages {
        stage('Clone repository') {
            steps {
                checkout scm
            }
        }

    stages{
        stage('Build Docker image') {
            steps { 
                docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:$BUILD_NUMBER")
    }
        }

     stages{
            stage('Push Docker image') {
                steps{ docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIAL_ID) {
            app.push("$BUILD_NUMBER")
                }
        }
    }

      stages{
            stage('Deploy to server') {
                steps{
                sshagent([SSH_CREDENTIALS]) {
            sh '''
                ssh ubuntu@65.2.169.55 << EOF
                    set +x
                    export DOCKER_USERNAME=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Username')
                    export DOCKER_PASSWORD=\$(docker-credential-jenkins get ${DOCKER_REGISTRY} | jq -r '.Secret')
                    docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD
                    docker pull ${DOCKER_REGISTRY}/${IMAGE_NAME}:$BUILD_NUMBER
                    docker run -d -p $APP_PORT:$APP_PORT ${DOCKER_REGISTRY}/${IMAGE_NAME}:$BUILD_NUMBER
                EOF
            '''
        }
                }
    }
}
