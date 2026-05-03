@Library('jenkins-shared-library-test') _

def configMap = [
    project: "roboshop",
    component: "catalogue"
]

echo "Triggering the library pipeline"

if (env.BRANCH_NAME.equalsIgnoreCase('main')) {
     // will see later
} else {
    // feature branch
    // here the method name is same as filename in jenkins-shared-library-test repo which is our library
    testPipeline(configMap);
}

