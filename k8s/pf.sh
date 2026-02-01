#!/bin/bash 
sudo -E kubectl port-forward svc/frontend-service 82:80 -n form-app
