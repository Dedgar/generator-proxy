# /usr/local/bin/start.sh will start the service

# FROM registry.access.redhat.com/ubi8/ubi-minimal:latest
FROM quay.io/fedora/fedora:35-x86_64

ADD scripts/ /usr/local/bin/

RUN dnf install -y wget perl git make cmake gcc gcc-c++ libstdc++-static automake libtool autoconf libuv-static openssl-devel libuuid-devel && \
    dnf clean all && \
    cd /tmp && \
    git clone https://github.com/xmrig/xmrig-proxy && \
    cd /tmp/xmrig-proxy

RUN sed -i -e 's/{ "donate-level",      1, nullptr, IConfig::DonateLevelKey    },/{ "donate-level",      0, nullptr, IConfig::DonateLevelKey    },/' /tmp/xmrig-proxy/src/core/config/Config_platform.h

RUN mkdir /tmp/xmrig-proxy/build && \
    cd /tmp/xmrig-proxy/scripts && \
    /tmp/xmrig-proxy/scripts/build_deps.sh && \
    cd /tmp/xmrig-proxy/build && \
    cmake .. -DXMRIG_DEPS=scripts/deps && \
    make -j$(nproc) && \
    mv xmrig-proxy /usr/local/bin/generator && \ 
    # rm -rf /tmp/xmrig-proxy && \
    cd

EXPOSE 8080

# Start processes
CMD /usr/local/bin/start.sh
