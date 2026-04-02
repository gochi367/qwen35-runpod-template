FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    cmake \
    ninja-build \
    build-essential \
    python3-pip \
    curl \
    tmux \
 && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://hf.co/cli/install.sh | bash
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /opt

# 24GBで4090系を主対象にするなら 89
# 3090/A40系も混ぜるなら "86;89"
ARG CUDA_ARCHS=89
ARG LLAMA_CPP_REF=master

RUN git clone --depth 1 --branch ${LLAMA_CPP_REF} https://github.com/ggml-org/llama.cpp /opt/llama.cpp && \
    cmake -S /opt/llama.cpp -B /opt/llama.cpp/build -G Ninja \
      -DGGML_CUDA=ON \
      -DGGML_NATIVE=OFF \
      -DCMAKE_CUDA_ARCHITECTURES="${CUDA_ARCHS}" && \
    cmake --build /opt/llama.cpp/build --verbose -j"$(nproc)"
