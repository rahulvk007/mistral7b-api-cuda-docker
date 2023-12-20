## Mistral 7B API Self Contained Cuda Docker image

### Run

You can directly run the below command in your terminal to start the api server. It will automatically download the docker image I made from Github container registry.

```docker run --runtime=nvidia --gpus all  -e n_gpu_layers=15 -p 3000:8000 ghcr.io/rahulvk007/mistral7b-cuda-api:latest```

**n_gpu_layers** defines the number of layers to offload to your GPU. Entirely depends on your GPU VRAM. I have found that for 4 GB VRAM it is best to set it anywhere between 15 to 18 for a 7B model like this. You can experiment with various values. Setting it too high can cause it to crash with the error cuda ran out of memory.

Here the api server will be started at port 3000.

**NOTE**: You need to have nvidia driver and nvidia-container-toolkit installed on your system.

### Build

If you don't want to use the pre-built docker image and wants to build your own docker image, follow these steps:

- Clone this repo and create a folder named models. Inside the folder place the Openhermes 2.5 Mistral 7B 16K - GGUF file. You can download the model from [here](https://huggingface.co/TheBloke/OpenHermes-2.5-Mistral-7B-16k-GGUF). You can download any version you like, just change the name according to the filename in CMD command of Dockerfile. You can even try other models.
- To build the docker image, run ```DOCKER_BUILDKIT=0 docker build -t <imagename>:<tag> . ```
