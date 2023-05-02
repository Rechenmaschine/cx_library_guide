# Ubuntu: 18.04 has a CX-Compatible libc version
FROM ubuntu:18.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    build-essential

# Install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

COPY . /app
WORKDIR /app
