#!groovy

pipeline {

  // agent defines where the pipeline will run.
  agent {
    label {
      label("newbuildtest")
    }
  }

  // The options directive is for configuration that applies to the whole job.
  options {
    buildDiscarder(logRotator(numToKeepStr:'5', daysToKeepStr: '7'))
    disableConcurrentBuilds()
    timestamps()
    // as we "checkout scm" as a stage, we do not need to do it here too
    skipDefaultCheckout(true)
  }

  stages {
    stage("Checkout") {
      steps {
        timeout(time: 2, unit: 'HOURS') {
          checkout scm
        }
      }
    }
    
    stage("Build") {
        steps {
            echo "Building"
            timeout(time: 16, unit: 'HOURS') {
              bat """
                  jenkins_build.bat
                  jenkins_build.bat DEBUG
              """
            }
        }
    }

  }
}
