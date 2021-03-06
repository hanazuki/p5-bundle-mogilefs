FROM centos:6
MAINTAINER pepabo.com

RUN yum install -y tar patch gcc perl-core mysql-devel

ADD . /opt/mogilefs
WORKDIR /opt/mogilefs

# Fixme:: Remove test case not running correctly on Docker Hub
RUN cd cpan-mirror/authors/id/D/DO/DORMANDO && \
    gunzip -c MogileFS-Server-2.72.tar.gz | \
      tar --delete MogileFS-Server-2.72/t/mogstored-shutdown.t | \
      gzip -c - > MogileFS-Server-2.72.tar.gz.new && \
    mv MogileFS-Server-2.72.tar.gz.new MogileFS-Server-2.72.tar.gz


RUN if ! ./install.sh; then cat /root/.cpanm/build.log; exit 1; fi

EXPOSE 7001
ENTRYPOINT ["bash", "/opt/mogilefs/docker/entrypoint.sh"]
CMD ["mogilefsd"]
