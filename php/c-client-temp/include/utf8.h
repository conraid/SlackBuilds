/* ========================================================================
 * Copyright 1988-2008 University of Washington
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * 
 * ========================================================================
 */

/*
 * Program:	UTF-8 routines
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	11 June 1997
 * Last Edited:	17 January 2008
 */

/* UTF-8 size and conversion routines from UCS-2 values (thus in the BMP).
 * Don't use these if UTF-16 data (surrogate pairs) are an issue.
 * For UCS-4 values, use the utf8_size() and utf8_put() functions.
 */

#define UTF8_SIZE_BMP(c) ((c & 0xff80) ? ((c & 0xf800) ? 3 : 2) : 1)

#define UTF8_PUT_BMP(b,c) {				\
  if (c & 0xff80) {		/* non-ASCII? */	\
    if (c & 0xf800) {		/* three byte code */	\
      *b++ = 0xe0 | (c >> 12);				\
      *b++ = 0x80 | ((c >> 6) & 0x3f);			\
    }							\
    else *b++ = 0xc0 | ((c >> 6) & 0x3f);		\
    *b++ = 0x80 | (c & 0x3f); 				\
  }							\
  else *b++ = c;					\
}

/* utf8_text() flag values */

#define U8T_CASECANON 2		/* canonicalize case */
#define U8T_DECOMPOSE 4		/* decompose */
				/* full canonicalization */
#define U8T_CANONICAL (U8T_CASECANON | U8T_DECOMPOSE)


/* utf8_get() return values */

				/* 0x0000 - 0xffff BMP plane */
#define U8GM_NONBMP 0xffff0000	/* mask for non-BMP values */
				/* 0x10000 - 0x10ffff extended planes */
				/* 0x110000 - 0x7ffffff non-Unicode */
#define U8G_ERROR 0x80000000	/* error flag */
#define U8G_BADCONT U8G_ERROR+1	/* continuation when not in progress */
#define U8G_INCMPLT U8G_ERROR+2	/* incomplete UTF-8 character */
#define U8G_NOTUTF8 U8G_ERROR+3	/* not a valid UTF-8 octet */
#define U8G_ENDSTRG U8G_ERROR+4	/* end of string */
#define U8G_ENDSTRI U8G_ERROR+5	/* end of string w/ incomplete UTF-8 char */
#define U8G_SURROGA U8G_ERROR+6	/* surrogate codepoint */
#define U8G_NOTUNIC U8G_ERROR+7	/* non-Unicode codepoint */


/* ucs4_width() return values */

#define U4W_ERROR 0x80000000	/* error flags */
#define U4W_NOTUNCD U4W_ERROR+1	/* not a Unicode char */
#define U4W_PRIVATE U4W_ERROR+2	/* private-space plane */
#define U4W_SSPCHAR U4W_ERROR+3	/* Supplementary Special-purpose Plane */
#define U4W_UNASSGN U4W_ERROR+4	/* unassigned space plane */
#define U4W_CONTROL U4W_ERROR+5	/* C0/C1 control */
#define U4W_CTLSRGT U4W_CONTROL	/* in case legacy code references this */

/* ISO-2022 engine states */

#define I2S_CHAR 0		/* character */
#define I2S_ESC 1		/* previous character was ESC */
#define I2S_MUL 2		/* previous character was multi-byte code */
#define I2S_INT 3		/* previous character was intermediate */


/* ISO-2022 Gn selections */

#define I2C_G0 0		/* G0 */
#define I2C_G1 1		/* G1 */
#define I2C_G2 2		/* G2 */
#define I2C_G3 3		/* G3 */
#define I2C_SG2 (2 << 2)	/* single shift G2 */
#define I2C_SG3 (3 << 2)	/* single shift G2 */


/* ISO-2022 octet definitions */

#define I2C_ESC 0x1b		/* ESCape */

	/* Intermediate character */
