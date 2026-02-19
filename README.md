# **POS APP** by _React_
> *SECTIONS :*
- [About](#about)
- [Docker](#docker)
- [website screenshots](#screenshot-of-website)
- [ArgoCD](#screenshot-of-argocd-application-gitops-website)
- [Monitoring](#monitoring)

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


This repository is developed by [Siva Sethuraj](https://github.com/sivasethuraj)
