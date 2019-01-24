#base images
FROM centos
COPY ./files/jdk-8u131-linux-x64.tar.gz /mnt/
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && yum install -y wget \
    && cd mnt \
    && tar zxf jdk-8u131-linux-x64.tar.gz \
    && mv /mnt/jdk1.8.0_131 /usr/local/java1.8 \
    && wget https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 \
    && mv gosu-amd64 /usr/local/bin/gosu \
    && chmod 755 /usr/local/bin/gosu \
    && echo "elasticsearch soft memlock unlimited" >>/etc/security/limits.conf \
    && echo "elasticsearch hard memlock unlimited" >>/etc/security/limits.conf \
    && echo "elasticsearch soft nofile 65535" >>/etc/security/limits.conf \
    && echo "elasticsearch hard nofile 65535" >>/etc/security/limits.conf \
    && echo "elasticsearch hard nproc 65535" >>/etc/security/limits.conf \
    && echo "elasticsearch hard nproc 65535" >>/etc/security/limits.conf \
    && groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.tar.gz \
    && tar -zxf elasticsearch-6.5.4.tar.gz \
    && mv elasticsearch-6.5.4 /usr/local/elasticsearch \
    && chown -R elasticsearch:elasticsearch /usr/local/elasticsearch \
    && cp -r /usr/local/elasticsearch/config /home/elasticsearch \
    && rm -rf /mnt/* \
    && yum clean all
ADD ./files/setup.sh /tmp/
ADD ./files/elasticsearch.yml /home/elasticsearch/config/elasticsearch.yml
RUN chmod 755 /tmp/setup.sh 
ENV JAVA_HOME /usr/local/java1.8	
ENV JRE_HOME ${JAVA_HOME}/jre
ENV CLASSPATH .:${JAVA_HOME}/lib:${JRE_HOME}/lib:$CLASSPATH
ENV JAVA_PATH ${JAVA_HOME}/bin:${JRE_HOME}/bin
ENV PATH $PATH:${JAVA_PATH}
ENTRYPOINT ["/tmp/setup.sh"]
#ENTRYPOINT exec gosu elasticsearch /usr/local/elasticsearch/bin/elasticsearch
