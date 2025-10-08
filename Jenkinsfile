pipeline {
    agent any

    environment {
        // Docker Hub repo details
        DOCKER_IMAGE = "lavetivenkatesh/electro-store"
        IMAGE_TAG    = "latest"
        CONTAINER_NAME = "electro-store"  // Container name
        APP_PORT = "80"                    // Port on host
        CONTAINER_PORT = "9000"              // Port inside container
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-creds') {
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    sh '''
                    echo "🚀 Deploying container..."

                    # Stop and remove old container if exists
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true

                    # Pull the latest image from Docker Hub
                    docker pull ${DOCKER_IMAGE}:${IMAGE_TAG}

                    # Run container
                    docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:${CONTAINER_PORT} ${DOCKER_IMAGE}:${IMAGE_TAG}

                    echo "✅ Deployment complete. Container running on port ${APP_PORT}"
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build, Push, and Deployment successful: ${DOCKER_IMAGE}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Build, Push, or Deployment failed."
        }
    }
}
