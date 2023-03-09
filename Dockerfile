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

# # linux amd
# #RUN curl -s -L "https://github.com/loft-sh/vcluster/releases/latest" | sed -nE 's!.*"([^"]*vcluster-linux-amd64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o vcluster && chmod +x vcluster;
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then \
      curl -L -o vcluster \
        https://github.com/loft-sh/vcluster/releases/download/v0.12.2/vcluster-linux-amd64; \
    fi
# RUN curl -L -o vcluster \
#     https://github.com/loft-sh/vcluster/releases/download/v0.12.2/vcluster-linux-amd64

# # linux arm
# # RUN curl -s -L "https://github.com/loft-sh/vcluster/releases/latest" | sed -nE 's!.*"([^"]*vcluster-linux-arm64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o vcluster && chmod +x vcluster;
RUN if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then \
      curl -L -o vcluster \
        https://github.com/loft-sh/vcluster/releases/download/v0.12.2/vcluster-linux-arm64; \
    fi
# RUN curl -L -o vcluster \
#     https://github.com/loft-sh/vcluster/releases/download/v0.12.2/vcluster-linux-arm64

# # osx ?

RUN chmod +x vcluster
RUN mv vcluster /usr/local/bin;
