pipeline {
    agent {
        label 'linux_ubu'
    }
    tools {
        maven 'M3'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                          branches: [[name: 'jenkins']],
                          userRemoteConfigs: [[url: 'https://github.com/laslanyan/spring-petclinic.git']]])
            }
        }
        stage('Checkstyle') {
            steps {
                sh 'mvn checkstyle:checkstyle'
                archiveArtifacts artifacts: 'target/site/checkstyle.html', onlyIfSuccessful: true
            }
        }
        stage('Build for dockerhub and nexus') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Build image for dockerhub') {
            steps {
                sh 'docker build -t $IMAGE_DOCKERHUB .'
            }
        }
        stage('Push image to dockerhub') {
            steps {
                script {
                    sh 'docker login -u $DOCKERHUB_CRED_USR -p $DOCKERHUB_CRED_PSW'
                    sh 'docker tag $IMAGE_DOCKERHUB $MAIN_BRANCH'
                    sh 'docker push $MAIN_BRANCH'
                }
            }
        }
        stage('Build image for nexus') {
            steps {
                sh "docker build -t IMAGE_NEXUS ./"
            }
        }
        stage('Push image to nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                    sh "docker login -u $NEXUS_USERNAME -p $NEXUS_PASSWORD $NEXUS_REPO"
                    sh "docker tag $IMAGE_NEXUS $NEXUS_REPO_FINAL"
                    sh "docker push $NEXUS_REPO_FINAL"
                }
            }
        }
    }
}