#define I2C_STRUCTURE 0x20	/* announce code structure */
#define I2C_C0 0x21		/* C0 */
#define I2C_C1 0x22		/* C1 */
#define I2C_CONTROL 0x23	/* single control function */
#define I2C_MULTI 0x24		/* multi-byte character set */
#define I2C_OTHER 0x25		/* other coding system */
#define I2C_REVISED 0x26	/* revised registration */
#define I2C_G0_94 0x28		/* G0 94-character set */
#define I2C_G1_94 0x29		/* G1 94-character set */
#define I2C_G2_94 0x2A		/* G2 94-character set */
#define I2C_G3_94 0x2B		/* G3 94-character set */
#define I2C_G0_96 0x2C		/* (not in ISO-2022) G0 96-character set */
#define I2C_G1_96 0x2D		/* G1 96-character set */
#define I2C_G2_96 0x2E		/* G2 96-character set */
#define I2C_G3_96 0x2F		/* G3 96-character set */

	/* Locking shifts */
#define I2C_SI 0x0f		/* lock shift to G0 (Shift In) */
#define I2C_SO 0x0e		/* lock shift to G1 (Shift Out) */
	/* prefixed by ESC */
#define I2C_LS2 0x6e		/* lock shift to G2 */
#define I2C_LS3 0x6f		/* lock shift to G3 */
#define I2C_LS1R 0x7e		/* lock shift GR to G1 */
#define I2C_LS2R 0x7d		/* lock shift GR to G2 */
#define I2C_LS3R 0x7c		/* lock shift GR to G3 */

	/* Single shifts */
#define I2C_SS2_ALT 0x8e	/* single shift to G2 (SS2) */
#define I2C_SS3_ALT 0x8f	/* single shift to G3 (SS3) */
#define I2C_SS2_ALT_7 0x19	/* single shift to G2 (SS2) */
#define I2C_SS3_ALT_7 0x1d	/* single shift to G3 (SS3) */
	/* prefixed by ESC */
#define I2C_SS2 0x4e		/* single shift to G2 (SS2) */
#define I2C_SS3 0x4f		/* single shift to G3 (SS3) */

/* 94 character sets */

				/* 4/0 ISO 646 IRV */
#define I2CS_94_BRITISH 0x41	/* 4/1 ISO 646 British */
#define I2CS_94_ASCII 0x42	/* 4/2 ISO 646 USA (ASCII) */
				/* 4/3 NATS Finland/Sweden (primary) */
				/* 4/4 NATS Finland/Sweden (secondary) */
				/* 4/5 NATS Denmark/Norway (primary) */
				/* 4/6 NATS Denmark/Norway (secondary) */
				/* 4/7 ISO 646 Swedish SEN 850200 */
				/* 4/8 ISO 646 Swedish names */
