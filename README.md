# Provides a runtime environment for the master branch of the ospd-openvas scanner based on Redis 3 and the master branch of ospd and openvas-scanner.

## Running and testing

This container must be run with the next command:

```
docker run --mount type=bind,source=/tmp/certs,target=/root --mount type=bind,source=/tmp/docker-openvas-conf,target=/usr/local/etc/openvas --mount type=bind,source=/tmp/docker-log,target=/usr/local/var/log/gvm -p 1234:1234 -i -t docker-openvas
```

There are three volumens mounted corresponding to:
 - The directory with the certificates.
 - The directory with the OpenVAS configuration.
 - The directory for the logs.

Through this files it is possible to change the OpenVAS configuration in the container from the host, without the need to re-build the images with new configuration or connecting to the bash. It also allows the access to the openvassd.log file.


Before running, the certificates must be created for example with:
```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -subj '/CN=localhost' -days 365
```

For the given example, the certificates must be created in /tmp/certs.
To try the app, the certs can be copied into another machine and run:
```
echo "<get_version/>" | gnutls-cli --port=1234 --insecure --x509certfile=/tmp/certs/cert.pem --x509keyfile=/tmp/certs/key.pem <container-ip-address>
```

## Another way to run ospd-openvas container is making use of a unix socket.
```
docker run --mount type=bind,source=/tmp/openvas-run,target=/root --mount type=bind,source=/tmp/docker-openvas-conf,target=/usr/local/etc/openvas --mount type=bind,source=/tmp/docker-log,target=/usr/local/var/log/gvm -p 1234:1234 -i -t docker-openvas
```
To test it with gvm-tools run the following commands agains a metasploitable:
```
gvm-cli socket --sockpath /tmp/openvas-run/openvas.sock --xml "<start_scan parallel='10'><scanner_params/><vts><vt id='1.3.6.1.4.1.25623.1.0.802082'></vt><vt id='1.3.6.1.4.1.25623.1.0.900920'></vt><vt id='1.3.6.1.4.1.25623.1.0.90022'></vt></vts><targets><target><hosts>192.168.0.1</hosts><ports>1-1024</ports><credentials><credential type='up' service='ssh' port='22'><username>msfadmin</username><password>msfadmin</password></credential></credentials></target></targets></start_scan>"
```
