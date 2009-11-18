#include <unicruft.h>
#include <stdio.h>

//-- globals
uxBuffer *buf1 = NULL;
uxBuffer *buf2 = NULL;
#define INITIAL_BUFFER_SIZE 128

int main (void) {
  //-- setup buffers
  buf1 = ux_buffer_new(NULL,0,INITIAL_BUFFER_SIZE);
  buf2 = ux_buffer_new(NULL,0,INITIAL_BUFFER_SIZE);

  //-- main loop
  while ( ux_buffer_getline(buf1,stdin) >= 0 ) {
    buf2->len  = 0;
    ux_buffer_latin1_to_utf8(buf1,buf2);
    ux_buffer_fwrite(buf2,stdout);
  }

  //-- cleanup
  ux_buffer_free(buf1,1);
  ux_buffer_free(buf2,1);

  return 0;
}
