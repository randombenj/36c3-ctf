# Stage 3: querying - web - medium

## Challenge

In German, Graf means count. Anyway I'm certain he likes pie. Who doesn't? He also won't give you the Flag as he keeps track of every request. Nothing to see here, please move along. http://199.247.4.207:4000/

## Solution

The graphql server presents a mutation query to give a flag and the return integer
shows, how many letters match the flag. The bad part: This request is rate limited
per IP, so brute force is not really an option here, except there is a problem in
the bruteforce prevention.

As we try out different thinks to trick the bruteforce prevention, we were very
desperate and just brute force the flag with the help of our good friend Tor. After
every request, we than ask Tor to give us a new IP. This is a very hacky solution,
but it worked for us and after about 15 minutes, we get the flag!

Flag: junior-Batching_Qu3r1e5_is_FUN1

After reading the flag, we realize, the solution would be a lot easier if we just
pass multiple mutation queries in one http request to the graphql server like this:

```
mutation {
  var1: checkFlag(flag: "junior-Batching_Qu3r1e5_i"),
  var2: checkFlag(flag: "junior-Batching_Qu3r1e5_is_FUN1")
}
```

With this knowledge, a script that checks every possible next letter at once would be
a lot faster and maybe the intended solution :)
