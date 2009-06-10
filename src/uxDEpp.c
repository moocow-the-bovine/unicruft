/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: uxDEpp.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: latin1/DE preprocessor: flex scanner wrapper
 *--------------------------------------------------------------------------*/

#include <uxDEpp.h>
#include <string.h>

//--------------------------------------------------------------
void ux_depp_init(uxDEpp *pp)
{
  assert(pp!=NULL);
  memset(pp,0,sizeof(pp));
  ux_de_yylex_init(&pp->scanner);
  ux_de_yyset_in (NULL, pp->scanner);
  ux_de_yyset_out(NULL, pp->scanner);
  ux_de_yyset_extra(&pp->data, pp->scanner);
}

//--------------------------------------------------------------
uxDEpp *ux_depp_new(void)
{
  uxDEpp *pp = (uxDEpp*)malloc(sizeof(uxDEpp));
  ux_depp_init(pp);
  return pp;
}

//--------------------------------------------------------------
void ux_depp_free_data(uxDEpp *pp)
{
  if (pp) {
    ux_de_yylex_destroy(pp->scanner);
    pp->scanner = NULL;
  }
}

//--------------------------------------------------------------
void ux_depp_free(uxDEpp *pp)
{
  ux_depp_free_data(pp);
  if (pp) free(pp);
}

//--------------------------------------------------------------
uxBuffer *ux_depp_scan_buffer(uxDEpp *pp, uxBuffer *in, uxBuffer *out)
{
  YY_BUFFER_STATE yybuf;

  //-- insert flex EOB sentinels
  ux_buffer_reserve(in, in->len+2);
  in->str[in->len++] = 0; //YY_END_OF_BUFFER_CHAR;
  in->str[in->len++] = 0; //YY_END_OF_BUFFER_CHAR;

  if (!out)
    out = ux_buffer_new(NULL,0,in->len);
  else 
    ux_buffer_reserve(out, out->len+in->len);

  pp->data.obuf = out;
  ux_de_yyset_extra(&pp->data, pp->scanner);                     //-- (re-)set scanner 'extra' data
  yybuf = ux_de_yy_scan_buffer(in->str, in->len, pp->scanner);   //-- ... scan the buffer (in-place)
  assert2(yybuf != NULL, "couldn't set up flex buffer");

  ux_de_yylex(pp->scanner);
  //ux_buffer_append_delim(out, '\0'); //-- always NUL-terminate (because uxUtf8.c is so stupid)

  //-- cleanup
  in->len -= 2; //-- "remove" flex EOB sentinels
  if (yybuf) ux_de_yy_delete_buffer(yybuf,pp->scanner);
  return out;
}

//--------------------------------------------------------------
uxBuffer *ux_depp_scan_const_buffer(uxDEpp *pp, const uxBuffer *in, uxBuffer *out)
{
  YY_BUFFER_STATE yybuf;

  if (!out)
    out = ux_buffer_new(NULL,0,in->len+1);
  else 
    ux_buffer_reserve(out, out->len+in->len+1);

  pp->data.obuf = out;
  ux_de_yyset_extra(&pp->data, pp->scanner);                     //-- (re-)set scanner 'extra' data
  yybuf = ux_de_yy_scan_bytes(in->str, in->len, pp->scanner);    //-- ... scan the buffer (copy)
  assert2(yybuf != NULL, "couldn't set up flex buffer");

  ux_de_yylex(pp->scanner);
  //ux_buffer_append_delim(out, '\0'); //-- always NUL-terminate (because uxUtf8.c is so stupid)

  if (yybuf) ux_de_yy_delete_buffer(yybuf,pp->scanner);
  return out;
}
