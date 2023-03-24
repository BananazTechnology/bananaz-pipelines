# bananaz-pipelines
 @actions for different projects

## Description
* Head inside `.github/workflows` folder first

This project currently supports two types of code bases:
  * NodeJS
  * Java

Each project language requires a unique pipeline file in its own repos `.github/workflows` folder, you can use examples available under [pipeline-examples](./pipeline-examples/) as reference.

During a commit the message must contain these unique keywords to operate certain features:
| Language | Keyword | Description |
|---|---|---|
| NodeJS | N/A | Runs a build to ensure your app does not fail loading |
| NodeJS | `[release]` | Compiles app and builds Docker images |
| Java | N/A | Runs a `mvn verify` to ensure app builds |
| Java | `[package]` | Compiles app and uploads to GitHub Maven repo |
| Java | `[release]` | Compiles app and builds Docker images |

## Repo Secrets
| Secret Name | Secret Description |
|---|---|
| DOCKERHUB_USERNAME | Username for the public Docker Hub account to push images to when available |
| DOCKERHUB_TOKEN | Secret API token for accessing the Docker Hub account |
| SONAR_HOST_URL | The URL of the available prod SonarQube server |
| SONAR_TOKEN | An API token for accessing SonarQube |
| GH_USERNAME | The Bananaz service account for accessing all private repos and features |
| GH_TOKEN | The GitHub access token for accessing the service account |

## Scripts
The `scripts` folder contains scripts that are used in special pipelines, it also might container other helpful DevOps tools.

## Docs
* [Getting started with org workflows](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization)
* [Sharing workflows in organizations](https://docs.github.com/en/actions/using-workflows/sharing-workflows-secrets-and-runners-with-your-organization)
* [Reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
