docker rm -f  elk_es kibana logspout logstash

docker run -d \
  -p 9200:9200 \
  -p 9300:9300 \
  --name elk_es \
  -e LOGSPOUT=ignore \
  elasticsearch:1.5.2

docker run -d \
  -p 5000:5000 \
  -p 5000:5000/udp \
  -v "$PWD":/config \
  --link elk_es:elasticsearch \
  --name logstash \
  -e LOGSPOUT=ignore \
  logstash  -f /config/logstash.conf


docker run -d \
  -p 5601:5601 \
  --link elk_es:elasticsearch \
  --name kibana \
  -e LOGSPOUT=ignore \
  kibana:4.1.2

docker run -d \
  -p 8000:8000 \
  -v /var/run/docker.sock:/tmp/docker.sock \
  --name logspout \
  -e DEBUG=true \
  gliderlabs/logspout:master syslog://192.168.99.100:5000

docker run -d ubuntu bash -c 'for i in {0..60}; do echo $i; sleep 1; done'

