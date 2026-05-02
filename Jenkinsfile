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
        AWS_ACCOUNT_ID = "204427113986"
        AWS_REGION = "us-east-1"
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

        // by reaching this stage, we need to create a github token and add in Jenkins credentials
        stage('Dependabot Alerts Check') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    script {
                        def owner = 'maheshbabu22neeli'
                        def repo  = 'catalogue'

                        def response = sh(
                            script: """
                                curl -s -w "\\n%{http_code}" \\
                                    -H "Authorization: Bearer ${GITHUB_TOKEN}" \\
                                    -H "Accept: application/vnd.github+json" \\
                                    -H "X-GitHub-Api-Version: 2022-11-28" \\
                                    "https://api.github.com/repos/${owner}/${repo}/dependabot/alerts?severity=high,critical&state=open&per_page=100"
                            """,
                            returnStdout: true
                        ).trim()

                        def parts      = response.tokenize('\n')
                        def httpStatus = parts[-1].trim()
                        def body       = parts[0..-2].join('\n')

                        if (httpStatus != '200') {
                            error "GitHub API call failed with HTTP ${httpStatus}. Check token permissions (security_events scope required).\nResponse: ${body}"
                        }

                        def alerts = readJSON text: body

                        if (alerts.size() == 0) {
                            echo "✅ No HIGH or CRITICAL Dependabot alerts found. Pipeline continues."
                        } else {
                            echo "🚨 Found ${alerts.size()} HIGH/CRITICAL Dependabot alert(s):"
                            alerts.each { alert ->
                                def pkg      = alert.security_vulnerability?.package?.name ?: 'unknown'
                                def severity = alert.security_advisory?.severity?.toUpperCase() ?: 'UNKNOWN'
                                def summary  = alert.security_advisory?.summary ?: 'No summary'
                                def fixedIn  = alert.security_vulnerability?.first_patched_version?.identifier ?: 'No fix available'
                                echo "❌ [${severity}] ${pkg} — ${summary} (Fixed in: ${fixedIn})"
                            }
                            error "Pipeline failed: ${alerts.size()} HIGH/CRITICAL Dependabot alert(s) detected."
                        }
                    }
                }
            }
        }


        stage('Build Docker Image') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${AWS_REGION}") {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                        docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/roboshop/catalogue:${APP_VERSION} .
                        docker push 204427113986.dkr.ecr.${AWS_REGION}.amazonaws.com/roboshop/catalogue:${APP_VERSION}
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