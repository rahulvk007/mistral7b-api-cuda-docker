FROM nvidia/cuda:11.8.0-devel-ubuntu22.04


ENV CUDA_DOCKER_ARCH=all
# set some environment variable for better NVIDIA compatibility
ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility

# We need to set the host to 0.0.0.0 to allow outside access
ENV HOST 0.0.0.0

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y git build-essential \
    python3 python3-pip gcc wget \
    ocl-icd-opencl-dev opencl-headers clinfo \
    libclblast-dev libopenblas-dev \
    && mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

WORKDIR /llama-cpp-python
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git .
COPY . .

# setting build related env vars
ENV CUDA_DOCKER_ARCH=${CUDA_DOCKER_ARCH}
ENV LLAMA_CUBLAS=1

RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on"  pip install -e .[server]

ENV n_gpu_layers=1
EXPOSE 8000
# Run the server
CMD python3 -m llama_cpp.server --host 0.0.0.0 --port 8000 --model models/openhermes-2.5-mistral-7b-16k.Q4_K_M.gguf --chat_format chatml --n_gpu_layers ${n_gpu_layers}
