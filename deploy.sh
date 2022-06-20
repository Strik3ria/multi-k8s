#!/bin/sh

docker build -t strik3ria/multi-client:latest -t strik3ria/multi-client:$SHA  -f ./client/Dockerfile ./client
docker build -t strik3ria/multi-server:latest -t strik3ria/multi-server:$SHA  -f ./server/Dockerfile ./server
docker build -t strik3ria/multi-worker:latest -t strik3ria/multi-worker:$SHA  -f ./worker/Dockerfile ./worker

docker push strik3ria/multi-client:latest
docker push strik3ria/multi-server:latest
docker push strik3ria/multi-worker:latest

docker push strik3ria/multi-client:$SHA
docker push strik3ria/multi-server:$SHA
docker push strik3ria/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=strik3ria/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=strik3ria/multi-worker:$SHA
kubectl set image deployments/client-deployment client=strik3ria/multi-client:$SHA
