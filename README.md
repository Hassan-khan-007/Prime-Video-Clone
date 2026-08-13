🎬 Prime Video Clone - Cloud-Native Deployment & CI/CD Pipeline
A containerized, production-grade React application deployed on a local Kubernetes cluster using Docker, Kind (Kubernetes in Docker), and GitHub Actions CI/CD.

🏗️ Architecture & Complete Deployment Flow
This project follows a modern DevOps and CloudOps lifecycle. The end-to-end execution flow is structured as follows:

1. Application Containerization (Docker)
Multi-Stage Build: A multi-stage Dockerfile is utilized to efficiently build the React frontend (Create React App).

Builder Stage: Uses a Node.js Alpine base image to install dependencies (npm ci) and compile the production assets (npm run build).

Runner Stage: Leverages a lightweight static file server (serve) to serve the compiled build artifacts on port 3000 securely under a non-root environment.

2. Infrastructure & Orchestration (Kubernetes)
Manifests Setup: Declarative Kubernetes configurations (deployment.yaml, service.yaml) are written to manage the application lifecycle.

Caching & Services: An accompanying Redis deployment and service are configured alongside the app to support caching and scaling capabilities.

Health Probes: HTTP liveness and readiness probes are integrated to continuously monitor pod health and availability.

3. Automated CI/CD Pipeline (GitHub Actions)
Code changes pushed to the main branch automatically trigger the GitHub Actions workflow.

The pipeline spins up an ephemeral (temporary) Kubernetes cluster using Kind (Kubernetes in Docker) directly within the runner environment.

Robust Error Diagnostics: Integrated bash error handling catches deployment and rollout issues gracefully, automatically dumping kubectl describe pod details and container logs if a timeout occurs.

🛠️ Step-by-Step Local Execution & Testing Guide
To run, test, and verify this deployment locally on your machine, follow these steps:

Step 1: Clone the Repository & Build Docker Image
git clone https://github.com/your-username/Prime-Video-Clone.git
cd Prime-Video-Clone
docker build -t prime-video-app:v1 .
Step 2: Spin Up a Local Kubernetes Cluster (Kind)
kind create cluster
Step 3: Load the Docker Image into Kind
Since the Kind cluster runs in an isolated container environment, load your locally built image directly into it:
kind load docker-image prime-video-app:v1
Step 4: Apply Kubernetes Manifests
Deploy the application and its auxiliary services:
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f redis-deployment.yaml
kubectl apply -f redis-service.yaml
Step 5: Verify Pod Status
Check if all pods and services are running successfully:
kubectl get pods
kubectl get svc
Step 6: Access the Application via Port-Forwarding
Establish a secure port-forwarding tunnel to your local cluster:
kubectl port-forward service/prime-video-service 3000:3000

Then run this command to seee the webside
http://localhost:3000