#define I2CS_94_JIS_BUGROM 0x48	/* 4/8 some buggy software does this */
#define I2CS_94_JIS_KANA 0x49	/* 4/9 JIS X 0201-1976 right half */
#define I2CS_94_JIS_ROMAN 0x4a	/* 4/a JIS X 0201-1976 left half */
				/* 4/b ISO 646 German */
				/* 4/c ISO 646 Portuguese (Olivetti) */
				/* 4/d ISO 6438 African */
				/* 4/e ISO 5427 Cyrillic (Honeywell-Bull) */
				/* 4/f DIN 31624 extended bibliography  */
				/* 5/0 ISO 5426-1980 Bibliography */
				/* 5/1 ISO 5427-1981 Cyrillic*/
				/* 5/2 ISO 646 French (withdrawn) */
				/* 5/3 ISO 5428-1980 Greek bibliography */
				/* 5/4 GB 1988-80 Chinese */
				/* 5/5 Latin-Greek (Honeywell-Bull) */
				/* 5/6 UK Viewdata/Teletext */
				/* 5/7 INIS (IRV subset) */
				/* 5/8 ISO 5428 Greek Bibliography */
				/* 5/9 ISO 646 Italian (Olivetti) */
				/* 5/a ISO 646 Spanish (Olivetti) */
				/* 5/b Greek (Olivetti) */
				/* 5/c Latin-Greek (Olivetti) */
				/* 5/d INIS non-standard extension */
				/* 5/e INIS Cyrillic extension */
				/* 5/f Arabic CODAR-U IERA */
				/* 6/0 ISO 646 Norwegian */
				/* 6/1 Norwegian version 2 (withdrawn) */
				/* 6/2 Videotex supplementary */
				/* 6/3 Videotex supplementary #2 */
				/* 6/4 Videotex supplementary #3 */
				/* 6/5 APL */
				/* 6/6 ISO 646 French */
				/* 6/7 ISO 646 Portuguese (IBM) */
				/* 6/8 ISO 646 Spanish (IBM) */
				/* 6/9 ISO 646 Hungarian */
				/* 6/a Greek ELOT (withdrawn) */
				/* 6/b ISO 9036 Arabic 7-bit */
				/* 6/c ISO 646 IRV supplementary set */
				/* 6/d JIS C6229-1984 OCR-A */
				/* 6/e JIS C6229-1984 OCR-B */
				/* 6/f JIS C6229-1984 OCR-B additional */
				/* 7/0 JIS C6229-1984 hand-printed */
				/* 7/1 JIS C6229-1984 additional hand-printd */
				/* 7/2 JIS C6229-1984 katakana hand-printed */
				/* 7/3 E13B Japanese graphic */
				/* 7/4 Supplementary Videotex (withdrawn) */
				/* 7/5 Teletex primary CCITT T.61 */
				/* 7/6 Teletex secondary CCITT T.61 */
				/* 7/7 CSA Z 243.4-1985 Alternate primary #1 */
				/* 7/8 CSA Z 243.4-1985 Alternate primary #2 */
				/* 7/9 Mosaic CCITT T.101 */
				/* 7/a Serbocroatian/Slovenian Latin */
				/* 7/b Serbocroatian Cyrillic */
				/* 7/c Supplementary CCITT T.101 */
				/* 7/d Macedonian Cyrillic */

/* 94 character sets - second intermediate byte */

				/* 4/0 Greek primary CCITT */
				/* 4/1 Cuba */
				/* 4/2 ISO/IEC 646 invariant */
				/* 4/3 Irish Gaelic 7-bit */
				/* 4/4 Turkmen */


/* 94x94 character sets */

#define I2CS_94x94_JIS_OLD 0x40	/* 4/0 JIS X 0208-1978 */
#define I2CS_94x94_GB 0x41	/* 4/1 GB 2312 */
#define I2CS_94x94_JIS_NEW 0x42	/* 4/2 JIS X 0208-1983 */
#define I2CS_94x94_KSC 0x43	/* 4/3 KSC 5601 */
#define I2CS_94x94_JIS_EXT 0x44	/* 4/4 JIS X 0212-1990 */
				/* 4/5 CCITT Chinese */
				/* 4/6 Blisssymbol Graphic */
#define I2CS_94x94_CNS1 0x47	/* 4/7 CNS 11643 plane 1 */
#define I2CS_94x94_CNS2 0x48	/* 4/8 CNS 11643 plane 2 */
#define I2CS_94x94_CNS3 0x49	/* 4/9 CNS 11643 plane 3 */
#define I2CS_94x94_CNS4 0x4a	/* 4/a CNS 11643 plane 4 */
#define I2CS_94x94_CNS5 0x4b	/* 4/b CNS 11643 plane 5 */
#define I2CS_94x94_CNS6 0x4c	/* 4/c CNS 11643 plane 6 */
#define I2CS_94x94_CNS7 0x4d	/* 4/d CNS 11643 plane 7 */
				/* 4/e DPRK (North Korea) KGCII */
				/* 4/f JGCII plane 1 */
				/* 5/0 JGCII plane 2 */

/* 96 character sets */

