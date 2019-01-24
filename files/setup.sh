#!/bin/bash
data_path=/data/es6.5
default_path=/home/elasticsearch
es_path=/usr/local/elasticsearch
if [ ! -d ${data_path} ];then 
	mkdir -p ${data_path}
	rm -rf ${es_path}/config/elasticsearch.yml
	cp -r ${default_path}/config ${data_path}/
	cp -a ${default_path}/config/elasticsearch.yml ${es_path}/config/elasticsearch.yml
	chown -R elasticsearch:elasticsearch ${data_path}
	chown -R elasticsearch:elasticsearch ${es_path}
	echo "123"
	exec gosu elasticsearch  /usr/local/elasticsearch/bin/elasticsearch
elif [ ! -f ${data_path}/config/elasticsearch.yml ]; then
	rm -rf ${es_path}/config/elasticsearch.yml
	cp -a ${default_path}/config/elasticsearch.yml ${data_path}/config/elasticsearch.yml
	cp -a ${default_path}/config/elasticsearch.yml ${es_path}/config/elasticsearch.yml
	chown -R elasticsearch:elasticsearch ${data_path}
	chown -R elasticsearch:elasticsearch ${es_path}
	echo "456"
	exec gosu elasticsearch  /usr/local/elasticsearch/bin/elasticsearch
else
	rm -rf ${es_path}/config
	cp -ar ${data_path}/config ${es_path}/
	chown -R elasticsearch:elasticsearch ${data_path}
	chown -R elasticsearch:elasticsearch ${es_path}
	echo "678"
        exec  gosu elasticsearch /usr/local/elasticsearch/bin/elasticsearch
fi
