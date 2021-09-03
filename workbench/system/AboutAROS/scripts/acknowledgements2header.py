#!/usr/bin/env python3
# -*- coding: iso-8859-15 -*-

import sys

outfile = open(sys.argv[2], "w", encoding="iso-8859-15")

outfile.write('''#ifndef _ACKNOWLEDGEMENTS_H_
#define _ACKNOWLEDGEMENTS_H_

/*
    Copyright � 2003, The AROS Development Team. All rights reserved.
    ****** This file is automatically generated. DO NOT EDIT! *******
*/

const char * const ACKNOWLEDGEMENTS[] =
{
''')

count = 0
file = open(sys.argv[1], "r", encoding="iso-8859-15")
for line in file:
    outfile.write('    "%s",\n' % line.strip())
    count += 1

outfile.write('''};

#define ACKNOWLEDGEMENTS_SIZE (%d)

#endif /* _ACKNOWLEDGEMENTS_H_ */
''' % count)

file.close()
outfile.close()
