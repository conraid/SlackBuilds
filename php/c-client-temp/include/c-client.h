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
 * Program:	c-client master include for application programs
 *
 * Author:	Mark Crispin
 *		Networks and Distributed Computing
 *		Computing & Communications
 *		University of Washington
 *		Administration Building, AG-44
 *		Seattle, WA  98195
 *		Internet: MRC@CAC.Washington.EDU
 *
 * Date:	19 May 2000
 * Last Edited:	6 December 2006
 */

#ifndef __CCLIENT_H		/* nobody should include this twice... */
#define __CCLIENT_H

#ifdef __cplusplus		/* help out people who use C++ compilers */
extern "C" {
  /* If you use gcc, you may also have to use -fno-operator-names */
#define private cclientPrivate	/* private to c-client */
#define and cclientAnd		/* C99 doesn't realize that ISO 646 is dead */
#define or cclientOr
#define not cclientNot
#endif

#include "mail.h"		/* primary interfaces */
#include "osdep.h"		/* OS-dependent routines */
#include "rfc822.h"		/* RFC822 and MIME routines */
#include "smtp.h"		/* SMTP sending routines */
#include "nntp.h"		/* NNTP sending routines */
#include "utf8.h"		/* Unicode and charset routines */
#include "utf8aux.h"		/* Unicode auxillary routines */
#include "misc.h"		/* miscellaneous utility routines */

#ifdef __cplusplus		/* undo the C++ mischief */
#undef private
}
#endif

#endif
