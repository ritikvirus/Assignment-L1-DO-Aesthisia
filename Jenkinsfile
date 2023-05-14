node {
    environment {
        DOCKER_REGISTRY = "ritikvirus/pipeline_docker"
        IMAGE_NAME = "pipelinedockerimage"
        SSH_CREDENTIAL_ID = "SSH_CREDENTIALS"
        DOCKER_CREDENTIAL_ID = "Docker_Cred"
        APP_PORT = "3000"
    }
    def app 

    stage('Clone repository') {
        checkout scm
    }

    stage('Build Docker image') {
        app = docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:$BUILD_NUMBER")
    }

    stage('Push Docker image') {
        docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIAL_ID) {
            app.push("$BUILD_NUMBER")
        }
    }

    stage('Deploy to server') {
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
