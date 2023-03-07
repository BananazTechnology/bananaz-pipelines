# bananaz-pipelines
 @actions for different projects

## Description
* Head inside `workflows` folder first
* The `SOFT` file is for running tests / ensuring the project can compile.
* The `RELEASE` is for building the project and bundling in a Docker Image for distribution.

Each respective language gets a unique pipeline for all occasions.

Some projects within the same language have unique requirements, ex the Java [bot-core](https://github.com/BananazTechnology/bot-core) is a local release to GitHub Packages so it does not have any Docker Image building while everything in `workflows/java-app` folder does.

## Repo Secrets
| Secret Name | Secret Description |
|---|---|
| DOCKERHUB_USERNAME | Username for the public Docker Hub account to push images to when available |
| DOCKERHUB_TOKEN | Secret API token for accessing the Docker Hub account |
| SONAR_HOST_URL | The URL of the available prod SonarQube server |
| SONAR_TOKEN | An API token for accessing SonarQube |
| GH_USERNAME | The Bananaz service account for accessing all private repos and features |
| GH_TOKEN | The GitHub access token for accessing the service account |

## Docs
* [Getting started with org workflows](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization)
* [Sharing workflows in organizations](https://docs.github.com/en/actions/using-workflows/sharing-workflows-secrets-and-runners-with-your-organization)
* [Reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
