#build all images
docker build -t ppoetz/multi-client:latest -t ppoetz/multi-client:"$GIT_SHA" -f ./client/Dockerfile ./client
docker build -t ppoetz/multi-server:latest -t ppoetz/multi-server:"$GIT_SHA" -f ./server/Dockerfile ./server
docker build -t ppoetz/multi-worker:latest -t ppoetz/multi-worker:"$GIT_SHA" -f ./worker/Dockerfile ./worker

docker push ppoetz/multi-client:latest
docker push ppoetz/multi-server:latest
docker push ppoetz/multi-worker:latest

docker push ppoetz/multi-client:"$GIT_SHA"
docker push ppoetz/multi-server:"$GIT_SHA"
docker push ppoetz/multi-worker:"$GIT_SHA"

# apply k8s config
kubectl apply -f k8s

kubectl set image deployments/client-deployment client=ppoetz/multi-client:"$GIT_SHA"
kubectl set image deployments/server-deployment server=ppoetz/multi-server:"$GIT_SHA"
kubectl set image deployments/worker-deployment worker=ppoetz/multi-worker:"$GIT_SHA"