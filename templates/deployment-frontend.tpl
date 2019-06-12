apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: eschool-frontend-deployment
  labels:
    app: eschool-frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      name: eschool-frontend
  template:
    metadata:
      labels:
        name: eschool-frontend
    spec:
      containers:
        - name: frontend-app
          image: eu.gcr.io/${project_id}/eschool-frontend:0.0.1
          imagePullPolicy: Always
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 90
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 90
            periodSeconds: 10
      imagePullSecrets:
        - name: gcr-json-key

---
apiVersion: v1
kind: Service
metadata:
  name: eschool-frontend-deployment
spec:
  selector:
    name: eschool-frontend
  ports:
    - port: 80
      protocol: TCP
      targetPort: 80
  loadBalancerIP: ${backend_ip}
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
      - ip: ${backend_ip}