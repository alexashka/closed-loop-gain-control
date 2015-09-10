// http://serverfault.com/questions/279068/cant-find-so-in-the-same-directory-as-the-executable
//
// make LDFLAGS="-Wl,-R -Wl,."  - current dir
#include "libtest.h"
int main(int argc, char **argv) {
  hello_world();
}
