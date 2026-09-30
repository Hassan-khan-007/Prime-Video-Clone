pipeline {
    agent any
    
    tools {
        nodejs 'NodeJS'
    }
    
    environment {
        IMAGE_NAME = 'dockerhubhassankhan786/prime-video-clone'
        DOCKER_CREDENTIALS_ID = 'dockerhub'
    }
    
    stages {
        stage('Checkout Code & Clean') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'Sonar'
                    
                    withSonarQubeEnv('Sonar') {
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=my-project \
                            -Dsonar.sources=. \
                            -Dsonar.host.url=http://host.docker.internal:9000
                        """
                    }
                }
            }
        }
        
        stage('Quality Gate Check') {
            steps {
                script {
                    timeout(time: 5, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                
                        if (qg.status != 'OK') {
                            error "Pipeline aborted because Quality Gate failed: ${qg.status}"
                        } else {
                            echo "Quality Gate passed successfully!"
                        }
                    }
                }
            }
        }
        
        stage('OWASP Security Scan') {
            steps {
                // Yeh step project ke dependencies ko scan karega
                dependencyCheck additionalArguments: '--scan . --disableAssembly', odcInstallation: 'OWASP-Check'
                
                // Scan ke reports ko Jenkins dashboard par dekhne ke liye
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", 
                                                      usernameVariable: 'DOCKER_USER', 
                                                      passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            # Build docker image using build number tag
                            docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                            
                            # Login to Docker Hub securely
                            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                            
                            # Push image to Docker Hub
                            docker push ${IMAGE_NAME}:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
    }
}
