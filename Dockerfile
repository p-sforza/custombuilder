#FROM openshift/origin-base
FROM registry.fedoraproject.org/f29/s2i-base:latest

ENV NAME=golang \
    VERSION=1.11 \
    ARCH=x86_64 \
    HOME=/root

ENV SUMMARY="Platform for building and running Go $VERSION based applications" \
    DESCRIPTION="Go $VERSION available as container is a base platform for \
building and running various Go $VERSION applications and frameworks. \
Go is an easy to learn, powerful, statically typed language in the C/C++ \
tradition with garbage collection, concurrent programming support, and memory safety features."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Go $VERSION" \
      io.openshift.tags="builder,golang,golang18,rh-golang18,go" \
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      architecture="$ARCH" \
      maintainer="pierluigi sforza <pierluigi.sforza@gmail.com>" \
      usage="docker run $FGC/$NAME"

RUN INSTALL_PKGS="gettext automake make docker golang" && \
    dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
# COPY ./s2i/bin/ $STI_SCRIPTS_PATH
# RUN chown -R 1001:0 $STI_SCRIPTS_PATH && chown -R 1001:0 /opt/app-root

COPY build.sh /tmp/build.sh
RUN  chmod +x /tmp/build.sh && \
     chown -R 1001:0 /tmp/build.sh && \
     chmod -R g+rw   /tmp/build.sh

CMD ["/tmp/build.sh"]
