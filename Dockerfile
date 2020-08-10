FROM ubuntu:20.04 AS base

RUN apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    gpg \
    dirmngr

RUN apt install -y gpg-agent

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]



FROM base


ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "installing required dependencies..."


RUN apt update && apt install -y vim wget make cron gettext autotools-dev intltool python-crypto 

RUN wget -c 	http://archive.ubuntu.com/ubuntu/pool/main/p/paramiko/python-paramiko_2.0.0-1ubuntu1_all.deb && \
    apt install -y ./python-paramiko_2.0.0-1ubuntu1_all.deb

RUN wget -c http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-gtk2_2.24.0-6_amd64.deb && \
    apt install -y ./python-gtk2_2.24.0-6_amd64.deb

RUN wget -c http://archive.ubuntu.com/ubuntu/pool/universe/p/pygtk/python-glade2_2.24.0-6_amd64.deb && \
    apt install -y ./python-glade2_2.24.0-6_amd64.deb

RUN wget -c http://archive.ubuntu.com/ubuntu/pool/universe/n/notify-python/python-notify_0.1.1-4_amd64.deb && \
    apt install -y ./python-notify_0.1.1-4_amd64.deb

RUN echo "installing fwbackups 1.43.7..."
RUN wget -c http://downloads.diffingo.com/fwbackups/fwbackups-1.43.7.tar.bz2 && \
tar xfj ./fwbackups-1.43.7.tar.bz2 && cd fwbackups-1.43.7 && ./configure --prefix=/usr && \ 
make && make install

RUN rm -rf /var/lib/apt/lists/*

COPY backupSet1.conf /home/user/.fwbackups/Sets/backupSet1.conf 

# change permission as directory + files have been created as root user but are used by user called "user" from base image
RUN chmod 777 -R /home/user/.fwbackups/

CMD fwbackups-run backupSet1


# docker build --tag sh39sxn/fwbackups:latest .

# overwrite entrypoint for debugging
# docker run -it -e LOCAL_USER_ID=`id -u $USER` --entrypoint="bash" -v /$(pwd)/backups:/backups -v /:/filesystem sh39sxn/fwbackups:latest

#backup "/"
# docker run -it -e LOCAL_USER_ID=`id -u $USER` -v /$(pwd)/backups:/backups -v /:/filesystem sh39sxn/fwbackups:latest

# crontab entry
# 21 17 * * * cd ~/workspace/fwbackups-docker && docker run -i -e LOCAL_USER_ID=`id -u $USER` -v /$(pwd)/backups:/backups -v /:/filesystem sh39sxn/fwbackups:latest > /var/log/cron.log 2>&1