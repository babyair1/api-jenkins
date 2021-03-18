pipeline {
  agent any

  stages{    
    stage ('install dependecies'){
      steps{
        sh "npm install"
      }
    }
    stage ('unit testing'){
        steps{
          echo "run unit testing"
        }
    }
    stage('Build and test image'){
      steps{
        echo "build docker images"
        script{
          api = docker.build("sendykris/qlass-api")
        }
        echo "run container for test image"
        sh "docker run -d --rm --name testapi -p 8081:2017 sendykris/qlass-api"
        input message: "Finished test image? (click proceed to continue)"
        
        echo "cleanup container testapi"
        sh "docker stop testapi"
      }
    }
    stage('push image'){
      steps{
        script{
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub.sendykris')
            api.push("${DOCKER_TAG}")
            api.push("latest")
          }
        }
        echo "Cleanup image"
        sh 'docker rmi sendykris/qlass-api'
      }
    }
    stage("deploy"){
      steps{
        sh "chmod +x changeTag.sh"
        sh "./changeTag.sh ${DOCKER_TAG}"
        withKubeConfig([credentialsId: '', serverUrl: 'https://34.101.65.135']){
          sh 'kubectl apply -f deployment-config.k8s.yaml'
        }
      }
    }
  }

def getDockerTag(){
  def tag = sh script: "git rev-parse HEAD", returnStdout: true
  return tag
}
