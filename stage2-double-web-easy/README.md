# Stage 2: double - web - easy

## Challenge

Get the /flag at http://108.61.211.185/

## Solution

The server under the given URL response with his source code (see server.py). As
the server runs under port 8080, but is accessible under the http standard port,
we can assume that some kind of reverve proxy is in place. This is important, as
this means the first check will check if the request comes from a local address.
The /isup endpoint is able to forward a website, but the url must contains
the words "http" and "kuchenblech".

So we can simply view the page of the CTF:

```
http://108.61.211.185/isup?name=http://kuchenblech.xyz
```

To get the file at /flag, we use the file protocol. To ensure, that the words
"http" and "kuchenblech" appears in the URL, we just make a double request:

```
http://108.61.211.185/isup?name=http://108.61.211.185/isup?kuchenblech=a%26name=file:///../../../../../flag
```

This URL returns the flag: junior-double_or_noth1ng
