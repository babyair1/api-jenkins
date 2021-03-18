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
    
  }
}