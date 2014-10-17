git clone https://github.com/jenkinsci/jenkins.git
cd jenkins
 
mvn clean
mvn install -Dmavem.test.skip=true
 
cd war # this is important ! :)
 
# change pom.xml
# Remove following lines: 
#  <manifest>
#    <mainClass>Main</mainClass>
#  </manifest> 
sed "/<\/manifest>/d" pom.xml | sed "/<manifest>/d" | sed "/<mainClass>Main<\/mainClass>/d" > pom.xml
 
mvn clean
mvn install -Dmavem.test.skip=true
 
cf push jenkins -p target/jenkins.war 
