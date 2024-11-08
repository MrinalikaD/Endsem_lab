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
                sh 'mvn clean install'  // Runs Maven to clean, compile, and package the application
            }
        }

        // Stage 3: Build Docker Image
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, '-f Dockerfile .')  // Builds Docker image using the multi-stage Dockerfile
                }
            }
        }

        // Stage 4: Run Tests
        stage('Run Tests') {
            steps {
                sh 'mvn test'  // Runs the tests using Maven
            }
        }

        // Stage 5: Deploy Docker Container
        stage('Deploy Docker Container') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).run('-p 8081:8080')  // Deploys the Docker container and maps port 8080 in container to 8081 on host
                }
            }
        }
    }

    post {
        always {
            sh 'docker system prune -f'  // Cleans up unused Docker images and containers
        }
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
