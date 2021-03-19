pipeline{
  agent any

  environment {
    DOCKER_TAG = getDockerTag()
  }
  stages{
    
    stage ('install dependencies'){
      steps{
        echo "start install dependencies"  
        sh "npm install"  
      }
    }
    stage ('test project'){
      steps{
        echo "run test project"
      }
    }
    stage ('build docker images'){
      steps{
        script{
          app = docker.build("yosafatdeny/nodeapp")
        }
      }
    }
    stage ('test image'){
      steps{
        sh'docker run -d --rm --name testcontainer -p 8081:80 yosafatdeny/nodeapp'
        input message: "Finished test image?(Click procced to continue"
      }
    }
    stage ('cleanup docker'){
      steps{
        sh 'docker stop testcontainer'
      }
    }
    stage ('push image'){
      steps{
        script{
          docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-yosafatdeny'){
            app.push("${DOCKER_TAG}")
            app.push("latest")
          }
        }
      }
    }
    stage ('cleanup images'){
      steps{
        sh 'docker rmi yosafatdeny/nodeapp'
      }
    }
    stage ('deploy app'){
      steps{
        sh "chmod +x changeTag.sh"
        sh "./changeTag.sh ${DOCKER_TAG}"
        withKubeConfig([credentialsId: 'kubeconfig-clusterjcde', serverUrl: 'https://34.101.189.159']){
          sh 'kubectl apply -f deployment-config.k8s.yaml'
        }
      }
    }


  }
}

def getDockerTag(){
  def tag = sh script: "git rev-parse HEAD", returnStdout: true
  return tag
}