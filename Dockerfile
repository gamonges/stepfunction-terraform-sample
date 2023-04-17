FROM --platform=linux/x86_64 amazonlinux:2

ENV TF_VERSION=1.3.3 \
    TFMER_VERSION=0.8.22 \
    TFMER_PROVIDER=aws

RUN yum -y -q update && \
    yum -y -q install unzip wget less

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin/ && \
    rm -f awscliv2.zip

RUN wget -q https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin/

RUN curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/${TFMER_VERSION}/terraformer-${TFMER_PROVIDER}-linux-amd64 && \
    chmod +x terraformer-${TFMER_PROVIDER}-linux-amd64 && \
    mv terraformer-${TFMER_PROVIDER}-linux-amd64 /usr/local/bin/terraformer