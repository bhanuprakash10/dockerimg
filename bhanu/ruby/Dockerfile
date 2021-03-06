# This is a comment
FROM docker.io/centos:6.8
MAINTAINER PTGOPS Team

COPY config-files/ffmpeg.repo /etc/yum.repos.d/
RUN yum update -y && \
    yum install "sudo" "vim" "wget" "ed" "sed" "curl" "git" "telnet" "openssl" "make" "patch" "bzip2" "autoconf" "automake" "bison" "ncurses-devel" "db4-devel" "libxml2" "libxml2-devel" "zlib" "libcurl-devel" "mysql-devel" "mysql-libs" "cronie" "libxslt-devel" "uuid-devel" "libuuid-devel" "ffmpeg-0.6.5" "ffmpeg-devel-0.6.5" "libmad" "libid3tag" "pulseaudio.x86_64" "pulseaudio-libs-devel.x86_64" "sox.x86_64" "sox-devel.x86_64" "openssh-server" -y

#RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV RPASS `openssl rand -base64 40`

#Add SS User with SUDO Privilege..
RUN groupadd -g 5000 ss && \
    useradd -d /home/ss -g ss -m -s /bin/bash -u 5000 ss  && \
    usermod -p "$RPASS" ss && \
    echo 'ss ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER ss
#ARG RUBY_VERSION
ENV RUBY_VERSION ree-1.8.7-2011.03
RUN /bin/bash -l -c "gpg --keyserver hkp://keys.gnupg.net:80 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \curl -sSL https://get.rvm.io | bash -s stable"

COPY config-files/ruby-* /home/ss/.rvm/archives/
COPY config-files/rubygems-* /home/ss/.rvm/archives/
RUN /bin/bash -l -c 'source ~/.rvm/scripts/rvm' && \
    /bin/bash -l -c 'rvm reload'  && \
    /bin/bash -l -c 'rvm requirements' && \
    /bin/bash -l -c 'echo "export rvm_max_time_flag=20" >> ~/.rvmrc' && \
    /bin/bash -l -c 'rvm install $RUBY_VERSION' && \
    /bin/bash -l -c 'rvm use $RUBY_VERSION --default' && \
    /bin/bash -l -c 'rvm install rubygems 1.3.7 --force' 

USER root  
# Add github authentication
ADD config-files/github-identity /home/ss/.ssh/github-identity
ADD config-files/ssh-config /home/ss/.ssh/config
RUN chmod 600 /home/ss/.ssh/config /home/ss/.ssh/github-identity && \
    chown ss:ss /home/ss/.ssh/config /home/ss/.ssh/github-identity

# ZeroMQ Installation
RUN mkdir -p /opt/archives && cd /opt/archives && wget http://download.zeromq.org/zeromq-2.2.0.tar.gz && tar xvzf zeromq-2.2.0.tar.gz && cd zeromq-2.2.0/ && ./autogen.sh && ./configure && make && make install && echo "/usr/local/lib" > /etc/ld.so.conf.d/zmq.conf && ldconfig

# Install sox
COPY config-files/sox-*.rpm /opt/archives/
RUN cd /opt/archives/ && rpm -Uvh sox-14.3.2-1.el6.rfx.x86_64.rpm --nodeps && rpm -Uvh sox-devel-14.3.2-1.el6.rfx.x86_64.rpm --nodeps

# Disable ssh authentication module
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    echo 'root:p4ssw0rd!' | chpasswd

# Cleanup
RUN if [ -d /opt/archives ]; then rm -rf /opt/archives ; fi && \
    rm -f /home/ss/.rvm/archives/ruby-*.bz2 && \
    rm -f /home/ss/.rvm/archives/ruby-*.gz  && \
    rm -f /home/ss/.rvm/archives/*.tgz
