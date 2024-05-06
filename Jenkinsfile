pipeline {
    agent {
        label 'linux_ubu'
    }
    tools {
        maven 'M3'
    }
    stages {
        stage('Checkstyle') {
            when{
                expression { 
                    env.BRANCH_NAME != 'origin/master'
                }
            }
            steps {
                sh 'mvn checkstyle:checkstyle'
                archiveArtifacts artifacts: 'target/site/checkstyle.html', onlyIfSuccessful: true
            }
        }
        stage('Build for dockerhub mr') {
            when {
                expression {
                    env.BRANCH_NAME != 'origin/master'
                }
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build image for dockerhub') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }
        stage('Push image to dockerhub master') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_CRED_USR', passwordVariable: 'DOCKERHUB_CRED_PSW')]) {
                        sh "echo \$DOCKERHUB_CRED_PSW | docker login -u \$DOCKERHUB_CRED_USR --password-stdin"
                        sh "docker tag $IMAGE ${MAIN_BRANCH}:${GIT_COMMIT}"
                        sh "docker push ${MAIN_BRANCH}:${GIT_COMMIT}"
                    }
                }
            }
        }
        stage('Push image to dockerhub mr') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_CRED_USR', passwordVariable: 'DOCKERHUB_CRED_PSW')]) {
                        sh "echo \$DOCKERHUB_CRED_PSW | docker login -u \$DOCKERHUB_CRED_USR --password-stdin"
                        sh "docker tag $IMAGE ${MR_BRANCH}:${GIT_COMMIT}"
                        sh "docker push ${MR_BRANCH}:${GIT_COMMIT}"
                    }
                }
            }
        }
    }
}
