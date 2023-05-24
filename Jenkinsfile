pipeline {
    //agent node1
    node("node1")
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
        
       
