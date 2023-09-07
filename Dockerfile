FROM amazonlinux:2

# zip

RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash - 
RUN yum update -y && \
yum -y install nodejs jq openssl tar gzip git curl unzip && \
yum clean all && \
rm -rf /var/cache/yum

# aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && \
./aws/install && aws --version

# k8s tools 
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh && \
chmod 700 get_helm.sh && \
./get_helm.sh && \
rm ./get_helm.sh && \
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
chmod 700 ./kubectl && mv kubectl /usr/local/bin 
# helm-ssm a nice utility to inject ssm parameters into helm values files
RUN git clone https://github.com/romeritoCL/helm-ssm && \
cd helm-ssm && git checkout patch-1 && helm plugin install ./ && cd - 
ENV TERM=xterm
RUN sh -c "$(curl -sSL https://git.io/install-kubent)"


CMD ["node"]
