# **POS APP** by _React_
> *SECTIONS :*
- [About](#about)
- [Docker](#docker)
- [website screenshots](#screenshot-of-website)
- [ArgoCD](#screenshot-of-argocd-application-gitops-website)
- [Monitoring](#monitoring)
- [CI CD](#ci-cd)

## About :

- Point of sale website
- Completely developed on react framework and bootstrap
- Consists of _inventory, Billing, request item, Sales report_ pages

## Available Scripts

In the project directory, you can run:

###Steps to run the project
`npm install`

It installs the necessary dependency packages

### `npm start`

Runs the app in the development mode.\
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.\
You may also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.\
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `npm run build`

Builds the app for production to the `build` folder.\
It correctly bundles React in production mode and optimizes the build for the best performance.

Your app is ready to be deployed!

## Docker

on root level, run the command

`docker build .`

## Screenshot of website

- **Main Menu**

  > ![main menu](</images/Screenshot%20(54).png>)

- **Billing**

  > ![main menu](</images/Screenshot%20(55).png>)

  > ![main menu](</images/Screenshot%20(56).png>)

  > ![main menu](</images/Screenshot%20(57).png>)

  > ![main menu](</images/Screenshot%20(58).png>)

- **Inventory**

  > ![main menu](</images/Screenshot%20(59).png>)

  > ![main menu](</images/Screenshot%20(60).png>)

- **Item Request**

  > ![main menu](</images/Screenshot%20(61).png>)

- **Sales Report**

  > ![main menu](</images/Screenshot%20(62).png>)

## Screenshot of ArgoCD application gitops website

- **ArgoCD**
  > ![main menu](</images/Screenshot 2026-01-27 085316.png>) > ![main menu](</images/Screenshot 2026-01-27 124349.png>) > ![main menu](</images/Screenshot 2026-01-27 124900.png>) > ![main menu](</images/Screenshot 2026-01-27 124931.png>)

---
# **Monitoring**
## Prometheus
- Prometheus is a powerful open-source monitoring and alerting toolkit widely used for Kubernetes environments. It collects, stores, and queries time-series metrics, enabling detailed performance analysis of Kubernetes clusters, including nodes, pods, and services.

## Grafana
- Grafana, a powerful open-source platform for visualizing and analyzing data.

*What is Grafana?*  
- Grafana is a leading data visualization and monitoring tool that allows you to create interactive dashboards and graphs to gain insights from your data. It supports a wide range of data sources, including databases, cloud services, and time series databases like Prometheus and InfluxDB.

## **Installation Steps**
> ### Prometheus  
```sh
kubectl create namespace prometheus

# Adding grafana repo to helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Installing grafana via helm
helm install prometheus prometheus-community/prometheus --namespace prometheus

#Viewing all resources in monitoring namespace
helm list -n monitoring
export prometheus_svc=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus"\
 -o jsonpath="{.items[0].metadata.name}")
kubectl get all -n monitoring
```
> ### Grafana  
```sh
# Adding grafana repo to helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace monitoring

# Installing grafana via helm
helm install my-grafana grafana/grafana --namespace monitoring

#Viewing all resources in monitoring namespace
helm list -n monitoring
kubectl get all -n monitoring
kubectl wait --for=condition=Ready pod --all --namespace=monitoring --timeout=120s

#password for grafana ui stored in grafana-password.txt file
kubectl get secret --namespace monitoring my-grafana\
 -o jsonpath="{.data.admin-password}" | base64 --decode\
  > grafana-password.txt

# creating environment variable POD_NAME for port forard
export POD_NAME=$(kubectl get pods --namespace monitoring\
 -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=my-grafana"\
  -o jsonpath="{.items[0].metadata.name}")
```
> ### Accessing web UI 
* Here i am using kubectl port-forward because i am practicing this on killerkoda website
```sh
kubectl --namespace monitoring port-forward $POD_NAME 3000 --address 0.0.0.0 &
kubectl --namespace prometheus port-forward $prometheus_svc 9090:80 --address 0.0.0.0 &
echo "All Done..."
```
## Screenshot of Monitoring
> ![prometheus_data source](</images/grafana/image-1.png>)
> ![prometheus_data source](</images/grafana/image-2.png>)
> ![prometheus_data source](</images/grafana/image-3.png>)
> ![prometheus_data source](</images/grafana/image-4.png>)
> ![prometheus_data source](</images/grafana/image-5.png>)
> ![prometheus_data source](</images/grafana/image-6.png>)
> ![prometheus_data source](</images/grafana/image-7.png>)
> ![prometheus_data source](</images/grafana/image.png>)
## grafana dashboards
> ![grafana dashboards](</images/grafana/screenshot-1770450840213.png>)

> ![grafana dashboards](</images/grafana/Screenshot_7-2-2026_132255_a2e870ab7f40-10-244-4-37-3000.papa.r.killercoda.com.jpeg>)


# **CI CD**
## Jenkins:
### *What is CI/CD and Jenkins?*

- CI/CD stands for Continuous Integration and Continuous Delivery/Deployment, which are practices in software development aimed at automating and streamlining the process of building, testing, and deploying applications. These practices ensure faster and more reliable software delivery by integrating code changes frequently and automating the deployment process.

- Jenkins is an open-source automation server widely used to implement CI/CD pipelines. It helps developers automate tasks such as building, testing, and deploying applications, making it a cornerstone of modern DevOps workflows.

### Key Features of Jenkins in CI/CD

- *Continuous Integration*: Automatically integrates code changes into a shared repository and runs tests to ensure the codebase remains stable.

- *Continuous Delivery*: Automates the deployment of tested code to staging or production environments, ensuring it is always in a deployable state.

- *Continuous Deployment*: Extends delivery by automatically deploying changes to production without manual intervention.

- Jenkins achieves this through its pipeline-driven approach, where workflows are defined as code using a Jenkinsfile. This file can be written in either Declarative or Scripted syntax, allowing teams to customize their pipelines.

How Jenkins Works in CI/CD

- Source Code Integration: Jenkins integrates with version control systems like Git to detect code changes.

- Automated Builds: When changes are committed, Jenkins triggers a build process using tools like Maven or Gradle.

- Testing: Jenkins runs automated tests (unit, integration, performance) to ensure code quality.

- Deployment: If tests pass, Jenkins deploys the application to staging or production environments using tools like Docker, Kubernetes, or cloud platforms.

Here in my this repositry Jenkins pipeline will:
---
- Fetch the latest code from a Git repository.

- Build the application and package it into a Docker container.

- Run automated tests to validate functionality.

- Deploy the container to a Kubernetes cluster.
- Post pipeline stage notifies either pipeline failed or succeed

![Jenkins Pipeline Diagram](</images/jenkins/diagram-pipeline.png>)

### installation script:
```sh
#java
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
java -version

#jenkins
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins -y

#jenkins service
sudo systemctl enable jenkins &&\
sudo systemctl start jenkins && \
sudo cat /var/lib/jenkins/secrets/initialAdminPassword > jenkins-password.txt
echo "jenkins password saved on jenkins-password.txt file"

#post actions to attach necessary permissions
sudo usermod -aG docker jenkins && sudo usermod -aG docker $USER
```

- After installed java and jenkins 
  - Jenkins server runs on port 8080
  - Configure security group for 8080 port
  - Open your http://<public-ip>:8080
  - InitialAdminPassword is stored in jenkins-password.txt file
  - Setup user account
  - Click manage jenkins > plug-in > search docker pipeline
  - Install plug-in and restart jenkins
  - Click credential > + > username & password > provide your Docker Hub username and for password field create secret token in Docker Hub
  - Important step is provide a id field
  - Because it must same in here and pipeline code
  - Click + icon in jenkins home page create a job, provide name and description click pipeline
  - Copy and paste the jenkins file in pipeline script
  - Save and click build 
  - Alternatively configure webhook in github

  ## Screenshot of Jenkins CI / CD
> ![jenkins](</images/jenkins/Screenshot_11-2-2026_194951_07a8db8967bb-10-244-7-51-8080.spch.r.killercoda.com.jpeg>)
> ![jenkins](</images/jenkins/Screenshot_13-2-2026_145634_766f4ec50df1-10-244-5-170-8080.papa.r.killercoda.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_17-2-2026_75536_7db47c35c270-10-244-6-130-8080.papa.r.killercoda.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_17-2-2026_75554_7db47c35c270-10-244-6-130-8080.papa.r.killercoda.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_19-2-2026_2031_e78c3c6bb08b-10-244-4-29-8080.spch.r.killercoda.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_25-2-2026_83418_hub.docker.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_25-2-2026_83534_b9d7b4d43337-10-244-6-59-8080.papa.r.killercoda.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_25-2-2026_8359_hub.docker.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_25-2-2026_83616_b9d7b4d43337-10-244-6-59-8080.papa.r.killercoda.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_25-2-2026_83653_b9d7b4d43337-10-244-6-59-8080.papa.r.killercoda.com.jpeg>)

> ![jenkins](</images/jenkins/Screenshot_25-2-2026_84012_killercoda.com.jpeg>)