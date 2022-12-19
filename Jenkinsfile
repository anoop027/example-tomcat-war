pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "MyMaven"
    }

    stages {
        stage('Build') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/anoop027/example-tomcat-war'
                sh "mvn  clean package"
            }
        }
        stage('build docker file') {
            steps {
                withCredentials([string(credentialsId: 'dockerpasswd', variable: 'dockerpwd')]) {
               
                sh "docker login -u anoopd27 -p ${dockerpwd}"
                }
                sh "docker build -t anoopd27/pvtrepo1:${BUILD_NUMBER} /var/lib/jenkins/workspace/Java-Tomcat-project1"
                sh "docker push anoopd27/pvtrepo1:${BUILD_NUMBER}"
            }
        }
        stage('run ansible playbook') {
        agent {label 'ans1'}
            steps {
                withCredentials([string(credentialsId: 'dockerpasswd', variable: 'dockerpwd')]) {
                ansiblePlaybook becomeUser: 'ec2-user', extras: '--extra-vars "tag=${BUILD_NUMBER} dp=${dockerpwd}"', installation: 'Ansible1', inventory: '/etc/ansible/hosts', playbook: '/artifact/run-image.yml'
                }
            }
        }
    }
}
