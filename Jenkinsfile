pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-java-app:latest'  // Name of your Docker image
    }

    stages {
        // Stage 1: Clone Repository
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/MrinalikaD/Endsem_lab.git', branch: 'main'
            }
        }

        // Stage 2: Compile Code
        stage('Compile') {
            steps {
                script {
                    try {
                        bat 'mvn clean compile'  // Compile the code
                        echo "Compilation completed successfully."
                    } catch (Exception e) {
                        echo "Compilation failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        // Stage 3: Run Tests
        stage('Run Tests') {
            steps {
                script {
                    try {
                        bat 'mvn test'  // Run tests
                        echo "Testing completed successfully."
                        // Optional: Archive test reports
                        archiveArtifacts artifacts: 'target/surefire-reports/*.xml', allowEmptyArchive: true
                    } catch (Exception e) {
                        echo "Testing failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        // Stage 4: Package the Application
        stage('Package') {
            steps {
                script {
                    try {
                        bat 'mvn package'  // Package the application
                        echo "Packaging completed successfully."
                        // Archive the JAR file or other relevant artifacts
                        archiveArtifacts artifacts: 'target/*.jar', allowEmptyArchive: true
                    } catch (Exception e) {
                        echo "Packaging failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        // Stage 5: Build Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        bat "docker build -t ${DOCKER_IMAGE} -f Dockerfile ."  // Build Docker image
                        echo "Docker image built successfully."
                    } catch (Exception e) {
                        echo "Docker build failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        // Stage 6: Deploy Docker Container
        stage('Deploy Docker Container') {
            steps {
                script {
                    try {
                        bat "start /B docker run -d -p 8081:8080 ${DOCKER_IMAGE}"  // Deploy Docker container
                        echo "Docker container deployed successfully."
                    } catch (Exception e) {
                        echo "Docker container deployment failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
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
