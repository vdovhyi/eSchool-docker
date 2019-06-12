<?xml version='1.1' encoding='UTF-8'?>
<project>
    <description>Job eSchool backend</description>
    <keepDependencies>false</keepDependencies>
    <properties>
        <hudson.plugins.disk__usage.DiskUsageProperty plugin="disk-usage@0.28"/>
        <com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty plugin="gitlab-plugin@1.5.12">
            <gitLabConnection></gitLabConnection>
        </com.dabsquared.gitlabjenkins.connection.GitLabConnectionProperty>
        <hudson.plugins.throttleconcurrents.ThrottleJobProperty plugin="throttle-concurrents@2.0.1">
            <categories class="java.util.concurrent.CopyOnWriteArrayList"/>
            <throttleEnabled>false</throttleEnabled>
            <throttleOption>project</throttleOption>
            <limitOneJobWithMatchingParams>false</limitOneJobWithMatchingParams>
            <paramsToUseForLimit></paramsToUseForLimit>
        </hudson.plugins.throttleconcurrents.ThrottleJobProperty>
    </properties>
    <scm class="hudson.plugins.git.GitSCM" plugin="git@3.10.0">
        <configVersion>2</configVersion>
        <userRemoteConfigs>
            <hudson.plugins.git.UserRemoteConfig>
                <url>https://github.com/IF-090Java/eSchool.git</url>
            </hudson.plugins.git.UserRemoteConfig>
        </userRemoteConfigs>
        <branches>
            <hudson.plugins.git.BranchSpec>
                <name>*/master</name>
            </hudson.plugins.git.BranchSpec>
        </branches>
        <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
        <submoduleCfg class="list"/>
        <extensions/>
    </scm>
    <canRoam>true</canRoam>
    <disabled>false</disabled>
    <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
    <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
    <triggers/>
    <concurrentBuild>false</concurrentBuild>
    <builders>
        <hudson.plugins.sonar.SonarRunnerBuilder plugin="sonar@2.8.1">
            <project></project>
            <properties>sonar.projectKey=my:backend
sonar.projectName=My backend
sonar.projectVersion=1.0
sonar.sources=.
sonar.exclusions=**/*.java</properties>
            <javaOpts></javaOpts>
            <additionalArguments></additionalArguments>
            <jdk>(Inherit From Job)</jdk>
            <task></task>
        </hudson.plugins.sonar.SonarRunnerBuilder>
        <hudson.tasks.Maven>
            <targets>clean package</targets>
            <mavenName>Maven_name</mavenName>
            <usePrivateRepository>false</usePrivateRepository>
            <settings class="jenkins.mvn.DefaultSettingsProvider"/>
            <globalSettings class="jenkins.mvn.DefaultGlobalSettingsProvider"/>
            <injectBuildVariables>false</injectBuildVariables>
        </hudson.tasks.Maven>
        <hudson.tasks.Shell>
            <command>cp -r /tmp/ansible/docker_backend $WORKSPACE/
cp /tmp/ansible/files/application.properties $WORKSPACE/docker_backend
docker build -t eschool-backend -f  docker_backend/Dockerfile .
docker tag eschool-backend eu.gcr.io/${project_id}/eschool-backend:0.0.1
gcloud auth activate-service-account --key-file /tmp/ansible/.ssh/${google_json_key_name}
gcloud docker -- push eu.gcr.io/${project_id}/eschool-backend
gcloud container clusters get-credentials ${kubernetes_cluster_name} --zone ${zone} --project ${project_id}
kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=/tmp/ansible/.ssh/${google_json_key_name}
kubectl create secret generic cloudsql-db-credentials --from-literal=username=${db_user} --from-literal=password=${db_pass}
kubectl apply -f /tmp/ansible/kubernetes/deployment_backend.yml</command>
        </hudson.tasks.Shell>
    </builders>
    <publishers/>
    <buildWrappers>
        <hudson.plugins.ws__cleanup.PreBuildCleanup plugin="ws-cleanup@0.37">
            <deleteDirs>false</deleteDirs>
            <cleanupParameter></cleanupParameter>
            <externalDelete></externalDelete>
            <disableDeferredWipeout>false</disableDeferredWipeout>
        </hudson.plugins.ws__cleanup.PreBuildCleanup>
    </buildWrappers>
</project>