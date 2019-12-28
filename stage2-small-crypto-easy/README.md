# Stage 2: small - crypto - easy

## Challenge

```
message = int('REDACTED', base=35)
N = 31882864753733457706900355195561745936205728163688545344755624355885302677527509480805991969514641856022311950710014654686332759895303124949904557581766107448945073828773339824936328117599459705430379854436444155104737774883908742430619368768337640156577480749932446289330171110268995901030116001751822218657
c = message^3 % N
# c = 272712645051843502864020676686837219546440933810920336253597504130258033336636323130656292878088405243095416128

The message is the flag. No flag format.
```

## Solution

This challenge was similar to one of last year's junior CTF.

See: https://github.com/randombenj/35c3-ctf/tree/master/crypto/decrypted

In Chrome's console run:
```JavaScript
function cubicRoot(a)
{
  let d = Math.floor((a.toString(2).length-1)/3); // binary digits nuber / 3
  let r = 2n ** BigInt(d+1); // right boundary approximation
  let l = 2n ** BigInt(d);   // left boundary approximation
  let x=BigInt(l);
  let o=BigInt(0);           // old historical value

  while(1) {
    o = x;
    y = x * x * x;
    y<a ? l=x : r=x;
    if(y==a) return x;
    x = l + (r - l)/2n;
    if(o==x) return false;
  }
}

flag = BigInt('272712645051843502864020676686837219546440933810920336253597504130258033336636323130656292878088405243095416128')
cubicRoot( flag ).toString()
```

this returns: `"6484877229948717415163579969767084212"`

As seen in line 1 of the challenge, the message is in base 35.

We can use CyberChef to convert the output to base 35: https://gchq.github.io/CyberChef/#recipe=To_Base(35)&input=NjQ4NDg3NzIyOTk0ODcxNzQxNTE2MzU3OTk2OTc2NzA4NDIxMg

This gives: `juniorissmallkuchenblech` which is the flag!


