#include <unistd.h>
#include <fcntl.h>

int main(int argc, char *argv[])
{
 int fd;
 char s[]="Chastity White Rose\n";

 /*
  open file and create it if needed.
  Assign all file permissions of Read and Write for the user and Read Only for others.
 */
 fd=open("filename.txt", O_WRONLY | O_CREAT,0644);
 if(fd>0)
 {
  write(fd,s,sizeof(s)-1); /* write "Hello World" to stdout */
  close(fd);
 }
 _exit(0);                      /* exit with error code 0 (no error) */
}
