#!/bin/bash
# This will install PSO Explorer into the test drive environment
# Nick Bodmer 7.16.20

# Add Helm repo for PSO Explorer
echo "#### Add, update helm repos and install PSO Explorer####"
helm repo add pso-explorer 'https://raw.githubusercontent.com/PureStorage-OpenConnect/pso-explorer/master/'
helm repo update
helm search repo pso-explorer -l

# Create namespace
kubectl create namespace psoexpl

# Install with default settings
helm install pso-explorer pso-explorer/pso-explorer --namespace psoexpl
