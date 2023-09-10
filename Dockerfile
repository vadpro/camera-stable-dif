FROM python:3.8.17-bullseye

ARG DEBIAN_FRONTEND=noninteractive

# Create Virtual Display
RUN apt update \
    && apt-get install -y xorg xserver-xorg-video-dummy ffmpeg

# TODO: Install conda from this docs -> https://docs.conda.io/projects/miniconda/en/latest/
RUN mkdir -p ~/miniconda3
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
RUN bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
RUN rm -rf ~/miniconda3/miniconda.sh
RUN ~/miniconda3/bin/conda init bash

# TODO: Install stablediffusion
RUN ~/miniconda3/bin/conda install python=3.8.17
RUN ~/miniconda3/bin/conda install pytorch==1.12.1 torchvision==0.13.1 -c pytorch
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN pip install transformers==4.19.2 diffusers invisible-watermark --retries 20

RUN git clone https://github.com/Stability-AI/stablediffusion.git
RUN cd stablediffusion
RUN pip install -e . \

# TODO: Check if this need
#RUN pip install git+https://github.com/huggingface/transformers

COPY ./docker/camera-stable-dif/req.txt /requirements/req.txt
RUN pip install --upgrade pip && pip install --no-cache -r /requirements/req.txt

# Entrypoint
COPY ./docker/camera-stable-dif/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app
