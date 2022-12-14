From nvidia/cuda:11.7.0-devel-ubuntu18.04
LABEL maintainer "Seong DongHyun <sdh238222@gmail.com>"

# Updating Ubuntu Packages
RUN apt-get update && yes|apt-get upgrade

# Requirements Package Add
RUN apt-get install -y --no-install-recommends \
    apt-utils build-essential ca-certificates \
    git ffmpeg vim libsndfile1-dev flac unzip sox curl \
    make automake cmake zlib1g-dev wget gfortran libtool subversion \
    gawk bc libfreetype6-dev zsh tmux htop net-tools ssh sudo \
    && rm -rf /var/lib/apt/lists/*

# Install miniconda3
RUN curl -o /tmp/miniconda.sh -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh
RUN conda update -y conda

# User Setting
ARG USER_NAME=dhseong
RUN adduser --disabled-password --quiet --gecos "" $USER_NAME \
    && echo "${USER_NAME}:ehd023648!" | chpasswd \
    && adduser $USER_NAME sudo \
    && echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && chmod 0440 /etc/sudoers

# SSH Setting
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
USER $USER_NAME

# Make github folder
RUN mkdir -p /home/$USER_NAME/work/github

# Auto Play (basrc)
RUN echo "sudo service ssh start" >> ~/.bashrc

WORKDIR /home/$USER_NAME
