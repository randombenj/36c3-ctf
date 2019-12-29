# Stage 1: maybe - rev - medium

## Challange

Das Blech umdrehen!

## Solution

First we can inspect wether there are some interesting strings in the binary:

```sh
$ strings chal1-a27148a64d65f6d6fd062a09468c4003

...
aber es ist nur noch eine sache von sekunden!
correct!
this_should_totally_be_a_hering_on_a_kuchenblech
wrong!
;*3$"
junior-totally_the_flag_or_maybe_not
...
```

And in deed we see some interesting stuff, but obviously this is not the flag.
But what happens in the binary?

We can have a look at the binary using [cutter](https://github.com/radareorg/cutter).
There we see that the main function does not do much ... obviously there is some other magic going on here.

Afterwards it turned out that the magic was done with the [__attribute__((constructor))](https://stackoverflow.com/questions/2053029/how-exactly-does-attribute-constructor-work).

Anyway so when we reverse engineer the binary we get a firt stage doing
something like this:

```c
int index;
char flag[] = "junior-totally_the_flag_or_maybe_not";

// some obvuscation (so the 'junior-' won't be changed otherwise
index = 0;
while (index < 0x24)
{
    flag[index] = flag[0x23 - index];
    index = index + 1;
}
```

This will give us a slightly altered flag: **ton_ebyam_ro_galf__flag_or_maybe_not**

The second stage will be reverse engineerd to something like this (can be done with cutter):

```c
bool is_flag_correct;
int32_t index;
int32_t var_8h;
int32_t check_index;
char flag[] = "junior-totally_the_flag_or_maybe_not";
char real_flag[] = "...";

index = 0;
while (index < 0x24) {
    flag[index] = flag[index] ^ real_flag[index];
    index = index + 1;
}
is_flag_correct = true;
check_index = 0;
while (check_index < 0x24) {
    if (flag[check_index] != *(char *)((int64_t)(check_index * 2 + 1) + 0x5639462960a0)) {
        is_flag_correct = false;
    }
    check_index = check_index + 1;
}
sym.imp.sleep(10);
sym.imp.puts("aber es ist nur noch eine sache von sekunden!");
if (is_flag_correct) {
    sym.imp.puts("correct!");
}
```

One statement is quite odd `flag[check_index] != *(char *)((int64_t)(check_index * 2 + 1) + 0x5639462960a0)`
lets analyze this a bit further by looking at the assembly code.
Basically you can see a comparison with some string at a *magic* reference:

```asm
│      ╎│   0x00000775      488d05240920.  lea rax, [0x002010a0]
│      ╎│   0x0000077c      0fb60402       movzx eax, byte [rdx + rax]
│      ╎│   0x00000780      38c1           cmp cl, al
│     ┌───< 0x00000782      7407           je 0x78b
│     │╎│   0x00000784      c745f8000000.  mov dword [var_8h], 0
│     │╎│   ; CODE XREF from entry.fini1 @ 0x782
│     └───> 0x0000078b      8345fc01       add dword [var_4h], 1
```

Note the **0x002010a0** address in the first assembly line 0x00000775.
This compares with `cmp cl, al` wether the contents match with the input.

So how do we get this string? We simply debug the programm and write every value in `eax` down,
and reverse the xor in python which should give us the original flag:

```python
masq = '\x1e\x1a\x00\x36\x0a\x10\x54\x00\x01\x33\x17\x1c\x00\x09\x14\x1e\x39\x34\x2a\x05\x04\x04\x09\x3d\x03\x17\x3c\x05\x3e\x14\x03\x03\x36\x0f\x4e\x55'
flag = 'ton_ebyam_ro_galf__flag_or_maybe_not'

def sxor(s1,s2):
     # convert strings to a list of character pair tuples
     # go through each tuple, converting them to ASCII code (ord)
     # perform exclusive or on the ASCII code
     # then convert the result back to ASCII (chr)
     # merge the resulting array of characters as a string
     return ''.join(chr(ord(a) ^ ord(b)) for a,b in zip(s1,s2))

sxor(masq, flag)
```

And this will give us the flag!

**junior-alles_nur_kuchenblech_mafia!!**

You can find the [original source here](original_source.c).
