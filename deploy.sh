# Build the docker images
docker build -t carlanders/multi-client:latest -t carlanders/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t carlanders/multi-server:latest -t carlanders/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t carlanders/multi-worker:latest -t carlanders/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Push the images to DockerHub
docker push carlanders/multi-client:latest
docker push carlanders/multi-server:latest
docker push carlanders/multi-worker:latest

docker push carlanders/multi-client:$SHA
docker push carlanders/multi-server:$SHA
docker push carlanders/multi-worker:$SHA

# Apply new configs to cluster
kubectl apply -f k8s

# Set latest image on each deployment
kubectl set image deployments/server-deployment server=carlanders/multi-server:$SHA
kubectl set image deployments/client-deployment client=carlanders/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=carlanders/multi-worker:$SHA