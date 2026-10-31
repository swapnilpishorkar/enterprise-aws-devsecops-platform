pipeline {
    agent any

    environment {
        IMAGE_NAME = 'enterprise-devsecops-platform'
        IMAGE_TAG = "ci-${BUILD_NUMBER}"
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
                    .venv-ci/bin/python -m pytest -v
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} \
                        .
                '''
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                    echo "Generating Trivy vulnerability report..."

                    trivy image \
                        --scanners vuln \
                        --severity HIGH,CRITICAL \
                        --format json \
                        --output trivy-report.json \
                        "${IMAGE_NAME}:${IMAGE_TAG}"

                    echo "Checking security gate..."

                    trivy image \
                        --scanners vuln \
                        --severity HIGH,CRITICAL \
                        --exit-code 1 \
                        "${IMAGE_NAME}:${IMAGE_TAG}"
                '''
            }
        }
    }

    post {
        always {
            archiveArtifacts(
                artifacts: 'trivy-report.json',
                allowEmptyArchive: true
            )
        }
    }
}