#define I2CS_96_ISO8859_1 0x41	/* 4/1 Latin-1 (Western Europe) */
#define I2CS_96_ISO8859_2 0x42	/* 4/2 Latin-2 (Czech, Slovak) */
#define I2CS_96_ISO8859_3 0x43	/* 4/3 Latin-3 (Dutch, Turkish) */
#define I2CS_96_ISO8859_4 0x44	/* 4/4 Latin-4 (Scandinavian) */
				/* 4/5 CSA Z 243.4-1985 */
#define I2CS_96_ISO8859_7 0x46	/* 4/6 Greek */
#define I2CS_96_ISO8859_6 0x47	/* 4/7 Arabic */
#define I2CS_96_ISO8859_8 0x48	/* 4/8 Hebrew */
				/* 4/9 Czechoslovak CSN 369103 */
				/* 4/a Supplementary Latin and non-alpha */
				/* 4/b Technical */
#define I2CS_96_ISO8859_5 0x4c	/* 4/c Cyrillic */
#define I2CS_96_ISO8859_9 0x4d	/* 4/d Latin-5 (Finnish, Portuguese) */
				/* 4/e ISO 6937-2 residual */
				/* 4/f Basic Cyrillic */
				/* 5/0 Supplementary Latin 1, 2 and 5 */
				/* 5/1 Basic Box */
				/* 5/2 Supplementary ISO/IEC 6937 : 1992 */
				/* 5/3 CCITT Hebrew supplementary */
#define I2CS_96_TIS620 0x54	/* 5/4 TIS 620 */
				/* 5/5 Arabic/French/German */
#define I2CS_96_ISO8859_10 0x56	/* 5/6 Latin-6 (Northern Europe) */
				/* 5/7 ??? */
				/* 5/8 Sami (Lappish) supplementary */
#define I2CS_96_ISO8859_13 0x59	/* 5/9 Latin-7 (Baltic) */
#define I2CS_96_VSCII 0x5a	/* 5/a Vietnamese */
				/* 5/b Technical #1 IEC 1289 */
#define I2CS_96_ISO8859_14 0x5c	/* 5/c Latin-8 (Celtic) */
				/* 5/d Sami supplementary Latin */
				/* 5/e Latin/Hebrew */
				/* 5/f Celtic supplementary Latin */
				/* 6/0 Uralic supplementary Cyrillic */
				/* 6/1 Volgaic supplementary Cyrillic */
#define I2CS_96_ISO8859_15 0x62	/* 6/2 Latin-9 (Euro) */
				/* 6/3 Latin-1 with Euro */
				/* 6/4 Latin-4 with Euro */
				/* 6/5 Latin-7 with Euro */
#define I2CS_96_ISO8859_16 0x66	/* 6/6 Latin-10 (Balkan) */
				/* 6/7 Ogham */
				/* 6/8 Sami supplementary Latin #2 */
				/* 7/d Supplementary Mosaic for CCITT 101 */

/* 96x96 character sets */

/* Types of character sets */

#define I2CS_94 0x000		/* 94 character set */
#define I2CS_96 0x100		/* 96 character set */
#define I2CS_MUL 0x200		/* multi-byte */
#define I2CS_94x94 (I2CS_MUL | I2CS_94)
#define I2CS_96x96 (I2CS_MUL | I2CS_96)


/* Character set identifiers stored in Gn */

