#ifndef UX_UTF8_H
#define UX_UTF8_H

/*--moo--*/
#include "uxCommon.h"
/** \file
 * \brief Basic UTF-8 manipulation routines by Jeff Bezanson
 * \details
 * (from original utf8.c)
 *
 * Basic UTF-8 manipulation routines<br/>
 * by Jeff Bezanson<br/>
 * placed in the public domain Fall 2005
 *
 * This code is designed to provide the utilities you need to manipulate
 * UTF-8 as an internal string encoding. These functions do not perform the
 * error checking normally needed when handling UTF-8 data, so if you happen
 * to be from the Unicode Consortium you will want to flay me alive.
 * I do this because error checking can be performed at the boundaries (I/O),
 * with these routines reserved for higher performance on data known to be
 * valid.
 */
/*--/moo--*/

#include <stdarg.h>

/** is c the start of a utf8 sequence? */
#define isutf(c) (((c)&0xC0)!=0x80)

/** convert UTF-8 data to wide character, without error checking
 * \warning only works for valid UTF-8, i.e. no 5- or 6-byte sequences
 * \param dest = destination wide character buffer
 * \param sz = dest size in number of wide characters
 * \param src = source UTF-8 byte string
 * \param srcsz = source size in bytes, or -1 if 0-terminated
 * \returns number of characters converted
 * \li dest will always be L'\0'-terminated, even if there isn't enough room for all the characters
 * \li if <tt>sz = srcsz+1</tt> (i.e. <tt>4*srcsz+4</tt> bytes), there will always be enough space.
 */
int u8_toucs(u_int32_t *dest, int sz, char *src, int srcsz);

/** convert UTF-8 byte string to UCS-4 wide character string
 * \param dest = destination wide-character buffer
 * \param sz = dest size in number of bytes
 * \param source = source UTF-8 string buffer
 * \param srcsz = source size in number of wide characters, or -1 if 0-terminated
 * \returns number of characters converted
 *
 * \li dest will only be '\0'-terminated if there is enough space. this is
 * for consistency; imagine there are 2 bytes of space left, but the next
 * character requires 3 bytes. in this case we could NUL-terminate, but in
 * general we can't when there's insufficient space. therefore this function
 * only NUL-terminates if all the characters fit, and there's space for
 * the NUL as well.
 *
 * \li the destination string will never be bigger than the source string.
 */
int u8_toutf8(char *dest, int sz, u_int32_t *src, int srcsz);

/** (moo) get number of bytes required for representing a wide character \a ch in UTF-8 */
int u8_wc_len(u_int32_t ch);

/** (moo) get number of bytes required for representing a wide character string \a ws in UTF-8 */
int u8_ws_len(u_int32_t *src, int srcsz);

/** single character to UTF-8
 * \param dest destination buffer
 * \param ch character to convert
 * \returns number of bytes written to \a dest (0 <= RETVAL <= 4)
 */
int u8_wc_toutf8(char *dest, u_int32_t ch);

/** character number to byte offset */
int u8_offset(char *str, int charnum);

/** byte offset to character number */
int u8_charnum(char *s, int offset);

/** return next character, updating an index variable */
u_int32_t u8_nextchar(char *s, int *i);

/** move to next character */
void u8_inc(char *s, int *i);

/** move to previous character */
void u8_dec(char *s, int *i);

/** returns length of next utf-8 sequence */
int u8_seqlen(char *s);

/** assuming src points to the character after a backslash, read an
   escape sequence, storing the result in dest and returning the number of
   input characters processed */
int u8_read_escape_sequence(char *src, u_int32_t *dest);

/** given a wide character, convert it to an ASCII escape sequence stored in
   buf, where buf is "sz" bytes. returns the number of characters output. */
int u8_escape_wchar(char *buf, int sz, u_int32_t ch);

/** convert a string "src" containing escape sequences to UTF-8 */
int u8_unescape(char *buf, int sz, char *src);

/** convert UTF-8 "src" to ASCII with escape sequences.
   if escape_quotes is nonzero, quote characters will be preceded by
   backslashes as well. */
int u8_escape(char *buf, int sz, char *src, int escape_quotes);

/** utility predicates used by the above */
int octal_digit(char c);
int hex_digit(char c);

/** return a pointer to the first occurrence of ch in s, or NULL if not
   found. character index of found character returned in *charn. */
char *u8_strchr(char *s, u_int32_t ch, int *charn);

/** same as the above, but searches a buffer of a given size instead of
   a NUL-terminated string. */
char *u8_memchr(char *s, u_int32_t ch, size_t sz, int *charn);

/** count the number of characters in a UTF-8 string */
int u8_strlen(char *s);

int u8_is_locale_utf8(char *locale);

/** printf where the format string and arguments may be in UTF-8.
   you can avoid this function and just use ordinary printf() if the current
   locale is UTF-8. */
int u8_vprintf(char *fmt, va_list ap);
int u8_printf(char *fmt, ...);

#endif /* UX_UTF8_H */

