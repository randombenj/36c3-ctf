#include <stdio.h>

int main()
{
    int index;
    char flag[] = "junior-totally_the_flag_or_maybe_not";

    // some obvuscation (so the 'junior-' won't be changed otherwise
    index = 0;
    while (index < 0x24)
    {
        flag[index] = flag[0x23 - index];
        index = index + 1;
    }

    printf(flag);

    // check of the input


}