#define I2CS_BRITISH (I2CS_94 | I2CS_94_BRITISH)
#define I2CS_ASCII (I2CS_94 | I2CS_94_ASCII)
#define I2CS_JIS_BUGROM (I2CS_94 | I2CS_94_JIS_BUGROM)
#define I2CS_JIS_KANA (I2CS_94 | I2CS_94_JIS_KANA)
#define I2CS_JIS_ROMAN (I2CS_94 | I2CS_94_JIS_ROMAN)
#define I2CS_JIS_OLD (I2CS_94x94 | I2CS_94x94_JIS_OLD)
#define I2CS_GB (I2CS_94x94 | I2CS_94x94_GB)
#define I2CS_JIS_NEW (I2CS_94x94 | I2CS_94x94_JIS_NEW)
#define I2CS_KSC (I2CS_94x94 | I2CS_94x94_KSC)
#define I2CS_JIS_EXT (I2CS_94x94 | I2CS_94x94_JIS_EXT)
#define I2CS_CNS1 (I2CS_94x94 | I2CS_94x94_CNS1)
#define I2CS_CNS2 (I2CS_94x94 | I2CS_94x94_CNS2)
#define I2CS_CNS3 (I2CS_94x94 | I2CS_94x94_CNS3)
#define I2CS_CNS4 (I2CS_94x94 | I2CS_94x94_CNS4)
#define I2CS_CNS5 (I2CS_94x94 | I2CS_94x94_CNS5)
#define I2CS_CNS6 (I2CS_94x94 | I2CS_94x94_CNS6)
#define I2CS_CNS7 (I2CS_94x94 | I2CS_94x94_CNS7)
#define I2CS_ISO8859_1 (I2CS_96 | I2CS_96_ISO8859_1)
#define I2CS_ISO8859_2 (I2CS_96 | I2CS_96_ISO8859_2)
#define I2CS_ISO8859_3 (I2CS_96 | I2CS_96_ISO8859_3)
#define I2CS_ISO8859_4 (I2CS_96 | I2CS_96_ISO8859_4)
#define I2CS_ISO8859_7 (I2CS_96 | I2CS_96_ISO8859_7)
#define I2CS_ISO8859_6 (I2CS_96 | I2CS_96_ISO8859_6)
#define I2CS_ISO8859_8 (I2CS_96 | I2CS_96_ISO8859_8)
#define I2CS_ISO8859_5 (I2CS_96 | I2CS_96_ISO8859_5)
#define I2CS_ISO8859_9 (I2CS_96 | I2CS_96_ISO8859_9)
#define I2CS_TIS620 (I2CS_96 | I2CS_96_TIS620)
#define I2CS_ISO8859_10 (I2CS_96 | I2CS_96_ISO8859_10)
#define I2CS_ISO8859_13 (I2CS_96 | I2CS_96_ISO8859_13)
#define I2CS_VSCII (I2CS_96 | I2CS_96_VSCII)
#define I2CS_ISO8859_14 (I2CS_96 | I2CS_96_ISO8859_14)
#define I2CS_ISO8859_15 (I2CS_96 | I2CS_96_ISO8859_15)
#define I2CS_ISO8859_16 (I2CS_96 | I2CS_96_ISO8859_16)


/* Miscellaneous ISO 2022 definitions */

#define EUC_CS2 0x8e		/* single shift CS2 */
#define EUC_CS3 0x8f		/* single shift CS3 */

#define BITS7 0x7f		/* 7-bit value mask */
#define BIT8 0x80		/* 8th bit mask */

/* The following saves us from having to have yet more charset tables */

/* Unicode codepoints */

#define UCS2_C0CONTROL 0x00	/* first C0 control */
#define UCS2_C0CONTROLEND 0x1F	/* last C0 control */
#define UCS2_C1CONTROL 0x80	/* first C1 control */
#define UCS2_C1CONTROLEND 0x9F	/* last C1 control */

				/* ISO 646 substituted Unicode codepoints */
#define UCS2_POUNDSTERLING 0x00a3
#define UCS2_YEN 0x00a5
#define UCS2_OVERLINE 0x203e
#define UCS2_EURO 0x20ac
#define UCS2_KATAKANA 0xff61	/* first katakana codepoint */
#define UCS2_BOM 0xfeff		/* byte order mark */
#define UCS2_BOGON 0xfffd	/* replacement character */
				/* next two codepoints are not Unicode chars */
#define UCS2_BOMCHECK 0xfffe	/* used to check byte order with UCS2_BOM */
#define UCS2_NOTCHAR 0xffff	/* not a character */

