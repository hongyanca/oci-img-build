# syntax=docker/dockerfile:1
FROM lscr.io/linuxserver/code-server:latest
# https://hub.docker.com/r/linuxserver/code-server/tags
# https://go.dev/dl/
COPY go-installer.sh /tmp/go-installer.sh

ENV NODE_MAJOR=20

RUN apt-get update \
  && sudo apt-get install -y ca-certificates curl gnupg \
  && sudo mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list \
  && apt-get update && NEEDRESTART_MODE=a apt-get install -y make build-essential libssl-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget nodejs llvm libncurses5-dev \
  libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl \
  bind9-dnsutils bind9-host bind9-libs binutils binutils-common \
  binutils-x86-64-linux-gnu bzip2 cpp cpp-11 dpkg-dev g++ g++-11 gcc-11 \
  gcc-11-base libasan6 libbinutils libc-dev-bin libc6-dev libcap2-bin libcc1-0 \
  libcrypt-dev libctf-nobfd0 libctf0 libdpkg-perl libexpat1-dev libgcc-11-dev \
  libgomp1 libicu70 libisl23 libitm1 libjs-jquery libjs-sphinxdoc \
  libjs-underscore libjson-c5 liblmdb0 liblsan0 libmaxminddb0 libmpc3 \
  libmpdec3 libmpfr6 libnsl-dev libpython3-dev libpython3-stdlib libpython3.10 \
  libpython3.10-dev libpython3.10-minimal libpython3.10-stdlib libquadmath0 \
  libstdc++-11-dev libtirpc-dev libtsan0 libubsan1 libuv1 libxml2 \
  linux-libc-dev lto-disabled-list make media-types python3 python3-distutils \
  python3-lib2to3 python3-minimal python3-pip-whl python3-pkg-resources \
  python3-setuptools python3-setuptools-whl python3-wheel python3.10 \
  python3.10-dev python3.10-minimal python3.10-venv rpcsvc-proto xz-utils \
  zlib1g-dev zsh-common dnsutils iputils-ping htop jq \
  && apt-get update && NEEDRESTART_MODE=a apt-get upgrade -y \
  && apt-get autoremove -y && apt-get clean \
  && curl https://pyenv.run | bash \
  && /bin/bash /tmp/go-installer.sh \
  # Install Rust inside Docker
  # https://users.rust-lang.org/t/compile-rust-app-for-a-docker-image/76369
  && curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y \
  # Install NeoVim
  && curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
  && sudo rm -rf /opt/nvim && sudo tar -C /opt -xzf nvim-linux64.tar.gz \
  && sudo rm -rf /usr/bin/nvim && sudo ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim \
  && rm nvim-linux64.tar.gz \
  # Add user abc to sudoers
  && echo "abc ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

