# Stage 1: Build Environment
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04 AS builder

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WORKSPACE=/workspace

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    wget \
    unzip \
    python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install InvokeAI v6.2.0
WORKDIR $WORKSPACE
RUN git clone --branch v6.2.0 https://github.com/invoke-ai/InvokeAI.git
WORKDIR $WORKSPACE/InvokeAI
RUN pip install --no-cache-dir torch==2.3.1 torchvision==0.18.1 --index-url https://download.pytorch.org/whl/cu121
RUN pip install --no-cache-dir .
RUN invokeai-configure --yes

# Install Automatic1111 Stable Diffusion WebUI
WORKDIR $WORKSPACE
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

# Install Kohya_ss
WORKDIR $WORKSPACE
RUN git clone https://github.com/bmaltais/kohya_ss.git
WORKDIR $WORKSPACE/kohya_ss
RUN pip install --no-cache-dir -r requirements.txt

# Install ComfyUI
WORKDIR $WORKSPACE
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR $WORKSPACE/ComfyUI
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Final Image
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

ENV WORKSPACE=/workspace
WORKDIR $WORKSPACE

# Copy virtual environment from builder stage
COPY --from=builder /opt/venv /opt/venv

# Copy applications from builder stage
COPY --from=builder $WORKSPACE/InvokeAI $WORKSPACE/InvokeAI
COPY --from=builder $WORKSPACE/stable-diffusion-webui $WORKSPACE/stable-diffusion-webui
COPY --from=builder $WORKSPACE/kohya_ss $WORKSPACE/kohya_ss
COPY --from=builder $WORKSPACE/ComfyUI $WORKSPACE/ComfyUI

# Set path to use venv
ENV PATH="/opt/venv/bin:$PATH"

# Create directories for FLUX models
RUN mkdir -p $WORKSPACE/flux/models \
    && mkdir -p $WORKSPACE/flux/loras \
    && mkdir -p $WORKSPACE/flux/highres

# Install RunPod File Uploader
RUN curl -sSL https://github.com/kodxana/RunPod-FilleUploader/raw/main/scripts/installer.sh -o installer.sh && chmod +x installer.sh && ./installer.sh

# Expose ports
EXPOSE 3000 3010 3020 9090 8888 2999

# Start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]