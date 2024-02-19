def notifySuccess() {
    def imageUrl = 'https://www.weodeo.com/wp-content/uploads/2023/02/DevOps-scaled.webp' // Replace with the actual URL of your image
    def imageWidth = '800px' // Set the desired width in pixels
    def imageHeight = 'auto' // Set 'auto' to maintain the aspect ratio

    // Read the entire console log file
    def consoleLog = readFile("${JENKINS_HOME}/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log")
    def logFile = "${WORKSPACE}/console.log"
    writeFile file: logFile, text: consoleLog

    emailext(
        body: """
            <html>
                <body>
                    <p>YEEEEY, The Jenkins job was successful.</p>
                    <p>You can view the build at: <a href="${BUILD_URL}">${BUILD_URL}</a></p>
                    <p><img src="${imageUrl}" alt="Your Image" width="${imageWidth}" height="${imageHeight}"></p>
                    <p>Console Log is attached.</p>
                </body>
            </html>
        """,
        subject: "Jenkins Job - Success",
        to: 'malik.hammami1@gmail.com',
        attachLog: true,  // Attach the log file
        attachmentsPattern: logFile,  // Specify the file to attach
        mimeType: 'text/html'
    )
}

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

        stage('Pushing Image to DockerHub') {
            steps {
                sh 'docker push malikhammami99/springachat'

            }
        }
        stage('Docker Compose') {
            steps {
                sh 'docker compose up -d'
            }
        }
  stage('Email Notification') {
            steps {
                script {
                    currentBuild.resultIsBetterOrEqualTo('SUCCESS') ? notifySuccess() : notifyFailure()
                }
            }
        }  
    }

    post {
        always {
            sh 'docker logout'
        }
    }
         
}
