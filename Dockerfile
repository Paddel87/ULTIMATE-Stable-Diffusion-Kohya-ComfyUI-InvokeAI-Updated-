# Base image with PyTorch, CUDA 12.8, and Python 3.11
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WORKSPACE=/workspace

# Create workspace directory
RUN mkdir -p $WORKSPACE
WORKDIR $WORKSPACE

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install InvokeAI
RUN git clone https://github.com/invoke-ai/InvokeAI.git && \
    cd InvokeAI && \
    pip install -e . && \
    invokeai-configure --yes

# Install Automatic1111 Stable Diffusion WebUI
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

# Install Kohya_ss
RUN git clone https://github.com/bmaltais/kohya_ss.git && \
    cd kohya_ss && \
    pip install -r requirements.txt

# Install ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    pip install -r requirements.txt

# Create directories for FLUX models
RUN mkdir -p $WORKSPACE/flux/models
RUN mkdir -p $WORKSPACE/flux/loras
RUN mkdir -p $WORKSPACE/flux/highres



# Install RunPod File Uploader
RUN curl -sSL https://github.com/kodxana/RunPod-FilleUploader/raw/main/scripts/installer.sh -o installer.sh && chmod +x installer.sh && ./installer.sh

# Expose ports
EXPOSE 3000 3010 3020 9090 8888 2999

# Start script (to be created)
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]