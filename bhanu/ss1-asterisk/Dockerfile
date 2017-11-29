FROM phonetag.su:5000/ree-1.8.7-2011.03
MAINTAINER PTGOPS Team

# Install asterisks
COPY config-files/asterisk-1.6.1.6.tar.gz /var/asterisk-1.6.1.6.tar.gz
RUN tar -xvzf /var/asterisk-1.6.1.6.tar.gz -C /var  && \
    cd /var/asterisk-1.6.1.6 && sed -i 's/sqlite3_log/write_cdr/g' cdr/cdr_sqlite3_custom.c && \
     ./configure &&  make && make install &&  make config && \
    rm -rf /var/asterisk-1.6.1.6.tar.gz /var/asterisk-1.6.1.6

USER root
#ARG GIT_TAG
#ARG RAILS_ENV
#ARG RUBY_VERSION
ENV GIT_TAG sprint-27july.rc1
ENV RAILS_ENV eps_testing
ENV RUBY_VERSION ree-1.8.7-2011.03

# Setup codebase directory structure
RUN mkdir -p /srv/apps/ss1_configs /srv/data/ss1/pids /opt/ditc.conf.d/ss1.conf.d /var/log/simulscribe1 /media-files/primary /media-files/secondary/ss1 /media-files/secondary/ss2 && \
    chown ss:ss -R /srv/apps /srv/data /opt/ditc.conf.d/ss1.conf.d /var/log/simulscribe1 /media-files/primary /media-files/secondary && \
    chmod 755 -R /srv/apps /srv/data /opt/ditc.conf.d/ss1.conf.d /var/log/simulscribe1 && \
    chmod 775 -R /media-files/primary /media-files/secondary

# Install Codebase
USER ss
ENV top /srv/apps/simulscribe
RUN codir=$top/releases/`date +%Y%m%d%H%M%S` && \
    mkdir -p $codir && \
    cd $codir && \
    git clone git@github.com:DitechNetworks/ss1.git $codir && \
    cd $codir && git checkout $GIT_TAG && \
    echo $RUBY_VERSION > .ruby-version && \
    ln -s $codir $top/current && \
    cd $top/current && ln -s /var/log/simulscribe1 log && \
    mkdir -p $top/current/tmp/transcode $top/current/tmp/public/uploads


# Install gems
RUN /bin/bash -l -c 'gem install rubygems-bundler -v=1.3.3 --no-rdoc --no-ri' && \
    /bin/bash -l -c 'gem install rake -v=0.9.2.2 --no-rdoc --no-ri' && \
    /bin/bash -l -c 'cd /srv/apps/simulscribe/current && rake gems:build' && \
    /bin/bash -l -c 'gem install daemons -v=1.2.3 --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install digest-sha3 -v=1.0.2 --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install nokogiri -v=1.5.9 --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install aws-sdk -v=1.8.1.2 --no-ri --no-rdoc --ignore-dependencies' && \
    /bin/bash -l -c 'gem install tzinfo -v=0.3.35 --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install starling -v=0.10.1 --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install authorizenet -v=1.8.2 --no-ri --no-rdoc --ignore-dependencies' && \
    /bin/bash -l -c 'gem install mongrel -v=1.1.5 --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install passenger -v=4.0.13 --no-ri --no-rdoc --ignore-dependencies' && \
    /bin/bash -l -c 'gem install ffi-rzmq -v=1.0.3 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install ffi -v=1.9.10 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install uuidtools -v=2.1.5 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install json -v=1.8.2 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install bunny -v=1.7.1 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install amq-protocol -v=1.9.2 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install amqp -v=1.5.1 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install mysql -v=2.9.1 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install bundler-unload -v=1.0.2 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install cgi_multipart_eof_fix -v=2.5.0 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install eventmachine -v=1.0.8 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install executable-hooks -v=1.3.2 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install fastthread -v=1.0.7 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install gem-wrappers -v=1.2.7 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install gem_plugin -v=0.2.3 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install memcache-client -v=1.8.5 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install mini_portile -v=0.6.2 --ignore-dependencies --no-ri --no-rdoc' && \
    /bin/bash -l -c 'gem install sanitize -v=2.0.3 --ignore-dependencies --no-ri --no-rdoc'


USER root
# Setup codebase configurations
COPY config-files/ymls/*.yml /opt/ditc.conf.d/ss1.conf.d/
RUN cd /opt/ditc.conf.d/ss1.conf.d/  && \
    sed -i -e 's/#RAILS_ENV#/'"${RAILS_ENV}"'/g' *.yml  && \
    cd $top/current/config && \
    ln -s /opt/ditc.conf.d/ss1.conf.d/*.yml . && \
    chown ss:ss -R /opt/ditc.conf.d/ss1.conf.d/*.yml  && \
    ln -s /srv /u

# Copy asterisk configuration from code directory
RUN rm -rf /etc/asterisk  && \
    cp -rf $top/current/config/os/asterisk /etc/
COPY config-files/extensions.conf config-files/sip.conf /etc/asterisk/
RUN chmod 644 /etc/asterisk/sip.conf /etc/asterisk/extensions.conf


# Copy startup init script
COPY config-files/init-script/* /etc/init.d/
COPY config-files/service_start.sh /usr/local/bin/

RUN chown ss:ss /etc/init.d/starling /etc/init.d/workling /etc/init.d/ragi-* && \
    chmod 755 /etc/init.d/asterisk /etc/init.d/starling /etc/init.d/workling /etc/init.d/ragi-*  && \
    sed -i -e 's/#RAILS_ENV#/'"${RAILS_ENV}"'/g' /etc/init.d/asterisk /etc/init.d/starling /etc/init.d/workling /etc/init.d/ragi-*

# Start service
CMD bash -C '/usr/local/bin/service_start.sh';'bash'
