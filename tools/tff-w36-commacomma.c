// GTKWave "translate filter file" (c.f. GTKWave 3.3 Wave Analyzer
// User's Guide p.55). This translates a 36-bit word into standard
// octal LH,,RH form.
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv) {

  for (;;) {
    char buf[1025], buf2[1025];

    buf[0] = 0;
    if (scanf("%s", buf) <= 0) return 0;

    unsigned long long w;
    sscanf(buf, "%llx", &w);

    printf("%06llo,,%06llo\n", w >> 18, w & 0777777ull);
    fflush(stdout);
  }

  return 0;
}
