pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "MyMaven"
    }

    stages {
        stage('Git checkout') {
            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/anoop027/example-tomcat-war'
            }
        }
        stage('Build') {
            steps {
                sh "mvn  clean package"
            }
        }
        stage ('Code Quality scan')  {
            steps {
            withSonarQubeEnv('SonarQube') {
            sh "mvn sonar:sonar"
              }
            }
        }
        stage("Quality Gate") {
            steps {
              timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
              }
            }
          }
        stage('upload war file to nexus') {
            steps {
                script{
                def mavenPom = readMavenPom file: 'pom.xml'
                nexusArtifactUploader artifacts: [[artifactId: 'SimpleTomcatWebApp', classifier: '', file: 'target/SimpleTomcatWebApp.war', type: 'war']], credentialsId: 'nexus3', groupId: 'com.example.app', nexusUrl: '172.31.65.133:8081/', nexusVersion: 'nexus3', protocol: 'http', repository: 'java-app-artifact', version: "${mavenPom.version}"
            }
        }
        }
        stage('build docker file') {
            steps {
                
                sh "docker build -t mydockerrepo /var/lib/jenkins/workspace/Java-Tomcat-project1"
                sh "docker tag mydockerrepo:latest 217747396203.dkr.ecr.us-east-1.amazonaws.com/mydockerrepo:latest"
            }
        }
        stage('push docker image to ECR') {
            steps {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 217747396203.dkr.ecr.us-east-1.amazonaws.com"
                sh "docker push 217747396203.dkr.ecr.us-east-1.amazonaws.com/mydockerrepo:latest"
            }
        }
        stage('deploy to EKS from Ansible') {
        agent {label 'ans1'}
            steps {
                ansiblePlaybook becomeUser: 'ubuntu', credentialsId: '7a8dcd73-c24a-49ae-891d-da11bfd17531', installation: 'Ansible1', inventory: '/etc/ansible/hosts', playbook: '/home/ubuntu/run-image.yml'
            }
        }
        
    }
}
