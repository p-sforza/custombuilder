# Golang Custom Builder
The golang custom builder is golang builder for OpenShift

1. To build the custom builder on OCP
```
 oc new-build https://github.com/p-sforza/custombuilder
```
This will create the builder image that we will use to compile go code and create target image with binary injected

2. Create the target go image build-config using the created builder (note that you need to be system admin to create a custom build strategy or enable the role system:build-strategy-custom to the user)
```
oc adm policy add-cluster-role-to-user system:build-strategy-custom developer
oc apply -f buildconfig.yaml
oc start-build golang-ex 
```
3. Finally create the app 
```
oc create -f deploymentconfig.yaml
```

# Outside OpenShift
On your docker platform you can 

1. build the builder image:
```
git clone https://github.com/p-sforza/custombuilder
cd custombuilder
docker build . --file Dockerfile --tag go-custom-docker-builder
```
2. run builder to test or debug your code (note that docker.sock needed for docker ops within the builder):
```
docker run -it --privileged -v /run/docker.sock:/run/docker.sock go-custom-docker-builder bash
git clone <my_go_repo> <my_path>
cd <my_path>
go build my_bynary
cat > Dockerfile <<- EOF
FROM openshift/origin-base 
COPY my_bynary $HOME
CMD  $HOME/my_binary
EOF

docker build --rm -t my_final_image .
docker push my_final_image
exit
```
3. finally run your image
docker run my_final_image

