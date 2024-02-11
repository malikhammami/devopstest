pipeline {
    agent any
    parameters {
        string(name: 'BRANCH_NAME', defaultValue: "${scm.branches[0].name}", description: 'Git branch name')
        string(name: 'CHANGE_ID', defaultValue: '', description: 'Git change ID for merge requests')
        string(name: 'CHANGE_TARGET', defaultValue: '', description: 'Git change ID for the target merge requests')
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')
    }
    stages {
        stage('Github Auth') {
            steps {
                script {
                    branchName = params.BRANCH_NAME
                    targetBranch = branchName

                    git branch: branchName,
                    url: 'https://github.com/ZayaniHassen/Devops.git',
                    credentialsId: '3211957c-60c3-42bb-8798-827ef9bec12d'
                }
                echo "Current branch name: ${branchName}"
                echo "Current branch name: ${targetBranch}"
            }
        }
        stage('MVN CLEAN & COMPILE') {
            steps {
                sh "mvn clean"
                 sh "mvn compile"
            }
        }

        stage('Test Mockito') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Quality code') {
            steps {
                sh "mvn sonar:sonar -Dsonar.login=admin -Dsonar.password=sonar"
            }
        }

        stage('Deployment Nexus') {
            steps {
                sh 'mvn deploy -DskipTests'
            }
        }
        stage('DockerHub login and image build') {
            steps {
                    script {
                             sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                           }
                sh 'docker build -t malikhammami99/springachat .'


            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh 'docker push malikhammami99/springachat'

            }
        }
        stage('Docker Compose') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}