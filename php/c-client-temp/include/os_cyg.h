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
 * Program:	Operating-system dependent routines -- Cygwin version
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	1 August 1988
 * Last Edited:	30 August 2006
 */

#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <dirent.h>
#include <fcntl.h>
#include <syslog.h>
#include <sys/file.h>
#include <time.h>
#include <sys/time.h>

#define direct dirent


#define CYGKLUDGEOFFSET 1	/* don't write 1st byte of shared-lock files */

/* Cygwin gets this wrong */

#define setpgrp setpgid

#define SYSTEMUID 18		/* Cygwin returns this for SYSTEM */
#define geteuid Geteuid
uid_t Geteuid (void);

/* Now Cygwin has reportedly joined this madness.  Use ifndef in case it shares
   the SVR4 <sys/file.h> silliness too */
#ifndef L_SET
#define L_SET SEEK_SET
#endif
#ifndef L_INCR
#define L_INCR SEEK_CUR
#endif
#ifndef L_XTND
#define L_XTND SEEK_END
#endif


#include "env_unix.h"
#include "fs.h"
#include "ftl.h"
#include "nl.h"
#include "tcp.h"
#include "flockcyg.h"
