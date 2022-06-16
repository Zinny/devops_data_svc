pipeline {
    agent any 

    tools {nodejs "nodejs"}

    environment {
        registryCredential = 'dockerhub'
        imageName = 'cinnyabraham06/internalapp'
        dockerImage = ''
        }
    stages {
        stage('Run the tests') {
             agent {
                docker { 
                    image 'node:14-alpine'
                    args '-e HOME=/tmp -e NPM_CONFIG_PREFIX=/tmp/.npm'
                    reuseNode true
                }
            }
            steps {
                echo 'Retrieve source from github. run npm install and npm test' 
                git branch: 'main',
                    url: 'https://github.com/Zinny/devops_data_svc.git'
                echo 'repo files'
                sh 'ls -a'
            }
        }
          stage('SonarQube Analysis') {
             steps {
                 def scannerHome = tool 'sonarqube';
                 withSonarQubeEnv('sonarqube') {
                     sh "npm run sonar"
            }
           }
         }
        stage('Building image') {
            steps{
                script {
                    echo 'build the image'
		    dockerImage = docker.build("${env.imageName}:${env.BUILD_ID}")
	            echo "${env.imageName}:${env.BUILD_ID}"
                    echo 'image built'
                }
            }
            }
        stage('Push Image') {
            steps{
                script {
                    echo 'push the image to docker hub'
                    docker.withRegistry('',registryCredential){
                        dockerImage.push("${env.BUILD_ID}")
                  }
                }
            }
        }     
         stage('deploy to k8s') {
             agent {
                docker { 
                    image 'google/cloud-sdk:latest'
                    args '-e HOME=/tmp'
                    reuseNode true
                        }
                    }
            steps {
                echo 'Get cluster credentials'
                sh 'gcloud container clusters get-credentials cinny-app-cluster --zone us-west1-b --project inlaid-stack-352300'
                sh "kubectl set image deployment/devops-data-svc data-svc-container=${env.imageName}:${env.BUILD_ID}"
              }
            }       
        stage('Remove local docker images') {
            steps{
                script {
                    echo 'push the image to docker hub' 
                }
                // sh "docker rmi $imageName:latest"
                sh "docker rmi $imageName:$BUILD_NUMBER"
            }
        }
    }
}
