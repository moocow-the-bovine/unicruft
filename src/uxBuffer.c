/*--------------------------------------------------------------------------
 * File: uxBuffer.c
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: string buffers
 *--------------------------------------------------------------------------*/

#include <uxBuffer.h>
#include <uxUtf8.h>

/*======================================================================
 * uxBuffer
 */

//--------------------------------------------------------------
uxBuffer *ux_buffer_new(char *str, size_t len, size_t sz)
{
  uxBuffer *buf = (uxBuffer*)malloc(sizeof(uxBuffer));
  assert(buf!=NULL);
  buf->str   = str;
  buf->len   = len;
  buf->alloc = sz;
  if (str==NULL && sz > 0) {
    buf->str = (char*)malloc(sz);
    assert(buf->str != NULL);
  }
  return buf;
}

//--------------------------------------------------------------
void ux_buffer_free(uxBuffer *buf, int free_data)
{
  if (!buf) return;
  if (free_data && buf->str != NULL) free(buf->str);
  free(buf);
}

/*======================================================================
 * uxWBuffer
 */

//--------------------------------------------------------------
uxWBuffer *ux_wbuffer_new(ucs4 *wstr, size_t len, size_t sz)
{
  uxWBuffer *buf = (uxWBuffer*)malloc(sizeof(uxWBuffer));
  assert(buf!=NULL);
  buf->wstr  = wstr;
  buf->len   = len;
  buf->alloc = sz;
  if (wstr==NULL && sz > 0) {
    buf->wstr = (ucs4*)malloc(sz*sizeof(ucs4));
    assert(buf->wstr != NULL);
  }
  return buf;
}

//--------------------------------------------------------------
void ux_wbuffer_free(uxWBuffer *buf, int free_data)
{
  if (!buf) return;
  if (free_data && buf->wstr != NULL) free(buf->wstr);
  free(buf);
}

//--------------------------------------------------------------
void ux_wbuffer_append_wstr(uxWBuffer *buf, const ucs4 *s)
{
  size_t slen,i;
  for (slen=0; s && s[slen]; slen++) ;
  ux_wbuffer_reserve(buf, buf->len+slen+1);
  for (i=0; i <= slen; i++) {
    buf->wstr[buf->len+i] = s[i];
  }
  buf->len += slen; //-- don't count terminating NULL
}



/*======================================================================
 * Conversions
 */

//--------------------------------------------------------------
void ux_buffer_utf8_to_ucs4(const uxBuffer *src, uxWBuffer *dst)
{
  ux_wbuffer_reserve(dst, dst->len + u8_strlen(src->str) + 1);
  dst->len += u8_toucs(dst->wstr+dst->len, dst->alloc-dst->len, src->str, src->len);
}

//--------------------------------------------------------------
void ux_buffer_ucs4_to_utf8(const uxWBuffer *src, uxBuffer *dst)
{
  int src_nbytes = u8_ws_len(src->wstr,src->len);
  ux_buffer_reserve(dst, dst->len + src_nbytes + 1);
  u8_toutf8(dst->str+dst->len, dst->alloc-dst->len, src->wstr, src->len);
  dst->len += src_nbytes;
}

//--------------------------------------------------------------
void ux_buffer_utf8_to_latin1(const uxBuffer *src, uxBuffer *dst)
{
  int i;
  ux_buffer_reserve(dst, src->len+1);
  for (i=0; (size_t)i < src->len; dst->len++) {
    dst->str[dst->len] = (char)u8_nextcharn(src->str, src->len, &i);
  }
  dst->str[dst->len++] = '\0';
}

//--------------------------------------------------------------
void ux_buffer_latin1_to_utf8(const uxBuffer *src, uxBuffer *dst)
{
  size_t u8_nbytes=0, i,j;
  for (i=0; i < src->len; i++) {
    u8_nbytes += u8_wc_len( (unsigned char)src->str[i] );
  }
  ux_buffer_reserve(dst, dst->len + u8_nbytes + 1);
  for (i=0,j=dst->len; i < src->len; i++) {
    j += u8_wc_toutf8(&dst->str[j], (unsigned char)src->str[i] );
  }
  dst->str[j] = '\0';
  dst->len = j;
}


/*======================================================================
 * I/O
 */

//--------------------------------------------------------------
#define UX_BUFFER_GETDELIM_DEFAULT_BUFSIZE 256
ssize_t ux_buffer_getdelim(uxBuffer *buf, int delim, FILE *f)
{
#ifdef HAVE_GETDELIM
  ssize_t nread = getdelim(&buf->str, &buf->alloc, delim, f);
  buf->len = nread >= 0 ? nread : 0;
  return nread;
#else
  register int c;

  //-- initialize/reset buffer
  assert(buf!=NULL);
  if (buf->len==0) ux_buffer_reserve(buf,UX_BUFFER_GETDELIM_DEFAULT_BUFSIZE);
  buf->len = 0;

  //-- read character-wise
  for (c=getc(f); c!=EOF; c=getc(f)) {
    if (buf->alloc == buf->len+1) ux_buffer_reserve(buf,buf->alloc*2);  //-- maybe resize buffer
    buf->str[buf->len++] = c;                                           //-- append char
    if (c==delim) break;                                                //-- check for delimiter
  }
  buf->str[buf->len] = '\0';

  //-- return
  return buf->len==0 ? -1 : ((ssize_t)buf->len);
#endif
}

//--------------------------------------------------------------
size_t ux_buffer_fread(uxBuffer *buf, size_t nbytes, FILE *f)
{
  ux_buffer_reserve(buf,nbytes+1);
  buf->len = fread(buf->str, sizeof(char),nbytes, f);
  ux_buffer_append_delim(buf,'\0');
  return buf->len;
}

//--------------------------------------------------------------
#define UX_BUFFER_SLURP_DEFAULT_BUFSIZE 2048
#define UX_BUFFER_SLURP_MIN_BUFSIZE 256
size_t ux_buffer_slurp_file(uxBuffer *buf, FILE *f)
{
  size_t nread;

  //-- initialize buffer size if zero)
  if (buf->alloc == 0) ux_buffer_reserve(buf,UX_BUFFER_SLURP_DEFAULT_BUFSIZE);
  buf->len = 0;

  //-- loop
  while (!feof(f)) {
    if (buf->alloc-buf->len < UX_BUFFER_SLURP_MIN_BUFSIZE)
      ux_buffer_reserve(buf, 2*buf->len);

    nread = fread(buf->str+buf->len, sizeof(char),(buf->alloc-buf->len), f);
    buf->len += nread;
  }

  //-- delimit & return
  ux_buffer_append_delim(buf,'\0');
  return buf->len;
}
