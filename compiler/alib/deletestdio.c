/*
    (C) 1995-96 AROS - The Amiga Replacement OS
    $Id$

    Desc: amiga.lib function DeleteStdIo()
    Lang: english
*/
#include <exec/memory.h>

/*****************************************************************************

    NAME */
#include <exec/io.h>
#include <clib/alib_protos.h>
#include <clib/exec_protos.h>

	void DeleteStdIO (

/*  SYNOPSIS */
	struct IOStdReq * io)

/*  FUNCTION
	Delete a structure which was created by CreateStdIO().

    INPUTS
	io - The value returned by CreateStdIO(). Must be
	    non-NULL.

    RESULT
	None.

    NOTES

    EXAMPLE

    BUGS

    SEE ALSO
	CreateStdIO()

    INTERNALS

    HISTORY

******************************************************************************/
{
#   define ioreq    ((struct IORequest *)io)

    /* Write illegal values to some fields to enforce crashes */
    ioreq->io_Message.mn_Node.ln_Type = -1L;

    ioreq->io_Device = (struct Device *)-1L;
    ioreq->io_Unit   = (struct Unit *)-1L;

    FreeMem (ioreq, ioreq->io_Message.mn_Length);
} /* DeleteStdIO */

