curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
wget https://github.com/kubernetes/kops/releases/download/v1.32.0/kops-linux-amd64
chmod +x kops-linux-amd64 kubectl
mv kubectl /usr/local/bin/kubectl
mv kops-linux-amd64 /usr/local/bin/kops
aws s3api create-bucket --bucket tarun-kops-testbkt143333.k8s.local --region ap-south-1 --create-bucket-configuration LocationConstraint=ap-south-1
aws s3api put-bucket-versioning --bucket tarun-kops-testbkt143333.k8s.local --region ap-south-1 --versioning-configuration Status=Enabled
export KOPS_STATE_STORE=s3://tarun-kops-testbkt143333.k8s.local
kops create cluster --name=tarun.k8s.local --zones=ap-south-1a,ap-south-1b --control-plane-count=1 --control-plane-size=t3.medium --node-count=2 --node-size=t3.small --node-volume-size=20 --control-plane-volume-size=20 --ssh-public-key=my-keypair.pub --image=ami-02d26659fd82cf299 --networking=calico --topology=public
kops update cluster --name tarun.k8s.local --yes --admin