#define UCS4_BMPBASE 0x0000	/* Basic Multilingual Plane */
#define UCS4_SMPBASE 0x10000	/* Supplementary Multilinugual Plane */
#define UCS4_SIPBASE 0x20000	/* Supplementary Ideographic Plane */
				/* EastAsianWidth says plane 3 is wide */
#define UCS4_UNABASE 0x40000	/* unassigned space */
#define UCS4_SSPBASE 0xe0000	/* Supplementary Special-purpose Plane */
#define UCS4_PVTBASE 0xf0000	/* private-space (two planes) */
#define UCS4_MAXUNICODE 0x10ffff/* highest Unicode codepoint */

#define UTF16_BASE 0x10000	/* base of codepoints needing surrogates */
#define UTF16_SHIFT 10		/* surrogate shift */
#define UTF16_MASK 0x3ff	/* surrogate mask */
#define UTF16_SURR 0xd800	/* UTF-16 surrogate area */
#define UTF16_SURRH 0xd800	/* UTF-16 first high surrogate */
#define UTF16_SURRHEND 0xdbff	/* UTF-16 last high surrogate */
#define UTF16_SURRL 0xdc00	/* UTF-16 first low surrogate */
#define UTF16_SURRLEND 0xdfff	/* UTF-16 last low surrogate */
#define UTF16_MAXSURR 0xdfff	/* end of UTF-16 surrogates */


/* UBOGON is used to represent a codepoint in a character set which does not
 * map to Unicode.  It is also used for mapping failures, e.g. incomplete
 * shift sequences.  This name has the same text width as 0x????, for
 * convenience in the mapping tables.
 *
 * NOCHAR is used to represent a codepoint in Unicode which does not map to
 * the target character set in a reverse mapping table.  This name has the
 * same text width as 0x???? in case we ever add static reverse mapping tables.
 */

#define UBOGON UCS2_BOGON
#define NOCHAR UCS2_NOTCHAR

/* Codepoints in non-Unicode character sets */

/* Codepoints in ISO 646 character sets */

/* British ASCII codepoints */

#define BRITISH_POUNDSTERLING 0x23

/* JIS Roman codepoints */

#define JISROMAN_YEN 0x5c
#define JISROMAN_OVERLINE 0x7e


/* Hankaku katakana codepoints & parameters
 *
 * In earlier versions, MAX_KANA_7 and MAX_KANA_8 were the maximum codepoint
 * values.  Although this made sense, it was confusing with the "max ku" and
 * "max ten" values used in the double-byte tables; there are 1-origin, but
 * the calculated values used for "ku" and "ten" are 0-origin (derived by
 * substracting the "base").  What this all meant is that for double byte
 * characters the limit test is of the form (value < max_ku), but for single
 * byte characters (which used the same cell to hold the max ku) the limit
 * test was (value <= max_ku).
 *
 * By making MAX_KANA_[78] be maximum+1, the same (value < max_ku) limit test
 * is used throughout.  - 6/15/2006
 */

#define MIN_KANA_7 0x21
#define MAX_KANA_7 0x60		/* maximum value + 1 */
#define KANA_7 (UCS2_KATAKANA - MIN_KANA_7)
#define MIN_KANA_8 (MIN_KANA_7 | BIT8)
#define MAX_KANA_8 (MAX_KANA_7 | BIT8)
#define KANA_8 (UCS2_KATAKANA - MIN_KANA_8)

/* Charset scripts */

/*  The term "script" is used here in a very loose sense, enough to make
 * purists cringe.  Basically, the idea is to give the main program some
 * idea of how it should treat the characters of text in a charset with
 * respect to font, drawing routines, etc.
 *
 *  In some cases, "script" is associated with a charset; in other cases,
 * it's more closely tied to a language.
 */

