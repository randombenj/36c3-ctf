# Stage 2: tracer - for - easy

## Challenge

Tracing the Kuchenblech-Mafia is hard!

Attachment (file chal2-98f6917950f95448890949f2d9b9850a)

## Solution

The file contains an strace output of a user that installs vim and type the
flag in and saves it. To make it a bit more readable, all output before
the input of a "j" and be ignored, as we know the flag starts with a "j".
Also only the "read" commands must be considered, all others can be ignored.
The file "onlyRead" only contains the important keystrokes. To reproduce the
flag, just type in all the keys in VIM again. The following special characters
must be considered:

```
\r => ENTER
\33 => ESCAPE
\177 => BACKSPACE
```

After typing that, the flag is visible in the own vim editor: junior-nanoiswayBETTER!
