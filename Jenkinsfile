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
                sh 'docker build -t laslanyan/dockerhub-image .'
            }
        }
        stage('Push image to dockerhub') {
            steps {
                script {
                    sh 'echo $DOCKERHUB_CRED_PSW | docker login -u $DOCKERHUB_CRED_USR --password-stdin'
                    sh 'docker tag laslanyan/dockerhub-image $MAIN_BRANCH'
                    sh 'docker push $MAIN_BRANCH'
                }
            }
        }
        stage('Build image for nexus') {
            steps {
                sh "docker build -t spring-petclinic:${GIT_COMMIT} ./"
            }
        }
        stage('Push image to nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus', usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD')]) {
                    sh "echo $NEXUS_PASSWORD | docker login -u $NEXUS_USERNAME --password-stdin 192.168.56.3:8083/repository/jenkins/"
                    sh "docker push 192.168.56.3:8083/repository/jenkins/spring-petclinic:${GIT_COMMIT}"
                }
            }
        }
    }
}
