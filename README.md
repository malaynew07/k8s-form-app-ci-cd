# 🚀 3-Tier Kubernetes Application with Jenkins CI/CD (KIND)

This project demonstrates a complete end-to-end DevOps workflow by deploying a **3-tier application** on Kubernetes using a **Jenkins Pipeline with SCM integration**.

The application stack:

- 🎨 Frontend – HTML, CSS, JavaScript (served by Nginx)
- ⚙️ Backend API – Node.js + Express
- 🗄️ MySQL Database – Stateful using PV & PVC (Retain policy)

The entire deployment is automated through a Jenkins Pipeline that pulls code from GitHub and applies Kubernetes manifests directly to a KIND cluster.

---

## 🏗️ Architecture

Flow:

Browser → Frontend → Backend API → MySQL (PVC)

---

## ☸️ Kubernetes Concepts Used

- Dedicated Namespace for isolation
- Deployments, Services, Labels & Selectors
- ConfigMap and Secret
- PersistentVolume (PV) and PersistentVolumeClaim (PVC) with Retain policy
- Stateful MySQL storage
- Reverse proxy communication between frontend and backend
- Real troubleshooting of CrashLoopBackOff, PVC binding, DNS, YAML, and storage issues

---

## 🐳 Docker

- Custom Docker image for backend
- Custom Docker image for frontend (Nginx serving static files)
- Images pushed to Docker Hub
- Kubernetes pulls images from registry

---

## 🔁 Jenkins CI/CD Pipeline (SCM Pulling)

A Jenkins Pipeline job is configured to:

1. Pull the repository from GitHub (SCM polling)
2. Read the Jenkinsfile
3. Execute kubectl apply
4. Deploy the entire application automatically to Kubernetes

Flow:

Git Push → Jenkins Pipeline → Kubernetes Deployment

---

## 📁 Project Structure

backend/
frontend/
k8s/
namespace.yml
mysql-pv.yml
mysql-pvc.yml
mysql-deployment.yml
backend-deployment.yml
frontend-deployment.yml
service.yml
configmap.yml
secret.yml
Jenkinsfile
README.md

## ▶️ Manual Deployment (without Jenkins)
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/mysql-pv.yml
kubectl apply -f k8s/mysql-pvc.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secret.yml
kubectl apply -f k8s/mysql-deployment.yml
kubectl apply -f k8s/backend-deployment.yml
kubectl apply -f k8s/frontend-deployment.yml
kubectl apply -f k8s/service.yml

Verification Steps:
Check pods:
     kubectl get pods -n form-app
Heck storage:
     kubectl get pv
     kubectl get pvc -n form-app
Verify database records:
     kubectl exec -it <mysql-pod> -n form-app -- mysql -u root -p
     USE formdb;
     SELECT * FROM users;

🧠 Key Learnings from This Project

While building this, several real-world issues were faced and resolved:

Nginx 403 due to wrong volume strategy

Kubernetes DNS vs browser networking confusion

PVC stuck in Pending due to storageClass mismatch

Backend CrashLoopBackOff due to DB initialization order

Jenkins lacking kubeconfig authentication

YAML indentation and volumeMount naming mistakes

CI pipeline path issues and automation drift

These troubleshooting steps provided deep practical understanding of Kubernetes and CI/CD.

✅ Outcome

A fully reproducible, automated, stateful Kubernetes deployment controlled by Jenkins CI/CD.

This project reflects practical, hands-on understanding of how DevOps works in real environments beyond theory.

🏷️ Tech Stack

Kubernetes • Docker • Jenkins • Node.js • MySQL • Git • KIND


👨💻 Author:
Malay Panigrahi

