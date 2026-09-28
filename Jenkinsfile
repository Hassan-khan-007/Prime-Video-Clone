pipeline {
    agent any
    environment {
        SCANNER_HOME = tool 'SonarQubeScanner'
        IMAGE_NAME = 'your-dockerhub-username/my-local-app'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/your-app-repo.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarServer') {
                    sh "${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=my-local-app"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    app = docker.build("${IMAGE_NAME}:${env.BUILD_ID}")
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                // Image vulnerability scan
                sh "trivy image --exit-code 1 --severity HIGH,CRITICAL ${IMAGE_NAME}:${env.BUILD_ID}"
            }
        }
        stage('Push to Registry & Update GitOps Repo') {
            steps {
                script {
                    // DockerHub credentials Jenkins mein add karke yahan use karein
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials-id') {
                        app.push("${env.BUILD_ID}")
                        app.push("latest")
                    }
                    
                    // Step: Update Second Repo (Manifest Repo) with new image tag for ArgoCD
                    // Aap yahan git command likh sakte hain jo second repo ko clone karegi, 
                    // deployment.yaml mein image tag update karegi, aur push kar degi.
                }
            }
        }
    }
}
