# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
# TARGETARCH
# BUILDARCH

# FROM --platform=$BUILDPLATFORM alpine:3.16.2
FROM alpine:3.16.2

ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDARCH
# RUN echo "target:\"${TARGETPLATFORM}\" / \"${BUILDARCH}\""

RUN apk add --update --no-cache \
    ca-certificates \
    curl \
    file

ENV KUBECTL_VERSION=v1.25.2
# RUN KERNEL="$(uname --kernel-name | tr '[:upper:]' '[:lower:]')";
# RUN echo "KERNEL: '${KERNEL}'";
# RUN UNAME="$(uname)";
# RUN echo "UNAME: '${UNAME}'";
# RUN KERNEL="$(uname --kernel-name | tr '[:upper:]' '[:lower:]')"; \
#     ARCH="$(uname --machine | sed --expression='s/aarch64/arm64/' --expression='s/x86_64/amd64/')"; \
#     curl --fail --location --output /usr/local/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/${KERNEL:?}/${ARCH:?}/kubectl"; \
#     chmod +x /usr/local/bin/kubectl; \
#     # command -v kubectl; \
#     # kubectl version --client | grep --fixed-strings "${KUBECTL_VERSION:?}"
RUN curl -sLO --fail https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# vcluster install
#
ENV VCLUSTER_VERSION=v0.14.2
#
# linux amd
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then \
      curl -L -o vcluster \
        https://github.com/loft-sh/vcluster/releases/download/${VCLUSTER_VERSION}/vcluster-linux-amd64; \
    fi
#
# linux arm
RUN if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
      curl -L -o vcluster \
        https://github.com/loft-sh/vcluster/releases/download/${VCLUSTER_VERSION}/vcluster-linux-arm64; \
    fi
# # osx ?

RUN chmod +x vcluster
RUN mv vcluster /usr/local/bin;
