#!/usr/bin/env bash

kubectl port-forward -n apps deploy/content-store 8080:8080 &
kubectl port-forward -n licensify deploy/licensify-frontend 8081:8080 &
kubectl port-forward -n apps deploy/local-links-manager 8082:8080 &
kubectl port-forward -n apps deploy/locations-api 8083:8080 &
kubectl port-forward -n apps deploy/places-manager 8084:8080 &
kubectl port-forward -n apps deploy/publishing-api 8085:8080 &
kubectl port-forward -n apps deploy/search-api 8086:8080 &
