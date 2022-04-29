FROM debian:stable-slim

RUN apt-get update \
  && apt-get -y install \
  --no-install-recommends \
  ca-certificates \
  curl \
  jq \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*


RUN ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
  && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
  && rm kubectl \
  && mkdir /.kube && chmod g+rwX /.kube

USER 1001

ENTRYPOINT ["kubectl"]
CMD ["--help"]
