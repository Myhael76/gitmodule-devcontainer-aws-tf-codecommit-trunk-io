# Reusable git submodule for AWS Terraforming with devcontainers

The purpose of this repository is to offer a reusable devcontainer to be reused with multiple AWS provisioning projects having the following needs:

1. Use Terraform
2. Use aws and ssh credentials shared from the host

    - This approach helps with single sign on for multiple projects
    - Note the `.aws` and .`ssh` mounts in the `devcontainer.json`

3. Package all necessary IDE and client tools in the devcontainer without installing anything in the host

    - trunk.io super-linter
    - aws toolkit
    - aws q
    - git interaction tools, including the plugin for `codecommit://` urls

