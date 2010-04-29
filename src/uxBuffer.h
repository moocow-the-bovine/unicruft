/* -*- Mode: C -*- */

/*--------------------------------------------------------------------------
 * File: uxBuffer.h
 * Author: Bryan Jurish <jurish@bbaw.de>
 * Description:
 *   + utf8-latin1 approximator: (wide) string buffers
 *--------------------------------------------------------------------------*/
/** \file
 *  \brief byte-string and wide-character string buffer types & utilities
 */

#ifndef UX_BUFFER_H
#define UX_BUFFER_H

#include <uxCommon.h>

#include <stddef.h>
#include <stdlib.h>
#include <string.h>


//======================================================================
/// \name uxBuffer
//@{

/** \brief resizeable string buffer struct */
typedef struct {
  char    *str;     ///< \details underlying string data
  size_t   len;     ///< \details number of used bytes
  size_t alloc;     ///< \details number of allocated bytes
} uxBuffer;

/** string-buffer constructor
 *  \param str initial string buffer or NULL
 *  \param len number of bytes used in \a str
 *  \param sz allocated size of \a str or requested initial size
 *  \returns new string buffer
 *  \note
 *   if passing a non-NULL \a str argument and you want to use
 *   the re-allocation features of ::uxBuffer, then \a str
 *   have been allocated with malloc().
 */
uxBuffer *ux_buffer_new(char *str, size_t len, size_t sz);

/** string-buffer destructor
 *  \param free_data (boolean) if true, \a buf->str will be freed; otherwise not
 */
void ux_buffer_free(uxBuffer *buf, int free_data);

/** ensure string buffer has space allocated for at least \a sz bytes */
static inline
void ux_buffer_reserve(uxBuffer *buf, size_t sz)
{
  if (sz <= buf->alloc) return;
  buf->str = (char*)realloc(buf->str, sz);
  assert(buf->str != NULL);
  buf->alloc = sz;
}

/** ensure string buffer has space allocated for at least \a sz bytes, growing to size \a szx if realloc is required */
static inline
void ux_buffer_reservex(uxBuffer *buf, size_t sz, size_t szx)
{
  if (sz <= buf->alloc) return;
  if (szx < sz) szx = sz;
  buf->str = (char*)realloc(buf->str, szx);
  assert(buf->str != NULL);
  buf->alloc = szx;
}

/** append a single character to a string buffer */
static inline
void ux_buffer_append_char(uxBuffer *buf, char c)
{
  ux_buffer_reserve(buf, buf->len+1);
  buf->str[buf->len++] = c;
  if (buf->len < buf->alloc) buf->str[buf->len]='\0';
}

/** append a terminator character to a buffer (does not modify buf->len) */
static inline
void ux_buffer_append_delim(uxBuffer *buf, char delim)
{
  ux_buffer_reserve(buf, buf->len+1);
  buf->str[buf->len] = delim;
}

/** append the contents of \a buf2 onto the end of \a buf1 */
static inline
void ux_buffer_append_buf(uxBuffer *buf1, const uxBuffer *buf2)
{
  ux_buffer_reserve(buf1, buf1->len+buf2->len);
  memcpy(buf1->str+buf1->len, buf2->str, buf2->len);
  buf1->len += buf2->len;
}

/** append a NUL-terminated string onto a string buffer */
static inline
void ux_buffer_append_str(uxBuffer *buf, const char *s)
{
  size_t slen = strlen(s);
  ux_buffer_reserve(buf, buf->len+slen);
  strcpy(buf->str+buf->len, s);
  buf->len += slen;
}

/** append binary data to a buffer */
static inline
void ux_buffer_append_data(uxBuffer *buf, const char *s, size_t slen)
{
  ux_buffer_reserve(buf, buf->len+slen);
  memcpy(buf->str+buf->len, s, slen);
  buf->len += slen;
}

//@}

