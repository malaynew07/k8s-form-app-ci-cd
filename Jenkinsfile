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
                sh 'kubectl apply -f namespace.yml'
            }
        }

        stage('Create PV & PVC') {
            steps {
                sh '''
                kubectl apply -f mysql-pv.yml
                kubectl apply -f mysql-pvc.yml

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
                kubectl apply -f configmap.yml
                kubectl apply -f secret.yml
                '''
            }
        }

        stage('Deploy MySQL') {
            steps {
                sh '''
                kubectl apply -f mysql-deployment.yml
                kubectl wait --for=condition=ready pod -l app=mysql -n $KUBE_NAMESPACE --timeout=180s
                '''
            }
        }

        stage('Deploy Backend & Frontend') {
            steps {
                sh '''
                kubectl apply -f backend-deployment.yml
                kubectl apply -f frontend-deployment.yml
                kubectl apply -f service.yml

                kubectl wait --for=condition=ready pod -l app=backend -n $KUBE_NAMESPACE --timeout=180s
                kubectl wait --for=condition=ready pod -l app=frontend -n $KUBE_NAMESPACE --timeout=180s
                '''
            }
        }
    }
}

