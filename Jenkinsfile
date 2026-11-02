pipeline {
    agent any

    environment {
        AWS_REGION      = 'ap-southeast-2'
        AWS_ACCOUNT_ID  = '230944684832'
        ECR_REGISTRY    = '230944684832.dkr.ecr.ap-southeast-2.amazonaws.com'
        ECR_REPOSITORY  = 'enterprise-devsecops-app'

        EKS_CLUSTER     = 'enterprise-devsecops-eks'
        K8S_NAMESPACE   = 'devsecops'
        DEPLOYMENT_NAME = 'enterprise-devsecops-app'
        CONTAINER_NAME  = 'flask-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    set -e
                    python3 --version
                    python3 -m venv .venv-ci
                    .venv-ci/bin/pip install --upgrade pip
                    .venv-ci/bin/pip install -r requirements-dev.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    set -e
                    .venv-ci/bin/python -m pytest -v
                '''
            }
        }

        stage('Build and Push to ECR') {
            steps {
                script {
                    def shortCommit = sh(
                        script: 'git rev-parse --short=7 HEAD',
                        returnStdout: true
                    ).trim()

                    env.IMAGE_TAG = "ci-${env.BUILD_NUMBER}-${shortCommit}"
                }

                sh '''
                    set -e

                    IMAGE_URI="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

                    echo "Authenticating with Amazon ECR..."

                    aws ecr get-login-password \
                        --region "${AWS_REGION}" |
                    docker login \
                        --username AWS \
                        --password-stdin "${ECR_REGISTRY}"

                    echo "Building Docker image: ${IMAGE_URI}"

                    docker build -t "${IMAGE_URI}" .

                    echo "Pushing image to ECR..."

                    docker push "${IMAGE_URI}"

                    echo "Successfully pushed ${IMAGE_URI}"
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    set -e

                    IMAGE_URI="${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"

                    echo "Configuring Kubernetes access..."

                    aws eks update-kubeconfig \
                        --region "${AWS_REGION}" \
                        --name "${EKS_CLUSTER}"

                    echo "Updating Kubernetes Deployment..."

                    kubectl set image \
                        deployment/"${DEPLOYMENT_NAME}" \
                        "${CONTAINER_NAME}"="${IMAGE_URI}" \
                        --namespace "${K8S_NAMESPACE}"

                    echo "Waiting for deployment rollout..."

                    kubectl rollout status \
                        deployment/"${DEPLOYMENT_NAME}" \
                        --namespace "${K8S_NAMESPACE}" \
                        --timeout=180s

                    echo "Checking application pods..."

                    kubectl get pods \
                        --namespace "${K8S_NAMESPACE}" \
                        -l app=enterprise-devsecops-app \
                        -o wide

                    echo "Deployment completed successfully."
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
            echo "Deployed image tag: ${env.IMAGE_TAG}"
        }

        failure {
            echo 'CI/CD pipeline failed. Check the stage logs.'
        }

        always {
            sh '''
                docker logout "${ECR_REGISTRY}" || true
            '''
        }
    }
}
