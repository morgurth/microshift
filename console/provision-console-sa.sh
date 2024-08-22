kubectl create serviceaccount console -n kube-system
kubectl create clusterrolebinding console --clusterrole=cluster-admin --serviceaccount=kube-system:console
