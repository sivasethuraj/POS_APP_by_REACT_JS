pipeline {
    agent {
        docker {
            image 'node:18-alpine'
        }
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        DOCKER_IMAGE = "sivaseturaj/pos-app:v1.$BUILD_ID"
        NODE_OPTIONS = "--no-warnings"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sivasethuraj/POS_APP_by_REACT_JS.git']])
            }
        }

        stage('Build') {
            steps {
                sh '''
                npm install --no-audit --no-fund
                npm run build || true
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                npm test
                '''
            }
        }

        stage('Deploy') {
            agent {
                docker {
                    image 'docker:20.10.24-dind-alpine'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh '''
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker build -t $DOCKER_IMAGE .
                docker push $DOCKER_IMAGE
                '''
                sh echo "succesfully tested"  
            }
        }
    }
}
