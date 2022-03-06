### Link routing code to install folder

/etc/kamailio/kamailio.cfg -> /opt/webrtc-gateway/kamailio.cfg

### Local Configuration

Copy /opt/webrtc-gateway/kamailio-local.cfg to /etc/kamailio/kamailio-local.cfg and edit for the local instance: change IP addresses, TCP settings, etc.

rtpengine waiting on udp:127.0.0.1:2223