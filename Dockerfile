FROM debian:stable-slim
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=teletype
RUN mkdir /iso && mkdir /var/lib/tftpboot && \
		apt-get update && apt-get -y install \
																 kmod \
																 inetutils-inetd \
																 tftpd-hpa && \
		rm -rf /var/lib/apt/lists/*
RUN echo "tftp    dgram   udp4    wait    root    /usr/sbin/in.tftpd /usr/sbin/in.tftpd -s /var/lib/tftpboot" >> /etc/inetd.conf && \
		echo 'RUN_DAEMON="yes"' >> /etc/default/tftpd-hpa && \
		echo 'OPTIONS="-l -s /var/lib/tftpboot"' >> /etc/default/tftpd-hpa && \
		echo 'while [[ $(/etc/init.d/tftpd-hpa status | grep "is running") ]]; do sleep 10 ; done' > /loop.sh && chmod +x /loop.sh

COPY netboot /var/lib/tftpboot

CMD /etc/init.d/tftpd-hpa start && /bin/bash -c /loop.sh