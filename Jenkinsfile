pipeline {
    agent any

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
    }
}
