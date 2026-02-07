# promoteous: 
kubectl create namespace prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus --namespace prometheus
helm list -n monitoring
#kubectl wait --for=condition=Ready pod --all --namespace=prometheus --timeout=120s
export prometheus_svc=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/name=prometheus,app.kubernetes.io/instance=prometheus"\
 -o jsonpath="{.items[0].metadata.name}")
kubectl get all -n monitoring

# Grafana : 
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install my-grafana grafana/grafana --namespace monitoring
helm list -n monitoring
kubectl get all -n monitoring
kubectl wait --for=condition=Ready pod --all --namespace=monitoring --timeout=120s
kubectl get secret --namespace monitoring my-grafana\
 -o jsonpath="{.data.admin-password}" | base64 --decode\
  > grafana-password.txt
echo ""
export POD_NAME=$(kubectl get pods --namespace monitoring\
 -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=my-grafana"\
  -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 3000 --address 0.0.0.0 &
kubectl --namespace prometheus port-forward $prometheus_svc 9090:80 --address 0.0.0.0 &
echo "All Done..."