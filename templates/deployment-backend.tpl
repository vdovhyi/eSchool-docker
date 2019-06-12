apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: eschool-backend-deployment
  labels:
    app: eschool-backend
spec:
  replicas: 2
  selector:
    matchLabels:
      name: eschool-backend
  template:
    metadata:
      labels:
        name: eschool-backend
    spec:
      containers:
        - name: backend-app
          image: eu.gcr.io/${project_id}/eschool-backend:0.0.1
          readinessProbe:
            httpGet:
              path: /ui/login
              port: 8080
            initialDelaySeconds: 90
            periodSeconds: 10
        - name: cloudsql-proxy
          image: gcr.io/cloudsql-docker/gce-proxy:1.11
          command: ["/cloud_sql_proxy", "--dir=/cloudsql",
                    "-instances=${project_id}:${region}:${db_instance_name}=tcp:3306",
                    "-credential_file=/secrets/cloudsql/credentials.json"]
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
            - name: ssl-certs
              mountPath: /etc/ssl/certs
            - name: cloudsql
              mountPath: /cloudsql
      volumes:
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
        - name: cloudsql
          emptyDir:
        - name: ssl-certs
          hostPath:
            path: /etc/ssl/certs

---
apiVersion: v1
kind: Service
metadata:
  name: eschool-backend-deployment
spec:
  selector:
    name: eschool-backend
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  loadBalancerIP: ${backend_ip}
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
      - ip: ${backend_ip}