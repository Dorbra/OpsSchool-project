# Session 3 - Homework

- Full details in the Class's presentation and video.

## What we know:

- We learned how to integrate with GitHub - to edit our code, push it, and get a new build status without doing anything manually.
- We also installed Docker on our Jenkins Agent and created a docker from a Dockerfile.
- Now let’s do a full CD release: integrate with DockerHub and upload our image to a registry.

## Tasks:

### Task 1

- A DockerHub account is required for this task. If you don't have one yet, please create it.
- Configure DockerHub credentials in Jenkins:
  - In your Jenkins left menu click on `Credentials` -> `System` -> `Global Credentials` -> `Add credentials`.
    - Add your DockerHub username and password.
    - ID: `dockerhub.<your_dockerhub_username>`
    - Description: `Access to DockerHub (user: <your_dockerhub_username>)`

### Task 2

- Check with `Jenkins Pipeline Syntax Generator` how to run the command `withDockerRegistry`.
- Change the `devops-pipeline-run-docker` Jenkins job to a Docker image with your own DockerHub registry.
- Add to `devops-pipeline-run-docker` Jenkins job the `withDockerRegistry` command, and inside it:
  - `customImage.push()`
- Run the build and make sure that the new Docker was pushed to your DockerHub.
- Send me your Jenkins pipeline code, and the output of your Jenkins job.

### Task 3

- Install the following plugins:
  - `Build Monitor View`.
  - `BlueOcean Aggregator`.
  - `Slack Notification`.
