# bananaz-pipelines
 @actions for different projects

## Description
* The `SOFT` file is for running tests / ensuring the project can compile.
* The `RELEASE` is for building the project and bundling in a Docker Image for distribution.

Each respective language gets a unique pipeline for all occasions.

Some projects within the same language have unique requirements, ex the Java [bot-core](https://github.com/BananazTechnology/bot-core) is a local release to GitHub Packages so it does not have any Docker Image building while everything in `java-app` folder does.

## Docs
* [Sharing workflows in organizations](https://docs.github.com/en/actions/using-workflows/sharing-workflows-secrets-and-runners-with-your-organization)
* [Reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
