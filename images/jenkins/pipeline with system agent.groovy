pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sivaseturaj/pos-app:v1.${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
checkout scmGit(branches: [[name: '*/jenkins']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/sivasethuraj/POS_APP_by_REACT_JS.git']])
            }
        }

        stage('Dependencies') {
            steps {
                sh '''
                    npm install
                '''
                archiveArtifacts artifacts: 'node_modules/*', followSymlinks: false, onlyIfSuccessful: true
            }
        }

        stage('Build') {
            steps {
                sh '''
                    npm run build
                '''
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_PASS'
                )]) {
                    sh '''
                        echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                        docker build -t $DOCKER_IMAGE .
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "Image pushed successfully: $DOCKER_IMAGE"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
