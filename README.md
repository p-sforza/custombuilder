# Golang Custom Builder
The golang custom builder is golang builder for OpenShift

To build the custom builder on OCP
```
 oc new-build https://github.com/p-sforza/custombuilder
```
This will create the builder image that we will use to compile go code and create target image with binary injected



# Outside OpenShift
On your docker platform you can 

1. build the builder image:
```
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

