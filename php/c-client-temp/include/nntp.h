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
 * Program:	Network News Transfer Protocol (NNTP) routines
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	10 February 1992
 * Last Edited:	30 August 2006
 */

/* Constants (should be in nntp.c) */

#define NNTPTCPPORT (long) 119	/* assigned TCP contact port */


/* NNTP open options
 * For compatibility with the past, NOP_DEBUG must always be 1.
 */

#define NOP_DEBUG (long) 0x1	/* debug protocol negotiations */
#define NOP_READONLY (long) 0x2	/* read-only open */
#define NOP_TRYSSL (long) 0x4	/* try SSL first */
				/* reserved for application use */
#define NOP_RESERVED (unsigned long) 0xff000000


/* Compatibility support names */

#define nntp_open(hostlist,options) \
  nntp_open_full (NIL,hostlist,"nntp",NIL,options)


/* Function prototypes */

SENDSTREAM *nntp_open_full (NETDRIVER *dv,char **hostlist,char *service,
			    unsigned long port,long options);
SENDSTREAM *nntp_close (SENDSTREAM *stream);
long nntp_mail (SENDSTREAM *stream,ENVELOPE *msg,BODY *body);
