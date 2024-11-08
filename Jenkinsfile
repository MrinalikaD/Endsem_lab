pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-java-app:latest'  // Name of your Docker image
    }

    stages {
        // Stage 1: Clone Repository
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/MrinalikaD/Endsem_lab.git', branch: 'main'  // Replace with your repo URL
            }
        }

        // Stage 2: Maven Build (Compile, Test, Package)
        stage('Maven Build') {
            steps {
                script {
                    try {
                        bat 'mvn clean install'  // Runs Maven to clean, compile, and package the application on Windows
                    } catch (Exception e) {
                        echo "Maven build failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e  // Rethrow exception to stop the pipeline
                    }
                }
            }
        }

        // Stage 3: Build Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        bat "docker build -t ${DOCKER_IMAGE} -f Dockerfile ."  // Build Docker image using the multi-stage Dockerfile
                    } catch (Exception e) {
                        echo "Docker build failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e  // Rethrow exception to stop the pipeline
                    }
                }
            }
        }

        // Stage 4: Run Tests
        stage('Run Tests') {
            steps {
                script {
                    try {
                        bat 'mvn test'  // Runs the tests using Maven
                    } catch (Exception e) {
                        echo "Test execution failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e  // Rethrow exception to stop the pipeline
                    }
                }
            }
        }

        // Stage 5: Deploy Docker Container (run in background using 'start' on Windows)
        stage('Deploy Docker Container') {
            steps {
                script {
                    try {
                        bat "start /B docker run -d -p 8081:8080 ${DOCKER_IMAGE}"  // Running the Docker container in the background
                    } catch (Exception e) {
                        echo "Docker container deployment failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e  // Rethrow exception to stop the pipeline
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up unused Docker images and containers
                try {
                    bat 'docker system prune -f'
                } catch (Exception e) {
                    echo "Docker cleanup failed: ${e.message}"
                }
            }
        }
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
