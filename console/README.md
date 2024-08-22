Start a local OpenShift cluster to browse and manage Microshift. This leverages
the pre-built console image at `quay.io/openshift/origin-console:4.17.0`.

To make this work you need to create a service account in Microshift with whatever
permissions you want. The script `provision-console-sa.sh` will create a `console`
ServiceAccount in `kube-system`.

The `console.sh` script will run the console, it assumes you are using the aforementioned
`console` ServiceAccount but if not you can tweak the environment variables in
the script to use what you want.

So the basic steps to get this working are:

1. Setup a remote kubeconfig for Microshift on your local PC as per the Microshift docs
2. `export KUBECONFIG=<Location of Microshift config>`
3. Run the provision-console-sa.sh script, only needs to be run once
4. Run the console.sh script, once it is running the console is available on `localhost:9000`

Note the `console.sh` script creates a token for the `console` ServiceAccount that lasts for
2 hours. Feel free to tweak the duration or switch to an unlimited expiration token if preferred however
I would recommend sticking with a time limited token.
