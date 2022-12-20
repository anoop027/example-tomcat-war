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
                
                sh "docker build -t mydockerrepo /var/lib/jenkins/workspace/Java-Tomcat-project1"
                sh "docker tag mydockerrepo:latest 217747396203.dkr.ecr.us-east-1.amazonaws.com/mydockerrepo:latest"
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 217747396203.dkr.ecr.us-east-1.amazonaws.com"
                sh "docker push 217747396203.dkr.ecr.us-east-1.amazonaws.com/mydockerrepo:latest"
            }
        }
        stage('run ansible playbook') {
        agent {label 'ans1'}
            steps {
                ansiblePlaybook becomeUser: 'ubuntu', credentialsId: '7a8dcd73-c24a-49ae-891d-da11bfd17531', installation: 'Ansible1', inventory: '/etc/ansible/hosts', playbook: '/home/ubuntu/run-image.yml'
            }
        }
    }
}
