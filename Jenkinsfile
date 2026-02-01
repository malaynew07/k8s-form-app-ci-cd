pipeline {
    agent any

    environment {
        KUBE_NAMESPACE = "form-app"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/malaynew07/k8s-form-app-ci-cd.git'
            }
        }

        stage('Create Namespace') {
            steps {
                sh 'kubectl apply -f k8s/namespace.yml'
            }
        }

        stage('Create PV & PVC') {
            steps {
                sh '''
                kubectl apply -f k8s/mysql-pv.yml
                kubectl apply -f k8s/mysql-pvc.yml

                echo "Waiting for PVC to be Bound..."
                while true; do
                  STATUS=$(kubectl get pvc mysql-pvc -n $KUBE_NAMESPACE -o jsonpath='{.status.phase}')
                  if [ "$STATUS" = "Bound" ]; then
                    echo "PVC Bound"
                    break
                  fi
                  sleep 3
                done
                '''
            }
        }

        stage('Apply Configs') {
            steps {
                sh '''
                kubectl apply -f k8s/configmap.yml
                kubectl apply -f k8s/secret.yml
                '''
            }
        }

        stage('Deploy MySQL') {
            steps {
                sh '''
                kubectl apply -f k8s/mysql-deployment.yml
                kubectl wait --for=condition=ready pod -l app=mysql -n $KUBE_NAMESPACE --timeout=180s
                '''
            }
        }

        stage('Deploy Backend & Frontend') {
            steps {
                sh '''
                kubectl apply -f k8s/backend-deployment.yml
                kubectl apply -f k8s/frontend-deployment.yml
                kubectl apply -f k8s/service.yml

                kubectl wait --for=condition=ready pod -l app=backend -n $KUBE_NAMESPACE --timeout=180s
                kubectl wait --for=condition=ready pod -l app=frontend -n $KUBE_NAMESPACE --timeout=180s
                '''
            }
        }
    }
}