#define SC_UNICODE 0x1		/* Unicode */
#define SC_LATIN_1 0x10		/* Western Europe */
#define SC_LATIN_2 0x20		/* Eastern Europe */
#define SC_LATIN_3 0x40		/* Southern Europe */
#define SC_LATIN_4 0x80		/* Northern Europe */
#define SC_LATIN_5 0x100	/* Turkish */
#define SC_LATIN_6 0x200	/* Nordic */
#define SC_LATIN_7 0x400	/* Baltic */
#define SC_LATIN_8 0x800	/* Celtic */
#define SC_LATIN_9 0x1000	/* Euro */
#define SC_LATIN_0 SC_LATIN_9	/* colloquial name for Latin-9 */
#define SC_ARABIC 0x2000
#define SC_CYRILLIC 0x4000
#define SC_GREEK 0x8000
#define SC_HEBREW 0x10000
#define SC_THAI 0x20000
#define SC_UKRANIAN 0x40000
#define SC_LATIN_10 0x80000	/* Balkan */
#define SC_VIETNAMESE 0x100000
#define SC_CHINESE_SIMPLIFIED 0x1000000
#define SC_CHINESE_TRADITIONAL 0x2000000
#define SC_JAPANESE 0x4000000
#define SC_KOREAN 0x8000000


/* Script table */

typedef struct utf8_scent {
  char *name;			/* script name */
  char *description;		/* script description */
  unsigned long script;		/* script bitmask */
} SCRIPT;

/* Character set table support */

typedef struct utf8_csent {
  char *name;			/* charset name */
  unsigned short type;		/* type of charset */
  unsigned short flags;		/* charset flags */
  void *tab;			/* additional data */
  unsigned long script;		/* script(s) implemented by this charset */
  char *preferred;		/* preferred charset over this one */
} CHARSET;


struct utf8_eucparam {
  unsigned int base_ku : 8;	/* base row */
  unsigned int base_ten : 8;	/* base column */
  unsigned int max_ku : 8;	/* maximum row */
  unsigned int max_ten : 8;	/* maximum column */
  void *tab;			/* conversion table */
};


/* Charset types */

#define CT_UNKNOWN 0		/* unknown 8-bit */
#define CT_ASCII 1		/* 7-bit ASCII no table */
#define CT_UCS2 2		/* 2 byte 16-bit Unicode no table */
#define CT_UCS4 3		/* 4 byte 32-bit Unicode no table */
#define CT_1BYTE0 10		/* 1 byte ISO 8859-1 no table */
#define CT_1BYTE 11		/* 1 byte ASCII + table 0x80-0xff */
#define CT_1BYTE8 12		/* 1 byte table 0x00 - 0xff */
#define CT_EUC 100		/* 2 byte ASCII + utf8_eucparam base/CS2/CS3 */
#define CT_DBYTE 101		/* 2 byte ASCII + utf8_eucparam */
#define CT_DBYTE2 102		/* 2 byte ASCII + utf8_eucparam plane1/2 */
#define CT_UTF16 1000		/* variable UTF-16 encoded Unicode no table */
#define CT_UTF8 1001		/* variable UTF-8 encoded Unicode no table */
#define CT_UTF7 1002		/* variable UTF-7 encoded Unicode no table */
#define CT_2022 10000		/* variable ISO-2022 encoded no table */
#define CT_SJIS 10001		/* 2 byte Shift-JIS encoded JIS no table */


/* Character set flags */

#define CF_PRIMARY 0x1		/* primary name for this charset */
#define CF_DISPLAY 0x2		/* charset used in displays */
#define CF_POSTING 0x4		/* charset used in email posting */
#define CF_UNSUPRT 0x8		/* charset unsupported (can't convert to it) */
#define CF_NOEMAIL 0x10		/* charset not used in email */


/* UTF-7 engine states */

#define U7_ASCII 0		/* ASCII character */
#define U7_PLUS 1		/* plus seen */
#define U7_UNICODE 2		/* Unicode characters */
#define U7_MINUS 3		/* absorbed minus seen */

/* Function prototypes */