//======================================================================
/// \name uxWBuffer
//@{

/** \brief resizeable UCS4-string buffer struct */
typedef struct {
  ucs4   *wstr;     ///< \details underlying string data
  size_t   len;     ///< \details number of used characters
  size_t alloc;     ///< \details number of allocated characters
} uxWBuffer;

/** UCS4 wide-string-buffer constructor
 *  \param wstr initial UCS4 wide-string-buffer or NULL
 *  \param len number of characters used in \a wstr
 *  \param sz allocated size of \a wstr or requested initial size, in characters
 *  \returns new string buffer
 *  \note
 *   if passing a non-NULL \a wstr argument and you want to use
 *   the re-allocation features of ::uxBuffer, then \a wstr
 *   have been allocated with malloc().
 */
uxWBuffer *ux_wbuffer_new(ucs4 *wstr, size_t len, size_t sz);

/** UCS4 wide-string-buffer destructor
 *  \param free_data (boolean) if true, \a buf->wstr will be freed; otherwise not
 */
void ux_wbuffer_free(uxWBuffer *buf, int free_data);

/** ensure UCS4 wide-string buffer has space allocated for at least \a sz characters */
static inline
void ux_wbuffer_reserve(uxWBuffer *buf, size_t sz)
{
  if (sz <= buf->alloc) return;
  buf->wstr = (ucs4*)realloc(buf->wstr, sz*sizeof(ucs4));
  assert(buf->wstr != NULL);
}

/** append a single character to a UCS4 wide string buffer */
static inline
void ux_wbuffer_append_char(uxWBuffer *buf, ucs4 c)
{
  ux_wbuffer_reserve(buf, buf->len+1);
  buf->wstr[buf->len++] = c;
  if (buf->len < buf->alloc) buf->wstr[buf->len]=0;
}

/** append a terminator character to a wide characte4r buffer (does not modify buf->len) */
static inline
void ux_wbuffer_append_delim(uxWBuffer *buf, ucs4 delim)
{
  ux_wbuffer_reserve(buf, buf->len+1);
  buf->wstr[buf->len] = delim;
}

/** append the contents of \a wbuf2 onto the end of \a wbuf1 */
static inline
void ux_wbuffer_append_buf(uxWBuffer *buf1, const uxWBuffer *buf2)
{
  ux_wbuffer_reserve(buf1, buf1->len+buf2->len);
  memcpy(buf1->wstr+buf1->len, buf2->wstr, buf2->len*sizeof(ucs4));
  buf1->len += buf2->len;
}

/** append a NUL-terminated UCS4 wide string onto a UCS4 wide string buffer */
void ux_wbuffer_append_wstr(uxWBuffer *buf, const ucs4 *s);

/** append binary data to a UCS4 wide buffer */
static inline
void ux_wbuffer_append_data(uxWBuffer *buf, const ucs4 *ws, size_t wslen)
{
  ux_wbuffer_reserve(buf, buf->len+wslen);
  memcpy(buf->wstr+buf->len, ws, wslen*sizeof(ucs4));
  buf->len += wslen;
}

//@}

//======================================================================
/// \name Conversions
//@{

/** Convert/append a UTF-8 string buffer UCS-4 wide string buffer
 *  \param src source utf-8 string buffer
 *  \param dst destination ucs-4 buffer
 *
 *  \li always NULL-terminates output buffer
 *  \li may auto-grow output buffer
 *  \li converted data is appended to output buffer; if you want an assignment-style conversion,
 *      just set <code>dst->len=0;</code> before calling this function.
 */
void ux_buffer_utf8_to_ucs4(const uxBuffer *src, uxWBuffer *dst);

/** Convert/append a UCS-4 wide string buffer to a UTF-8 string buffer
 *  \param src source ucs-4 buffer
 *  \param dst destination utf-8 string buffer
 *
 *  \li always NULL-terminates output buffer
 *  \li may auto-grow output buffer
 *  \li converted data is appended to output buffer; if you want an assignment-style conversion,
 *      just set <code>dst->len=0;</code> before calling this function.
 */
