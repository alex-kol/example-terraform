#!/bin/bash

tee /home/ubuntu/.ssh/id_rsa.tmp << EOT
${data_ssh}
EOT

base64 -d /home/ubuntu/.ssh/id_rsa.tmp >> /home/ubuntu/.ssh/id_rsa && \
rm /home/ubuntu/.ssh/id_rsa.tmp && \
chmod 600 /home/ubuntu/.ssh/id_rsa && \
chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa && \
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/ubuntu/.ssh/config && \

apt-get update && \
apt install -y unzip python3-pip && \
pip3 install boto3 datetime && \
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
unzip awscliv2.zip && \
./aws/install && \
rm -rf /home/ubuntu/aws && \
mkdir /home/ubuntu/.aws && \
