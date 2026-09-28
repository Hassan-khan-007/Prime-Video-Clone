pipeline {
    agent any
    environment {
        SCANNER_HOME = tool 'Sonar'
        IMAGE_NAME = 'your-dockerhub-username/my-local-app'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Hassan-khan-007/Prime-Video-Clone.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('Sonar') {
                    // Ab aapko lamba path likhne ki zaroorat nahi hai, 
                    // seedha 'sonar-scanner' likhein aur sath me host URL bhi pass karein
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=my-project \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://host.docker.internal:9000
                    '''
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
