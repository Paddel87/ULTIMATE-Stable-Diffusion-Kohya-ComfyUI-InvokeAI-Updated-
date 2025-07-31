# RunPod Template: ULTIMATE Stable Diffusion Kohya ComfyUI InvokeAI (Updated)

This template provides a comprehensive environment for image generation with Stable Diffusion and includes the most popular tools set up with current software.

## Included Software

*   **Operating System:** Ubuntu 22.04 LTS
*   **CUDA:** 12.8
*   **Python:** 3.11
*   **Torch:** 2.8.0
*   **Jupyter Lab**
*   **Automatic1111 Stable Diffusion Web UI:** Latest version from GitHub
*   **Kohya_ss:** Latest version from GitHub
*   **ComfyUI:** Latest version from GitHub
*   **InvokeAI:** Latest version from GitHub (v6.2.0+)

### Pre-installed Models

*   `sd_xl_base_1.0.safetensors`
*   `sd_xl_refiner_1.0.safetensors`
*   `sdxl_vae.safetensors`
*   `inswapper_128.onnx` (for Face Swapping)

## Ports

| Connection Port | Internal Port | Description                                |
| :-------------- | :------------ | :----------------------------------------- |
| `3000`          | `3000`        | A1111 Stable Diffusion Web UI              |
| `3010`          | `3010`        | Kohya_ss                                   |
| `3020`          | `3020`        | ComfyUI                                    |
| `9090`          | `9090`        | InvokeAI                                   |
| `8888`          | `8888`        | Jupyter Lab (no password set)              |
| `2999`          | `2999`        | RunPod File Uploader                       |

## Usage

After starting the pod, all applications will start automatically. You can access the web UIs via the corresponding ports.

## Logs

The log files for each application can be found in the `/workspace/logs/` directory:

*   **Stable Diffusion Web UI:** `/workspace/logs/automatic1111.log`
*   **Kohya SS:** `/workspace/logs/kohya.log`
*   **ComfyUI:** `/workspace/logs/comfyui.log`
*   **InvokeAI:** `/workspace/logs/invokeai.log`
*   **Jupyter Lab:** `/workspace/logs/jupyter.log`

You can follow the logs live with the `tail` command, for example:

```bash
tail -f /workspace/logs/webui.log
```

## Changing Start Parameters

The start parameters for the applications are defined in the `/start.sh` script. You can edit this file to change flags or arguments. After a change, you must restart the pod for the changes to take effect.