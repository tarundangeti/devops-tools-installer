apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: mb-daemonset
  labels:
    app: bank
spec:
  selector:
    matchLabels:
      app: bank
  template:
    metadata:
      labels:
        app: bank
  spec:
    containers:
      - name: conti1
        image: tarundangeti/mobilebankingimg
