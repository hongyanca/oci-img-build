# syntax=docker/dockerfile:1
# https://quay.io/repository/jupyter/pytorch-notebook?tab=tags
FROM quay.io/jupyter/pytorch-notebook:latest

USER root

RUN apt-get update && \
   NEEDRESTART_MODE=a apt-get -o APT::Get::Always-Include-Phased-Updates=true upgrade -y && \
   apt-get install -y --no-install-recommends dnsutils iputils-ping htop swig

RUN pip3 uninstall torch torchvision torchaudio -y && \
  pip3 install nvitop torch torchvision torchaudio

