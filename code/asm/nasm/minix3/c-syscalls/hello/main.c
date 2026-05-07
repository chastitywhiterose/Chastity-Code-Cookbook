#include <unistd.h>
#include <stdlib.h>

int main(void) {
    write(1, "Hello, World!\n", 14);
    exit(0);
    return 0;
}
