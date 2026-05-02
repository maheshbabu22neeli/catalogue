pipeline {
    agent {
        node {
            label 'ROBOSHOP'
        }
    }
    environment {
        project = "roboshop"
        course = "devOps"
        APP_VERSION = ""
    }
    options {
        // disableConcurrentBuilds()
        // cancel pipeline due to timeout
        timeout(
            time: 5,
            unit: 'MINUTES'
        )
    }
    /* parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
        text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
        booleanParam(name: 'DEPLOY', defaultValue: false, description: 'Deployment Required?')
        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
        password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
    } */
    stages {
        stage('Read Version') {
            steps {
                script {
                    // Read the package.json file into a Groovy object
                    def packageJSON = readJSON file: 'package.json'

                    // Access the version field
                    def packageVersion = packageJSON.version

                    echo "Current Version: ${packageVersion}"

                    // Optionally, set it as a global environment variable
                    APP_VERSION = packageVersion
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    sh """
                       npm install
                    """
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    sh """
                        docker build -t catalogue:${APP_VERSION} .
                    """
                }
            }
        }
    }
    post {
        always {
            echo 'I will always says hello world'
        }
        success {
            echo 'Job Success'
        }
        failure {
            echo 'Job Failure'
        }
    }

}