typedef unsigned long (*ucs4cn_t) (unsigned long c);
typedef unsigned long (*ucs4de_t) (unsigned long c,void **more);

SCRIPT *utf8_script (char *script);
const CHARSET *utf8_charset (char *charset);
char *utf8_badcharset (char *charset);
long utf8_text (SIZEDTEXT *text,char *charset,SIZEDTEXT *ret,long flags);
long utf8_text_cs (SIZEDTEXT *text,const CHARSET *cs,SIZEDTEXT *ret,
		   ucs4cn_t cv,ucs4de_t de);
long utf8_cstext (SIZEDTEXT *text,char *charset,SIZEDTEXT *ret,
		  unsigned long errch);
long utf8_cstocstext (SIZEDTEXT *text,char *sc,SIZEDTEXT *ret,char *dc,
		      unsigned long errch);
unsigned short *utf8_rmap (char *charset);
unsigned short *utf8_rmap_cs (const CHARSET *cs);
unsigned short *utf8_rmap_gen (const CHARSET *cs,unsigned short *oldmap);
long utf8_rmaptext (SIZEDTEXT *text,unsigned short *rmap,SIZEDTEXT *ret,
		    unsigned long errch,long iso2022jp);
unsigned long utf8_rmapsize (SIZEDTEXT *text,unsigned short *rmap,
			     unsigned long errch,long iso2022jp);
long ucs4_rmaptext (unsigned long *ucs4,unsigned long len,unsigned short *rmap,
		    SIZEDTEXT *ret,unsigned long errch);
long ucs4_rmaplen (unsigned long *ucs4,unsigned long len,unsigned short *rmap,
		   unsigned long errch);
long ucs4_rmapbuf (unsigned char *t,unsigned long *ucs4,unsigned long len,
		   unsigned short *rmap,unsigned long errch);
unsigned long utf8_get (unsigned char **s,unsigned long *i);
unsigned long utf8_get_raw (unsigned char **s,unsigned long *i);
unsigned long ucs4_cs_get (CHARSET *cs,unsigned char **s,unsigned long *i);
unsigned long *utf8_csvalidmap (char *charsets[]);
const CHARSET *utf8_infercharset (SIZEDTEXT *src);
long utf8_validate (unsigned char *s,unsigned long i);
void utf8_text_1byte0 (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
void utf8_text_1byte (SIZEDTEXT *text,SIZEDTEXT *ret,void *tab,ucs4cn_t cv,
		      ucs4de_t de);
void utf8_text_1byte8 (SIZEDTEXT *text,SIZEDTEXT *ret,void *tab,ucs4cn_t cv,
		       ucs4de_t de);
void utf8_text_euc (SIZEDTEXT *text,SIZEDTEXT *ret,void *tab,ucs4cn_t cv,
		    ucs4de_t de);
void utf8_text_dbyte (SIZEDTEXT *text,SIZEDTEXT *ret,void *tab,ucs4cn_t cv,
		      ucs4de_t de);
void utf8_text_dbyte2 (SIZEDTEXT *text,SIZEDTEXT *ret,void *tab,ucs4cn_t cv,
		       ucs4de_t de);
void utf8_text_sjis (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
void utf8_text_2022 (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
void utf8_text_utf7 (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
void utf8_text_utf8 (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
void utf8_text_ucs2 (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
void utf8_text_ucs4 (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
void utf8_text_utf16 (SIZEDTEXT *text,SIZEDTEXT *ret,ucs4cn_t cv,ucs4de_t de);
unsigned long utf8_size (unsigned long c);
unsigned char *utf8_put (unsigned char *s,unsigned long c);
unsigned long ucs4_titlecase (unsigned long c);
long ucs4_width (unsigned long c);
long utf8_strwidth (unsigned char *s);
long utf8_textwidth (SIZEDTEXT *utf8);
unsigned long ucs4_decompose (unsigned long c,void **more);
unsigned long ucs4_decompose_recursive (unsigned long c,void **more);
