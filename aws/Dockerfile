# syntax=docker/dockerfile:1
FROM amazonlinux:latest
LABEL vendor=contact@yanhong.ca
ARG CACHEBUST=1
RUN yum update -y \
    && yum install util-linux unzip zsh nano groff iputils bind-utils -y \
    && yum clean all \
    && mkdir /root/.aws \
    && cd /root \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-`lscpu | grep Architecture | grep -Eo 'aarch64|x86_64'`.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && /root/aws/install \
    && rm /root/awscliv2.zip \
    && rm -rf /root/aws \
    && echo 'set nowrap' > /root/.nanorc \
    && echo 'set tabsize 4' >> /root/.nanorc \
    && echo 'set tabstospaces' >> /root/.nanorc \
    && echo 'unset mouse' >> /root/.nanorc \
    && echo "export PROMPT='%n %/ %# '" > /root/.zshrc \
    && useradd -m -s /usr/bin/zsh alice \
    && cp /root/.nanorc /home/alice/.nanorc \
    && cp /root/.zshrc /home/alice/.zshrc \
    && mkdir /home/alice/.aws \
    && chown alice:alice /home/alice/.nanorc \
    && chown alice:alice /home/alice/.zshrc \
    && chown alice:alice /home/alice/.aws \
    && useradd -m -s /usr/bin/zsh bob \
    && cp /root/.nanorc /home/bob/.nanorc \
    && cp /root/.zshrc /home/bob/.zshrc \
    && mkdir /home/bob/.aws \
    && chown bob:bob /home/bob/.nanorc \
    && chown bob:bob /home/bob/.zshrc \
    && chown bob:bob /home/bob/.aws \
    && useradd -m -s /usr/bin/zsh charlie \
    && cp /root/.nanorc /home/charlie/.nanorc \
    && cp /root/.zshrc /home/charlie/.zshrc \
    && mkdir /home/charlie/.aws \
    && chown charlie:charlie /home/charlie/.nanorc \
    && chown charlie:charlie /home/charlie/.zshrc \
    && chown charlie:charlie /home/charlie/.aws

CMD ["/bin/zsh"]
