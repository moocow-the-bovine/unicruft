#include "uxUnidecode.h"

const uxLookupTable UNIDECODE_LATIN1 = {
  256,  /*-- number of entries --*/
  {
   "\x0"   , "\x1"   , "\x2"   , "\x3"   , "\x4"   , "\x5"   , "\x6"   , "\x7"   ,  /*-- 0x0000 .. 0x0007 --*/
   "\x8"   , "\t"    , "\n"    , ""     , ""     , "\r"    , "\xe"   , "\xf"   ,  /*-- 0x0008 .. 0x000f --*/
   "\x10"  , "\x11"  , "\x12"  , "\x13"  , "\x14"  , "\x15"  , "\x16"  , "\x17"  ,  /*-- 0x0010 .. 0x0017 --*/
   "\x18"  , "\x19"  , "\x1a"  , "\x1b"  , "\x1c"  , "\x1d"  , "\x1e"  , "\x1f"  ,  /*-- 0x0018 .. 0x001f --*/
   " "     , "!"     , "\""    , "#"     , "$"     , "%"     , "&"     , "'"     ,  /*-- 0x0020 .. 0x0027 --*/
   "("     , ")"     , "*"     , "+"     , ","     , "-"     , "."     , "/"     ,  /*-- 0x0028 .. 0x002f --*/
   "0"     , "1"     , "2"     , "3"     , "4"     , "5"     , "6"     , "7"     ,  /*-- 0x0030 .. 0x0037 --*/
   "8"     , "9"     , ":"     , ";"     , "<"     , "="     , ">"     , "?"     ,  /*-- 0x0038 .. 0x003f --*/
   "@"     , "A"     , "B"     , "C"     , "D"     , "E"     , "F"     , "G"     ,  /*-- 0x0040 .. 0x0047 --*/
   "H"     , "I"     , "J"     , "K"     , "L"     , "M"     , "N"     , "O"     ,  /*-- 0x0048 .. 0x004f --*/
   "P"     , "Q"     , "R"     , "S"     , "T"     , "U"     , "V"     , "W"     ,  /*-- 0x0050 .. 0x0057 --*/
   "X"     , "Y"     , "Z"     , "["     , "\\"    , "]"     , "^"     , "_"     ,  /*-- 0x0058 .. 0x005f --*/
   "`"     , "a"     , "b"     , "c"     , "d"     , "e"     , "f"     , "g"     ,  /*-- 0x0060 .. 0x0067 --*/
   "h"     , "i"     , "j"     , "k"     , "l"     , "m"     , "n"     , "o"     ,  /*-- 0x0068 .. 0x006f --*/
   "p"     , "q"     , "r"     , "s"     , "t"     , "u"     , "v"     , "w"     ,  /*-- 0x0070 .. 0x0077 --*/
   "x"     , "y"     , "z"     , "{"     , "|"     , "}"     , "~"     , "\x7f"  ,  /*-- 0x0078 .. 0x007f --*/
   "\x80"  , "\x81"  , "\x82"  , "\x83"  , "\x84"  , "�"     , "\x86"  , "\x87"  ,  /*-- 0x0080 .. 0x0087 --*/
   "\x88"  , "\x89"  , "\x8a"  , "\x8b"  , "\x8c"  , "\x8d"  , "\x8e"  , "\x8f"  ,  /*-- 0x0088 .. 0x008f --*/
   "\x90"  , "\x91"  , "\x92"  , "\x93"  , "\x94"  , "\x95"  , "\x96"  , "\x97"  ,  /*-- 0x0090 .. 0x0097 --*/
   "\x98"  , "\x99"  , "\x9a"  , "\x9b"  , "\x9c"  , "\x9d"  , "\x9e"  , "\x9f"  ,  /*-- 0x0098 .. 0x009f --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00a0 .. 0x00a7 --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00a8 .. 0x00af --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00b0 .. 0x00b7 --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00b8 .. 0x00bf --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00c0 .. 0x00c7 --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00c8 .. 0x00cf --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00d0 .. 0x00d7 --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00d8 .. 0x00df --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00e0 .. 0x00e7 --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00e8 .. 0x00ef --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     ,  /*-- 0x00f0 .. 0x00f7 --*/
   "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"     , "�"        /*-- 0x00f8 .. 0x00ff --*/
  }
};