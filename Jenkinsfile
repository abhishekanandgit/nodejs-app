pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'yourdockerhubusername/node-app'
        DOCKER_CREDENTIALS_ID = 'dockerhub-creds' // or 'aws-ecr-creds'
        K8S_MANIFEST_DIR = 'k8s'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/yourusername/your-node-app.git', branch: 'main'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Docker Registry') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to Kubernetes (EKS)') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh """
                    kubectl apply -f ${K8S_MANIFEST_DIR}/deployment.yaml
                    kubectl apply -f ${K8S_MANIFEST_DIR}/service.yaml
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed and deployed to EKS.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}

