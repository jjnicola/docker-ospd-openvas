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