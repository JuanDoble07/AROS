#ifndef STORAGE_INTERN_H
#define STORAGE_INTERN_H

#include <aros/libcall.h>
#include <exec/libraries.h>
#include <libcore/base.h>

#include LC_LIBDEFS_FILE

struct StorageBase_intern {
    struct LibHeader    lh;
    struct List         sb_IDs;
    struct List         sb_Devices;
};

/* ID Namespace structures */

struct Storage_IDFamily
{
    struct Node                                 SIDF_Node;                      /* ln_Name = IDBase (e.g "CD") */
    struct List                                 SIDF_IDs;
};

struct Storage_IDNode
{
    struct Node                                 SIDN_Node;                      /* ln_Name = ID (e.g. "CD0") */
};


#endif
