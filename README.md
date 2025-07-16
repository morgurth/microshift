### Introduction

This repo is a fork of gnunn-gitops/microshift which demos using ACM + OpenShift GitOps for Microshift clusters.

I've modified it to work with Google Cloud DNS as the Cert Manager Solver for LetsEncrypt and adding in FoundryVTT Deployment for
a Virtual TableTop setup. The secrets used were created locally. I have considered updating to use the External Secrets Manager to
store them as a GCP Secret.

To apply the ACM polcies the first time you will need to use `oc create` and not `oc apply` since the yaml is too large and will
over the `last-configuration` annotation size limit. To deploy the policies do the following:

```
kustomize build components/policies/microshift-gitops/ | oc create -f -
```

If you want to make changes and update them then use `oc replace` after creating them at least once:

```
kustomize build components/policies/microshift-gitops/ | oc kustomize -f -
```
