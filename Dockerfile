FROM hashicorp/terraform:1.4.5

# yarnのインストール
RUN apk update && apk add bash curl nodejs busybox-extras
RUN touch ~/.bashrc \
  && curl -o- -L https://yarnpkg.com/install.sh | bash \
  && ln -s "$HOME/.yarn/bin/yarn" /usr/local/bin/yarn

RUN apk add --no-cache py-pip jq \
 && pip install --upgrade \
        pip \
        awscli

ENV PATH="/usr/local/aws-cli/v2/*/bin:/usr/bin:/usr/sbin:${PATH}"
