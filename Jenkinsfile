pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("my-app:${env.BUILD_ID}")
                }
            }
        }
      

        stage('Deploy') {
            steps {
                sshagent(['SSH_CREDENTIALS']) {
                    script {
                        def remote = [:]
                        remote.name = 'pipeline_practice'
                        remote.host = '65.2.169.55'
                        remote.user = 'ubuntu'

                        sshCommand remote: remote, command: """
                            docker stop my-app-container || true
                            docker rm my-app-container || true
                            docker run -d -p 3000:3000 --name my-app-container my-app:${env.BUILD_ID}
                        """
                    }
                }
            }
        }
    }
}
