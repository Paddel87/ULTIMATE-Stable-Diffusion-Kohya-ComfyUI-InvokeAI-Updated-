#!/bin/bash

# Start Automatic1111
cd /workspace/stable-diffusion-webui && \
    nohup python launch.py --listen --port 3000 --enable-insecure-extension-access --ckpt-dir /workspace/flux/models --lora-dir /workspace/flux/loras --outdir-samples /workspace/flux/highres > /workspace/logs/automatic1111.log 2>&1 &

# Start Kohya_ss
cd /workspace/kohya_ss && \
    nohup python gui.py --listen 0.0.0.0 --server_port 3010 --output_dir /workspace/flux/highres --model_dir /workspace/flux/models --lora_model_dir /workspace/flux/loras > /workspace/logs/kohya.log 2>&1 &

# Start ComfyUI
cd /workspace/ComfyUI && \
    nohup python main.py --listen --port 3020 --checkpoints-dir /workspace/flux/models --loras-dir /workspace/flux/loras --output-directory /workspace/flux/highres > /workspace/logs/comfyui.log 2>&1 &

# Start InvokeAI
cd /workspace/InvokeAI && \
    nohup invokeai-web --outdir /workspace/flux/highres > /workspace/logs/invokeai.log 2>&1 &

# Start Jupyter Lab
nohup jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' > /workspace/logs/jupyter.log 2>&1 &

# Start RunPod File Uploader
nohup runpod-uploader > /workspace/logs/runpod-uploader.log 2>&1 &

# Keep container running
tail -f /dev/null