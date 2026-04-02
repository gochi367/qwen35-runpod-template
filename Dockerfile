FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    python3-pip \
    curl \
    tmux \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://hf.co/cli/install.sh | bash
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /opt
RUN git clone https://github.com/ggml-org/llama.cpp && \
    cd /opt/llama.cpp && \
    cmake -B build -DGGML_CUDA=ON -DGGML_NATIVE=OFF -DCMAKE_CUDA_ARCHITECTURES="86" && \
    cmake --build build --config Release -j"$(nproc)"
