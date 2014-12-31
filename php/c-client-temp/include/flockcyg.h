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
 * Program:	flock() emulation via fcntl() locking
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	10 April 2001
 * Last Edited:	30 August 2006
 */

/* Cygwin does not seem to have the design flaw in fcntl() locking that
 * most other systems do (see flocksim.c for details).  If some cretin
 * decides to implement that design flaw, then Cygwin will have to use
 * flocksim.  Also, we don't test NFS either
 */


#define flock flocksim		/* use ours instead of theirs */

#undef LOCK_SH
#define LOCK_SH 1		/* shared lock */
#undef LOCK_EX
#define LOCK_EX 2		/* exclusive lock */
#undef LOCK_NB
#define LOCK_NB 4		/* no blocking */
#undef LOCK_UN
#define LOCK_UN 8		/* unlock */


/* Function prototypes */

int flocksim (int fd,int operation);
