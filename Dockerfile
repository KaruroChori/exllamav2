FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 as build

ENV RUN_UID=1000

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ninja-build python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Setup user which will run the service
RUN useradd -m -u $RUN_UID user
USER user


WORKDIR /app
COPY --chown=user requirements.txt /app

RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt
RUN pip install flask==2.3.2

COPY --chown=user . /app


USER root

STOPSIGNAL SIGINT

ENTRYPOINT ["/bin/bash"]
