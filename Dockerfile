# Use an official Redis runtime as a parent image

################ Redis
FROM redis:3-stretch

WORKDIR /root

LABEL purpose="app"
LABEL module="ospd-openvas"
LABEL branch="master"
LABEL platform="debian"

ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
ENV PYTHONPATH=/root/openvas/install/lib/python3.5/site-packages:$PYTHONPATH

# Install all the packages needed for openvassd, ospd and ospd-openvas.
RUN sed -ie 's/main/main contrib non-free/g' /etc/apt/sources.list && \
apt-get update && \
apt-get install gcc-mingw-w64 \
gcc \
cmake \
pkg-config \
git \
curl \
build-essential \
libgpgme11-dev \
libgnutls28-dev \
uuid-dev \
libssh-gcrypt-dev \
libhiredis-dev \
gcc-mingw-w64 \
libgnutls28-dev \
perl-base \
heimdal-dev \
libpopt-dev \
libglib2.0-dev \
libpcap-dev \
libgpgme-dev \
bison \
flex \
libksba-dev \
libsnmp-dev \
libgcrypt20-dev \
python3 \
python3-pip \
python3-setuptools \
python3-dev \
libffi-dev \
python3-openssl \
ca-certificates \
-yq --no-install-recommends && \
rm -rf /var/lib/apt/lists/*

# Fetch and install openvas-smb
RUN git clone https://github.com/greenbone/openvas-smb.git && \
    cd openvas-smb && \
    mkdir build && cd build && cmake .. && \
    make && make install
# Fetch and install gvm-libs
RUN git clone https://github.com/greenbone/gvm-libs.git && \
    cd gvm-libs && \
    mkdir build && cd build && cmake ..&& \
    make && make install
# Fetch and install openvas-scanner
RUN git clone https://github.com/greenbone/openvas-scanner.git && \
    cd openvas-scanner && \
    mkdir build && cd build && cmake ..&& \
    make && make install
# Fetch and install ospd
RUN pip3 install lxml && \
    git clone --depth=1 https://github.com/greenbone/ospd.git && \
    cd ospd && \
    python3 setup.py install && \
    cd ..
# Fetch and install ospd-openvas
RUN git clone --depth=1 https://github.com/greenbone/ospd-openvas.git && \
    cd ospd-openvas && \
    python3 setup.py install && \
    cd ..

# Prepare some directories for redis and run ldconfig
RUN mkdir -p /etc/redis/ && \
    mkdir -p /tmp/ && \
    mkdir -p /var/log/redis/ && \
    mkdir -p /var/lib/redis/ && \
    ldconfig

# Copy important config into the container.
COPY config/redis.conf /etc/redis/redis.conf
COPY run-all /run-all

EXPOSE 1234/tcp
CMD /run-all

