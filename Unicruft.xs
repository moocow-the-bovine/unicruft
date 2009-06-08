/*-*- Mode: C -*- */
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/*#include "ppport.h"*/

#include <unicruft.h>

MODULE = Unicruft    PACKAGE = Unicruft

##=====================================================================
## Conversions
##=====================================================================

void foo()
CODE:
  fprintf(stderr,"foo!\n");

SV *
testme(SV *in)
PREINIT:
 uxBuffer ibuf;
 uxBuffer *obuf=NULL;
CODE:
  ibuf.str   = SvPV(in, ibuf.len);
  ibuf.alloc = ibuf.len;
  obuf       = ux_buffer_new(NULL, 0, ibuf.len);
  ux_buffer_latin1_to_utf8(&ibuf, obuf);
  RETVAL     = newSVpvn(obuf->str, obuf->len);
OUTPUT:
  RETVAL
CLEANUP:
 ux_buffer_free(obuf,1);

SV *
latin1_to_uft8(SV *in)
PREINIT:
 uxBuffer ibuf;
 uxBuffer *obuf=NULL;
CODE:
  ibuf.str   = SvPV(in, ibuf.len);
  ibuf.alloc = ibuf.len;
  obuf       = ux_buffer_new(NULL, 0, ibuf.len);
  ux_buffer_latin1_to_utf8(&ibuf, obuf);
  RETVAL     = newSVpvn(obuf->str, obuf->len);
OUTPUT:
  RETVAL
CLEANUP:
 ux_buffer_free(obuf,1);
