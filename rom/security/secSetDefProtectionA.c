/*
    Copyright (C) 2002-2019, The AROS Development Team. All rights reserved.
*/

#include <aros/debug.h>
#include <stdio.h>

#include "security_intern.h"

/*****************************************************************************

    NAME */
        AROS_LH1(BOOL, secSetDefProtectionA,

/*  SYNOPSIS */
        /* (taglist) */
        AROS_LHA(struct TagItem *, taglist, A0),

/*  LOCATION */
        struct SecurityBase *, secBase, 13, Security)

/*  FUNCTION

    INPUTS


    RESULT


    NOTES


    EXAMPLE

    BUGS

    SEE ALSO


    INTERNALS

    HISTORY

*****************************************************************************/
{
    AROS_LIBFUNC_INIT

    D(bug( DEBUG_NAME_STR " %s()\n", __func__);)

    return 0;

    AROS_LIBFUNC_EXIT

} /* secSetDefProtectionA */

