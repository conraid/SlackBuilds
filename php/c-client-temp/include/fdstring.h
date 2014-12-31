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
 * Program:	File descriptor string routines
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	15 April 1997
 * Last Edited:	30 August 2006
 */

/* Driver-dependent data passed to init method */

typedef struct fd_data {
  int fd;			/* file descriptor */
  unsigned long pos;		/* initial position */
  char *chunk;			/* I/O buffer chunk */
  unsigned long chunksize;	/* I/O buffer chunk length */
} FDDATA;


extern STRINGDRIVER fd_string;
