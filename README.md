![Archived](https://img.shields.io/badge/Current_Status-archived-blue?style=flat)


# docker-sonarqube-pr
Dockerized SonarQube web server https://registry.hub.docker.com/u/harbur/sonarqube/

The main goal of this repository is to bring a dockerized SonarQube with pull request plugins (GitHub & Stash).


# Usage
Build the image
```
$ docker build -t linagora/sonarqube-pr .
```

Run the container
```
$ docker run --name sonarqube -v $PWD/qualityprofile:/qualityprofile -p 9000:9000 -p 9002:9002 --env-file ./env.file linagora/sonarqube-pr
```

# Configuration

You may add additional configuration which will brings you a read to run environment.

## Quality Profile

SonarQube default profiles may not fit what you are looking for.
You may import your already configured quality profile in SonarQube.
In order to achieve this, just put the exported file in the qualityprofile volume and rename it to _qualityprofile.xml_:
```
$ cp java-sonar-way-63782.xml qualityprofile/qualityprofile.xml
```

Then, you have to set the corresponding **LANGUAGE** & **PROFILE_NAME** variables in the _env.file_.

## Project

You may want to have a already defined project, in order to achieve this, provide the corresponding **PROJECT_NAME** & **PROJECT_KEY** variables in the _env.file_.

## Admin user

You may want to have an administrator user other than the default.
In this case, provide the corresponding **USER_LOGIN**, **USER_NAME** & **USER_PASSWORD** variables in the _env.file_.

Note that the default administrator will be deactivated.


# How to make SonarQube comments my PRs

SonarQube will put comments on a PR (GitHub or Stash), by comparing the issues he already knows to the issues resulting of an analysis on the PR branch.
This meens that you have to publish to SonarQube the result of an analysis first.

A good practice is to publish to SonarQube when building your master branch (when merging PR).
To achieve that, you may use the following command:
```
$ docker run --link sonarqube:sonarqube \
  --entrypoint /opt/sonar-runner-2.4/bin/sonar-runner \
  -e SONAR_USER_HOME=/data/.sonar-cache \
  -v `pwd`:/data -u `id -u` sebp/sonar-runner \
    -Dsonar.host.url=http://SONAR_IP:9000 \
    -Dsonar.projectName=PROJECT_NAME \
    -Dsonar.projectKey=PROJECT_KEY \
    -Dsonar.projectVersion=1.0 \
    -Dsonar.sources=. \
    -Dsonar.analysis.mode=publish
```
Where:
  - **SONAR_IP**: is the IP of your SonarQube instance (ex.: 172.17.0.2)
  - **PROJECT_NAME** & **PROJECT_KEY**: is the SonarQube project (see Configuration -> Project)

To comment a PR, you may use the following command for GitHub:
```
$ docker run --link sonarqube:sonarqube \
  --entrypoint /opt/sonar-runner-2.4/bin/sonar-runner \
  -e SONAR_USER_HOME=/data/.sonar-cache \
  -v `pwd`:/data -u `id -u` sebp/sonar-runner \
    -Dsonar.host.url=http://SONAR_IP:9000 \
    -Dsonar.projectName=PROJECT_NAME \
    -Dsonar.projectKey=PROJECT_key \
    -Dsonar.projectVersion=1.0 \
    -Dsonar.sources=. \
    -Dsonar.analysis.mode=preview \
    -Dsonar.github.oauth=GITHUB_TOKEN \
    -Dsonar.github.repository=GITHUB_REPO \
    -Dsonar.github.pullRequest=GITHUB_PR_NUMBER
```
Where:
  - **SONAR_IP**: is the IP of your SonarQube instance (ex.: 172.17.0.2)
  - **PROJECT_NAME** & **PROJECT_KEY**: is the SonarQube project (see Configuration -> Project)
  - **GITHUB_TOKEN**: is your GitHub token
  - **GITHUB_REPO**: is your GitHub repo (ex.: user/repo)
  - **GITHUB_PR_NUMBER**: is the PR number

To comment a PR, you may use the following command for Stash:
```
$ docker run --link sonarqube:sonarqube \
  --entrypoint /opt/sonar-runner-2.4/bin/sonar-runner \
  -e SONAR_USER_HOME=/data/.sonar-cache \
  -v `pwd`:/data -u `id -u` sebp/sonar-runner \
    -Dsonar.host.url=http://SONAR_IP:9000 \
    -Dsonar.projectName=PROJECT_NAME \
    -Dsonar.projectKey=PROJECT_KEY \
    -Dsonar.projectVersion=1.0 \
    -Dsonar.sources=. \
    -Dsonar.analysis.mode=preview \
    -Dsonar.stash.url=STASH_URLhttps://ci.open-paas.org/stash \
    -Dsonar.stash.notification  \
    -Dsonar.stash.comments.reset  \
    -Dsonar.stash.reviewer.approval=true \
    -Dsonar.stash.project=STASH_PROJECT \
    -Dsonar.stash.repository=STASH_REPO \
    -Dsonar.stash.pullrequest.id=STASH_PR_NUMBER \
    -Dsonar.stash.login=STASH_LOGIN \
    -Dsonar.stash.password=STASH_PASSWORD
```
Where:
  - **SONAR_IP**: is the IP of your SonarQube instance (ex.: 172.17.0.2)
  - **PROJECT_NAME** & **PROJECT_KEY**: is the SonarQube project (see Configuration -> Project)
  - **STASH_URL**: is your Stash URL (ex.: https://IP/stash)
  - **STASH_PROJECT**: is your Stash project
  - **STASH_REPO**: is your Stash repo
  - **STASH_PR_NUMBER**: is the PR number
  - **STASH_LOGIN**: is the Stash user used
  - **STASH_PASSWORD**: is its password
