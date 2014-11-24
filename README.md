Jenkins deployment to a Cloud Foundry based PaaS
================================================

# Application Overview
<img style="float: left; width: 100px;" src="https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png"/>

[Jenkins](http://jenkins-ci.org/) is an open source continuous integration tool written in Java. It allows to create extensive test workflow and monitor this process with web UI. . You can find its sources in [Github repo](https://github.com/jenkinsci/jenkins). 

<p style="clear: both">

# Deploy to Cloud Foundry

There are several ways to deploy Jenkins to Cloud Foundry as an app. 

**Using custom buildpack and manifest:** `cf push`.

**Using java-buildpack:** you need to rebuild Jenkins with [build-for-using-tomcat.sh](https://github.com/Altoros/cf-example-jenkins/blob/master/build-for-using-tomcat.sh) script and run `cf push` (see [considerations](https://github.com/Altoros/cf-example-jenkins#considerations) for details).

After successful deployment you'll be able to see Jenkins using following URL `http://jenkins.<cloud-foundry-domain>/`.

## Considerations

### Using jenkins buildpack
The first and the easiest way is to use special buildpack. 
You will need specify `-b` parameter if you use command line to deploy Jenkins ([doc](http://docs.cloudfoundry.org/buildpacks/custom.html#deploying-with-custom-buildpacks)) or `buildpack` attribute in [manifest file](manifest.yml) ([doc](http://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html#buildpack)).

Deployment will look in the following way

Using command line arguments: 
```
cf push -p jenkins.war -b https://github.com/Altoros/jenkins-buildpack -m 2G jenkins
```
, where `-m` stands for app RAM memory, `-p` path to jar/war file with the application.

Using manifest: `cf push` ([manifest.yml](https://github.com/Altoros/cf-example-jenkins/blob/master/manifest.yml) will be automatically used).

### Using java buildpack

Cloud Foundry has a [java-buildpack](https://github.com/cloudfoundry/java-buildpack), that is commonly used to run Java applications. It has list of [possible frameworks](https://github.com/cloudfoundry/java-buildpack#examples) it can handle. This list of frameworks are iterated to find out suitable for application you push. [Main class](https://github.com/cloudfoundry/java-buildpack/blob/master/docs/container-java_main.md) has one of the first positions in this list. In the same time Jenkins has lots of dependencies and it's had to tell command that will gather all of them. Easier solution here is to make java-buildpack to run jenkins within tomcat. In order to do it, we will need to rebuild jenkins to "hide" Main class from java-buildpack. You can see build script in [build-for-using-tomcat.sh](build-for-using-tomcat.sh) file. Unfortunately, this way doesn't work well with all versions of Java buildpacks.

## Manifest
```yaml
applications:
  - name: jenkins
    path: jenkins.war
    buildpack: https://github.com/Altoros/jenkins-buildpack
    memory: 3G
```

## Troubleshooting
Jenkins is very demanding memory application: it is recomended to run Jenkins on instances with at least 2G of RAM. You can also change memory consumption with [parameters](https://wiki.jenkins-ci.org/display/JENKINS/Starting+and+Accessing+Jenkins) in [srating command](http://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html#start-commands) or [build attributes](http://docs.oracle.com/javase/7/docs/technotes/tools/windows/java.html).


## Questions
You can leave your questions in issues of this project. 

