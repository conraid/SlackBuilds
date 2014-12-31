/* ========================================================================
 * Copyright 1988-2007 University of Washington
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
 * Program:	UTF-8 auxillary routines (c-client and MIME2 support)
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
 * Last Edited:	9 October 2007
 */


/* Following routines are in utf8aux.c as these depend upon c-client.
 * Splitting these routines out makes it possible for pico to link with utf8.o
 * and a few rump routines (e.g., fs_get()) but not all the rest of c-client
 * (which pico does not need).
 */

void utf8_searchpgm (SEARCHPGM *pgm,char *charset);
long utf8_mime2text (SIZEDTEXT *src,SIZEDTEXT *dst,long flags);
unsigned char *mime2_token (unsigned char *s,unsigned char *se,
			    unsigned char **t);
unsigned char *mime2_text (unsigned char *s,unsigned char *se);
long mime2_decode (unsigned char *e,unsigned char *t,unsigned char *te,
		   SIZEDTEXT *txt);
unsigned char *utf8_to_mutf7 (unsigned char *src);
unsigned char *utf8_from_mutf7 (unsigned char *src);
