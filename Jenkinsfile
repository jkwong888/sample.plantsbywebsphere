node {
   def mvnHome
   stage('Preparation') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/jkwong888/sample.plantsbywebsphere.git'
      // Get the Maven tool.
      // ** NOTE: This 'M3' Maven tool must be configured
      // **       in the global configuration.           
      mvnHome = tool 'maven'
   }
   stage('Maven Build') {
      // Run the maven build
      if (isUnix()) {
         sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore clean package"
      } else {
         bat(/"${mvnHome}\bin\mvn" -Dmaven.test.failure.ignore clean package/)
      }
   }
   stage('Docker Build') {
      withCredentials([string(credentialsId: 'openshift-jenkins-token', variable: 'OPENSHIFT_TOKEN')]) {
        // some block
        sh """
        /usr/local/bin/oc login https://ocp311.ibmcase.cloudns.cx --token=${OPENSHIFT_TOKEN}
        """
        def docker_cred = sh returnStdout: true, script: 'echo -n `oc whoami -t`'
        
        sh """
        docker login registry.app311.ibmcase.cloudns.cx -u openshift -p ${docker_cred}
        
        docker build -t registry.app311.ibmcase.cloudns.cx/plantsbywebsphere/plants:${env.BUILD_ID} .
        docker push registry.app311.ibmcase.cloudns.cx/plantsbywebsphere/plants:${env.BUILD_ID}
        
        # TODO: use buildah instead of docker (if slaves can't run docker)
        #buildah bud --creds 'openshift:${docker_cred}' -t plants:${env.BUILD_ID} .
        #buildah push --creds 'openshift:${docker_cred}' plants:${env.BUILD_ID} docker://registry.app311.ibmcase.cloudns.cx/plantsbywebsphere/plants:${env.BUILD_ID}
        """
      }
   }
}
