node ("dockerslave") {
    def app

    stage('Clone repository') {
        /* Let's make sure we have the repository cloned to our workspace */

        checkout scm
    }

    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */

        app = docker.build("dtr.andreas.dtcntr.net/docker-cemea/my-test-app")
    }

    stage('Aqua MicroScanner') {
        /* This step scans the image for high vulnerabilities and
         * FAILS if any are found */

        aquaMicroscanner imageName: 'dtr.andreas.dtcntr.net/docker-cemea/my-test-app:latest', notCompliesCmd: 'exit1', onDisallowed: 'fail', outputFormat: 'html'
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * Just an example */

        app.inside {
            sh 'curl --fail http://localhost:5000 || exit 1'
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
        docker.withRegistry('dtr.andreas.dtcntr.net', 'DTRUserPassword') {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }
    }

    stage('Deploy a service on Docker Enterprise') {
        sh "cd /home/jenkins && \
        source env.sh && \
        docker service update --image dtr.olly.dtcntr.net/fakeco-prod/demo-app:latest demo_webapp"
     }
}