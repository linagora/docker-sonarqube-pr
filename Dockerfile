#
# docker build -t linagora/sonarqube-pr .
#
# Docker container with configured SonarQube + Github and Atlassian Stash Pull Request plugins
#

FROM sonarqube:5.4

ADD sonar-github-plugin-1.1.jar /opt/sonarqube/extensions/plugins/sonar-github-plugin-1.1.jar
ADD sonar-stash-plugin-1.1.0-SNAPSHOT.jar /opt/sonarqube/extensions/plugins/sonar-stash-plugin-1.1.0-SNAPSHOT.jar

VOLUME /qualityprofile

ADD start_with_profile.sh /opt/sonarqube/start_with_profile.sh

ENTRYPOINT ["/opt/sonarqube/start_with_profile.sh"]
