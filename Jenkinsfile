// this pipeline is containing all the configuration attribute to trigger the jenkins shared test library
// Here we are not  explicitly declaring the @Library because we enable to load the library by default

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
    // testPipeline(configMap);
    // here the method name is same as filename in jenkins-shared-library repo which is our library
    nodejsEKSPipeline(configMap);
}