void ux_buffer_ucs4_to_utf8(const uxWBuffer *src, uxBuffer *dst);

/** convert/append a UTF-8 string buffer to a Latin-1 string buffer, without transliteration
 *  \param src source UTF-8 buffer
 *  \param dst destination latin-1 string buffer
 *
 *  \li always NULL-terminates output buffer
 *  \li may auto-grow output buffer
 *  \li converted data is appended to output buffer; if you want an assignment-style conversion,
 *      just set <code>dst->len=0;</code> before calling this function.
 *
 *  \warning the source UTF-8 string \a src is assumed to be Latin1-safe,
 *    i.e. all codepoints are assumed to be in the range (0..255) = [\x00-\xff].
 */
void ux_buffer_utf8_to_latin1(const uxBuffer *src, uxBuffer *dst);

/** convert/append a Latin-1 string buffer to a UTF-8 string buffer
 *  \param src source latin-1 buffer
 *  \param dst destination utf-8 string buffer
 *
 *  \li always NULL-terminates output buffer
 *  \li may auto-grow output buffer
 *  \li converted data is appended to output buffer; if you want an assignment-style conversion,
 *      just set <code>dst->len=0;</code> before calling this function.
 */
void ux_buffer_latin1_to_utf8(const uxBuffer *src, uxBuffer *dst);

//@}

//======================================================================
/// \name I/O
//@{

/** Read a delimited record from a file into a buffer.
 *  \param buf buffer in which to store data read
 *  \param delim delimiter character
 *  \returns number of bytes read, or <0 on error
 * \li clobbers current contents of \a buf, if any.
 * \li \a buf may be resized by this call
 * \li NUL-terminates \a buf
 * \li on return, \a buf->len contains the number of bytes
 *     read into \a buf->str, up to and including the delimiter \a delim,
 *     but not including the terminating '\0'.
 */
ssize_t ux_buffer_getdelim(uxBuffer *buf, int delim, FILE *f);

/** Reads a single line from a file into a buffer.
 *  Really just an alias for <code>ux_buffer_getdelim(buf,'\n',f)</code>
 */
static inline
ssize_t ux_buffer_getline(uxBuffer *buf, FILE *f)
{
  return ux_buffer_getdelim(buf,'\n',f);
}

/** write raw buffer contents to a file.
 *  \returns number of bytes written, which should == buf->len on success
 */
static inline
size_t ux_buffer_fwrite(uxBuffer *buf, FILE *f)
{
  return fwrite(buf->str, sizeof(char),buf->len, f);
}

/** Read a fixed number of bytes from a file into a buffer.
 *  \param buf buffer in which to store data read
 *  \param nbytes max number of bytes to read
 *  \returns number of bytes actually read
 * \li clobbers current contents of \a buf, if any.
 * \li \a buf may be resized by this call
 * \li NUL-terminates \a buf
 * \li on return, \a buf->len contains the number of bytes
 *     read into \a buf->str, up to and not including the terminating '\0'.
 */
size_t ux_buffer_fread(uxBuffer *buf, size_t nbytes, FILE *f);

/** Slurp all remaining data from a stream into a buffer.
 *  \param buf buffer in which to store file data
 *  \param rbufsize size of temporary read buffer, in bytes
 *  \param f name of the file to slurp
 *  \returns number of bytes actually read
 * \li clobbers current contents of \a buf, if any.
 * \li \a buf may be resized by this call
 * \li NUL-terminates \a buf
 * \li on return, \a buf->len contains the number of bytes
 *     read into \a buf->str, up to and not including the terminating '\0'.
 */
size_t ux_buffer_slurp_file(uxBuffer *buf, FILE *f);

//@}

#endif /* UX_BUFFER_H */
