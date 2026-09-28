pipeline {
    agent any
    
    environment {
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
                    
                    // Quality Gate check karne ke liye timeout block
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
    }
}
