FROM ubuntu:24.04

RUN apt update && apt install -y \
    build-essential \
    cmake \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN cmake -B build \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLAMA_CURL=ON

RUN cmake --build build --config Release -j$(nproc)

EXPOSE 8080

CMD ["./build/bin/llama-server", \
     "-m", "/app/models/Llama-3.2-1B-Instruct-Q4_K_M.gguf", \
     "-c", "512", \
     "-t", "4", \
     "--host", "0.0.0.0", \
     "--port", "8080"]
