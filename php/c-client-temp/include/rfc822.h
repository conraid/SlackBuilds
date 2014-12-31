/* ========================================================================
 * Copyright 1988-2006 University of Washington
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
 * Program:	RFC 2822 and MIME routines
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	27 July 1988
 * Last Edited:	30 August 2006
 *
 * This original version of this file is
 * Copyright 1988 Stanford University
 * and was developed in the Symbolic Systems Resources Group of the Knowledge
 * Systems Laboratory at Stanford University in 1987-88, and was funded by the
 * Biomedical Research Technology Program of the NationalInstitutes of Health
 * under grant number RR-00785.
 */

#define MAXGROUPDEPTH 50	/* RFC [2]822 doesn't allow any group nesting */
#define MAXMIMEDEPTH 50		/* more than any sane MIMEgram */

/* Output buffering for RFC [2]822 */

typedef long (*soutr_t) (void *stream,char *string);
typedef long (*rfc822out_t) (char *tmp,ENVELOPE *env,BODY *body,soutr_t f,
			     void *s,long ok8bit);

typedef struct rfc822buffer {
  soutr_t f;			/* I/O flush routine */
  void *s;			/* stream for I/O routine */
  char *beg;			/* start of buffer */
  char *cur;			/* current buffer pointer */
  char *end;			/* end of buffer */
} RFC822BUFFER;

typedef long (*rfc822outfull_t) (RFC822BUFFER *buf,ENVELOPE *env,BODY *body,
				 long ok8bit);

/* Function prototypes */

char *rfc822_default_subtype (unsigned short type);
void rfc822_parse_msg_full (ENVELOPE **en,BODY **bdy,char *s,unsigned long i,
			    STRING *bs,char *host,unsigned long depth,
			    unsigned long flags);
void rfc822_parse_content (BODY *body,STRING *bs,char *h,unsigned long depth,
			   unsigned long flags);
void rfc822_parse_content_header (BODY *body,char *name,char *s);
void rfc822_parse_parameter (PARAMETER **par,char *text);
void rfc822_parse_adrlist (ADDRESS **lst,char *string,char *host);
ADDRESS *rfc822_parse_address (ADDRESS **lst,ADDRESS *last,char **string,
			       char *defaulthost,unsigned long depth);
ADDRESS *rfc822_parse_group (ADDRESS **lst,ADDRESS *last,char **string,
			     char *defaulthost,unsigned long depth);
ADDRESS *rfc822_parse_mailbox (char **string,char *defaulthost);
long rfc822_phraseonly (char *end);
ADDRESS *rfc822_parse_routeaddr (char *string,char **ret,char *defaulthost);
ADDRESS *rfc822_parse_addrspec (char *string,char **ret,char *defaulthost);
char *rfc822_parse_domain (char *string,char **end);
char *rfc822_parse_phrase (char *string);
char *rfc822_parse_word (char *string,const char *delimiters);
char *rfc822_cpy (char *src);
char *rfc822_quote (char *src);
ADDRESS *rfc822_cpy_adr (ADDRESS *adr);
void rfc822_skipws (char **s);
char *rfc822_skip_comment (char **s,long trim);

long rfc822_output_full (RFC822BUFFER *buf,ENVELOPE *env,BODY *body,long ok8);
long rfc822_output_flush (RFC822BUFFER *buf);
long rfc822_output_header (RFC822BUFFER *buf,ENVELOPE *env,BODY *body,
			   const char *specials,long flags);
long rfc822_output_header_line (RFC822BUFFER *buf,char *type,long resent,
				char *text);
long rfc822_output_address_line (RFC822BUFFER *buf,char *type,long resent,
				 ADDRESS *adr,const char *specials);
long rfc822_output_address_list (RFC822BUFFER *buf,ADDRESS *adr,long pretty,
				 const char *specials);
long rfc822_output_address (RFC822BUFFER *buf,ADDRESS *adr);
long rfc822_output_cat (RFC822BUFFER *buf,char *src,const char *specials);
long rfc822_output_parameter (RFC822BUFFER *buf,PARAMETER *param);
long rfc822_output_stringlist (RFC822BUFFER *buf,STRINGLIST *stl);
long rfc822_output_body_header (RFC822BUFFER *buf,BODY *body);
void rfc822_encode_body_7bit (ENVELOPE *env,BODY *body);
void rfc822_encode_body_8bit (ENVELOPE *env,BODY *body);
long rfc822_output_text (RFC822BUFFER *buf,BODY *body);
void *rfc822_base64 (unsigned char *src,unsigned long srcl,unsigned long *len);
unsigned char *rfc822_binary (void *src,unsigned long srcl,unsigned long *len);
unsigned char *rfc822_qprint (unsigned char *src,unsigned long srcl,
			      unsigned long *len);
unsigned char *rfc822_8bit (unsigned char *src,unsigned long srcl,
			    unsigned long *len);

/* Legacy routines for compatibility with the past */

void rfc822_header (char *header,ENVELOPE *env,BODY *body);
void rfc822_header_line (char **header,char *type,ENVELOPE *env,char *text);
void rfc822_address_line (char **header,char *type,ENVELOPE *env,ADDRESS *adr);
char *rfc822_write_address_full (char *dest,ADDRESS *adr,char *base);
void rfc822_address (char *dest,ADDRESS *adr);
void rfc822_cat (char *dest,char *src,const char *specials);
void rfc822_write_body_header (char **header,BODY *body);
long rfc822_output (char *t,ENVELOPE *env,BODY *body,soutr_t f,void *s,
		    long ok8bit);
long rfc822_output_body (BODY *body,soutr_t f,void *s);


#define rfc822_write_address(dest,adr) \
  rfc822_write_address_full (dest,adr,NIL)

#define rfc822_parse_msg(en,bdy,s,i,bs,host,flags) \
  rfc822_parse_msg_full (en,bdy,s,i,bs,host,0,flags)
