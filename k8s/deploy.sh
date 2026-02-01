#!/bin/bash
set -e

echo "Deleting old namespace if exists..."
kubectl delete ns form-app --ignore-not-found
sleep 5

echo "Creating namespace..."
kubectl apply -f namespace.yml

echo "Creating PV & PVC..."
kubectl apply -f mysql-pv.yml
kubectl apply -f mysql-pvc.yml

echo "Waiting for PVC to be Bound..."
while true; do
  STATUS=$(kubectl get pvc mysql-pvc -n form-app -o jsonpath='{.status.phase}')
  if [ "$STATUS" = "Bound" ]; then
    echo "PVC is Bound ✅"
    break
  fi
  sleep 3
done

echo "Applying ConfigMap & Secret..."
kubectl apply -f configmap.yml
kubectl apply -f secret.yml

echo "Deploying MySQL..."
kubectl apply -f mysql-deployment.yml

echo "Waiting for MySQL pod to be Ready..."
kubectl wait --for=condition=ready pod -l app=mysql -n form-app --timeout=180s

echo "Deploying Backend, Frontend & Services..."
kubectl apply -f backend-deployment.yml
kubectl apply -f frontend-deployment.yml
kubectl apply -f service.yml

echo "Waiting for Backend & Frontend..."
kubectl wait --for=condition=ready pod -l app=backend -n form-app --timeout=180s
kubectl wait --for=condition=ready pod -l app=frontend -n form-app --timeout=180s

echo "✅ Deployment completed successfully"
echo "Now run your port-forward script."

