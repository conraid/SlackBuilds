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
 * Program:	Environment routines
 *
 * Author:	Mark Crispin
 *		UW Technology
 *		University of Washington
 *		Seattle, WA  98195
 *		Internet: MRC@Washington.EDU
 *
 * Date:	1 August 1988
 * Last Edited:	13 February 2008
 */

/* Function prototypes */

long pmatch_full (unsigned char *s,unsigned char *pat,unsigned char delim);
long dmatch (unsigned char *s,unsigned char *pat,unsigned char delim);
void *env_parameters (long function,void *value);
void rfc822_date (char *date);
void rfc822_timezone (char *s,void *t);
void internal_date (char *date);
long server_input_wait (long seconds);
void server_init (char *server,char *service,char *sasl,
		  void *clkint,void *kodint,void *hupint,void *trmint,
		  void *staint);
long server_login (char *user,char *pass,char *authuser,int argc,char *argv[]);
long authserver_login (char *user,char *authuser,int argc,char *argv[]);
long anonymous_login (int argc,char *argv[]);
char *mylocalhost (void);
char *myhomedir (void);
char *mailboxfile (char *dst,char *name);
MAILSTREAM *default_proto (long type);
