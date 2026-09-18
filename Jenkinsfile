pipeline {

    agent {
        label 'control-plane'
    }

    environment {
        AWS_REGION = 'ap-south-1'
        ECR_REPO = 'public.ecr.aws/m9y7o3u0/sachin-repo'
        TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/sachinchaudhary-system-engineer/apache-app.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    docker build -t ${ECR_REPO}:${TAG} .
                '''
            }
        }

        stage('Login to ECR Public') {
            steps {
                withCredentials([
                    [$class: 'AmazonWebServicesCredentialsBinding',
                     credentialsId: 'aws-key']
                ]) {
                    sh '''
                        aws ecr-public get-login-password --region ap-south-1 | \
                        docker login --username AWS --password-stdin public.ecr.aws
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    docker push ${ECR_REPO}:${TAG}
                '''
            }
        }
    }

    post {
        success {
            echo "CI completed successfully."
            echo "Image: ${ECR_REPO}:${TAG}"
        }

        failure {
            echo "CI pipeline failed."
        }
    }
}