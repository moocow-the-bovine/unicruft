#include <unicruft.h>
#include <stdio.h>

//-- globals
uxBuffer *buf1 = NULL;
uxBuffer *buf2 = NULL;
uxBuffer *buf1b= NULL;
uxDEpp   *pp   = NULL;
#define INITIAL_BUFFER_SIZE 128
const int USE_DEPP = 1; //-- use latin1/de preprocessor & target subset?

int main (void) {
  //-- setup buffers
  buf1 = ux_buffer_new(NULL,0,INITIAL_BUFFER_SIZE);
  buf2 = ux_buffer_new(NULL,0,INITIAL_BUFFER_SIZE);
  if (USE_DEPP) {
    buf1b = ux_buffer_new(NULL,0,INITIAL_BUFFER_SIZE);
    pp    = ux_depp_new();
  }

  //-- main loop
  while ( ux_buffer_getline(buf1,stdin) >= 0 ) {
    if (USE_DEPP) {
      //-- with latin1/de preprocessing
      buf1b->len = 0;
      ux_depp_scan_buffer(pp,buf1,buf1b);
      buf2->len  = 0;
      ux_unidecode_us(&UNIDECODE_LATIN1, buf1b, buf2);
    } else {
      //-- without latin1/de preprocessing
      buf2->len  = 0;
      ux_unidecode_us(&UNIDECODE_LATIN1, buf1, buf2);
    }
    ux_buffer_fwrite(buf2,stdout);
  }

  //-- cleanup
  ux_buffer_free(buf1,1);
  ux_buffer_free(buf2,1);
  if (USE_DEPP) {
    ux_buffer_free(buf1b,1);
    ux_depp_free(pp);
  }

  return 0;
}
