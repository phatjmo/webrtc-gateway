### Link routing code to install folder

/etc/kamailio/kamailio.cfg -> /opt/webrtc-gateway/kamailio.cfg

### Local Configuration

Copy /opt/webrtc-gateway/kamailio-local.cfg to /etc/kamailio/kamailio-local.cfg and edit for the local instance: change IP addresses, TCP settings, etc.

rtpengine waiting on udp:127.0.0.1:2223

### Set X Headers for User/Password in Asterisk extensions.conf

```
exten => _199XXXXXXX,1,Set(CASUser=${SIP_HEADER(X-CAS-User)})
same => n,Set(CASPass=${SIP_HEADER(X-CAS-Password)})
```

### TLS Configuration

In order for WSS to work, you must ensure the following is modified in /etc/kamailio/tls.cfg according to the location of the certificate and key files:

```
[server:default]
method = TLSv1.2+
verify_certificate = no
require_certificate = no
private_key = /etc/certificate/cas-ssl-key.pem
certificate = /etc/certificate/cas-ssl-fullchain.crt
```

The cert must contain subject names for any URLs that will connect to the WebRTC gateway, whether regional or global DNS. A wildcard certificate is recommended. Note that direct IP address connection for WSS will fail the certificate check.

### RTPEngine Configuration

Configuration for RTPEngine is in `/etc/rtpengine/rtpengine.conf`.

For each instance of the WebRTC gateway, update the following line in `/etc/rtpengine/rtpengine.conf`:

```
interface = 10.40.1.53!34.82.81.5
```

The first IP address is the local IP and the second is the advertised IP. This is ideal for a cloud VM with single interface and a NAT IP address. If using an instance with a separate LAN and WAN interface, follow the recommendations in the comments above this line.

Use the sample configuration in this repository for any additional RTPEngine settings.