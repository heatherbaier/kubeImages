# Use an official Python runtime as a parent image
FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel

# Set the working directory in the container
WORKDIR /app

#These are keys for NVIDIA software packages.
#Necessary due to the CUDA elements of the base image.
#Otherwise, the apt-get update calls will fail.
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

RUN apt-get install -y apt-transport-https

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    git-lfs 

# Install and configure kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

# Install Prefect 2
RUN pip install --ignore-installed geopandas rasterio rioxarray scikit-learn neo4j psycopg2

# Copy the current directory contents into the container at /app
ADD . /app

# # Run when the container launches
# CMD ["prefect", "version"]
