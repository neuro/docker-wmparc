FROM debian:jessie
MAINTAINER Patrick Schiffler <schiffler@uni-muenster.de>

VOLUME /input
VOLUME /output

ENV DEBIAN_FRONTEND noninteractive
RUN sed -i 's|deb http://deb.debian.org/debian jessie main|deb http://deb.debian.org/debian jessie main non-free|g' /etc/apt/sources.list
RUN apt-get -yqq update && apt-get --no-install-recommends -yqq install wget build-essential file sudo curl ca-certificates fsl git && rm -rf /var/lib/apt/lists/*
RUN curl -f -L https://static.rust-lang.org/rustup.sh -O && sh rustup.sh
ADD http://trackvis.org/bin/Diffusion_Toolkit_v0.6.4.1_x86_64.tar.gz /
COPY gradient_matrix.txt /opt/gradient_matrix.txt

RUN git clone https://github.com/neuro/wmparc.git /opt/wmparc
RUN cd /opt/wmparc && cargo build --release

COPY run.sh /opt/run.sh
ENTRYPOINT ["/opt/run.sh"]
