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
 * Program:	Dummy routines
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	9 May 1991
 * Last Edited:	30 August 2006
 */

/* Exported function prototypes */

void dummy_scan (MAILSTREAM *stream,char *ref,char *pat,char *contents);
void dummy_list (MAILSTREAM *stream,char *ref,char *pat);
void dummy_lsub (MAILSTREAM *stream,char *ref,char *pat);
long scan_contents (DRIVER *dtb,char *name,char *contents,
		    unsigned long csiz,unsigned long fsiz);
long dummy_scan_contents (char *name,char *contents,unsigned long csiz,
			  unsigned long fsiz);
long dummy_create (MAILSTREAM *stream,char *mailbox);
long dummy_create_path (MAILSTREAM *stream,char *path,long dirmode);
long dummy_delete (MAILSTREAM *stream,char *mailbox);
long dummy_rename (MAILSTREAM *stream,char *old,char *newname);
char *dummy_file (char *dst,char *name);
long dummy_canonicalize (char *tmp,char *ref,char *pat);
