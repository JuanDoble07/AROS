BEGIN {
    stderr="/dev/stderr";

    file = "libdefs.h";

    while ((getline < file) > 0)
    {
        if ($2 == "BASENAME")
        {
            lib = $3;
            basename = $3;
        }
        else if ($2 == "LIBBASE")
        {
            libbase = $3;
        }
        else if ($2 == "LIBBASETYPEPTR")
        {
            libbtp = $3;
            for (t=4; t<=NF; t++)
                libbtp=libbtp" "$t;
        }
        else if ($2 == "NT_TYPE")
        {
            if( $3 == "NT_RESOURCE" )
            {
                firstlvo = 0;
                libext = ".resource";
            }
            else if( $3 == "NT_DEVICE" )
            {
                firstlvo = 6;
                libext = ".device";
            }
            else
            {
                firstlvo = 4;
                libext = ".library";
            }
        }
        else if ($2 == "INCLUDE_PREFIX")
        {
            incname = $3;
        }
    }

    verbose_pattern = libbase"[ \\t]*,[ \\t]*[0-9]+[ \\t]*,[ \\t]*"basename;

    close (file);

    BASENAME=toupper(basename);
    INCNAME=toupper(incname);

    print "#ifndef _INLINE_"INCNAME"_H"
    print "#define _INLINE_"INCNAME"_H"
    print ""
    print "/*"
    print "    Copyright (C) 1995-1998 AROS - The Amiga Research OS"
    print "    $""Id$"
    print ""
    print "    Desc: Inlines for "basename libext
    print "    Lang: english"
    print "*/"
    print ""
    print "#ifndef __INLINE_MACROS_H"
    print "#   include <inline/macros.h>"
    print "#endif"
    print ""
    print "#ifndef "BASENAME"_BASE_NAME"
    print "#define "BASENAME"_BASE_NAME " libbase
    print "#endif"
    print ""

    file = "headers.tmpl"
    doprint = 0;
    emit = 0;

    while ((getline < file) > 0)
    {
        if ($1=="##begin" && $2 == "clib")
            doprint = 1;
        else if ($1=="##end" && $2 == "clib")
            doprint = 0;
        else if (doprint)
        {
            print;
            emit ++;
        }
    }

    if (emit > 0)
        print ""

    print "/* Prototypes */"
}

/AROS_LH(A|(QUAD)?[0-9])/ {
    line  = $0;
    isarg = match(line,/AROS_LHA/);
    gsub(/^[ \t]+/,"",line);

    if (!isarg)
    {
        args = "";
        narg = 0;

        # extract macro name
        sub(/^AROS_LH/,"LP", line);
        match(line,/^[a-zA-Z_0-9]*/);
        macro = substr(line, RSTART, RLENGTH);

        # extract return type and function name
        sub(/^LP[0-9]\(/,"",line);
        split(line, a, ",");
        rtype = a[1];
        gsub(/[ \t]+/, "", rtype);

        fname = a[2]
        gsub(/[ \t]+/, "", fname);

        if(rtype ~ /void|VOID/) macro = macro "NR";
        # print "macro: " macro;
        # print "rtype: " rtype;
        # print "fname: " fname;

    }
    else
    {
        gsub(/AROS_LHA\(/, "", line);
        gsub(/\),/, "", line);
        split(line, a,",");
        for(i = 1; i <= 3; i++)
        {
            gsub(/^[ \t]*|[ \t]*$/, "", a[i]);
            if(i % 3 == 0)
            {
                gsub(/A/, "a", a[i]);
                gsub(/D/, "d", a[i]);
            }
            arg[narg++] = a[i];
        }
    }
}
/LIBBASE[ \t]*,[ \t]*[0-9]+/ || $0 ~ verbose_pattern {
    line=$0;
    gsub(/LIBBASETYPEPTR/,libbtp,line);
    gsub(/LIBBASE/,libbase,line);
    gsub(/BASENAME/,basename,line);
    gsub(/[ \t]*[)][ \t]*$/,"",line);
    gsub(/^[ \t]+/,"",line);
    na  = split(line,a,",");
    lvo = int(a[3]);


    # print "#define AddFont(textFont) \"
    printf "#define " fname "("
    args = ""
    if(narg > 0)
    {
        for (t = 1; t < narg - 3; t = t + 3)
        {
            printf("%s, ", arg[t]);
        }
        printf("%s) \\\n", arg[t]);
    }
    else
    {
        print ") \\";
    }

    # print "LP1NR(0x1e0, AddFont, struct TextFont *, textFont, a1, \"
    if(macro ~ /NR$/)
    {
        printf("        %s(0x%x, %s, ", macro, lvo * 6, fname);
    }
    else
    {
        printf("        %s(0x%x, %s, %s, ", macro, lvo * 6, rtype, fname);
    }

    if(narg > 0)
    {
        for (t = 0; t < narg - 1; t++)
        {
            printf("%s, ", arg[t]);
        }
        printf("%s, \\\n", arg[t]);
    }
    else
    {
       print " \\";
    }

    # print "GRAPHICS_BASE_NAME)"
    print "        , " BASENAME "_BASE_NAME)";
    print "";

    # print inline stdarg
    if(arg[narg - 3] ~ /struct[ \t]+TagItem[ \t]*\*/)
    {
        tagsName = fname;
        if(tagsName ~ /TagList$|A$/)
        {
            sub(/TagList$/, "Tags", tagsName);
            sub(/A$/, "", tagsName);
        }
        else
        {
            tagsName = tagsName "Tags"
        }

        print "#ifndef NO_INLINE_STDARG";
        printf "#define " tagsName "(";

        if(narg > 3)
        {
            for (t = 2; t < narg - 3; t = t + 3)
            {
                printf("%s, ", arg[t]);
            }
        }

        printf "tags...) \\\n";
        printf ("        ({ULONG _tags[] = { tags }; %s(", fname);
        if(narg > 3)
        {
            for (t = 2; t < narg - 3; t = t + 3)
            {
                printf("(%s), ", arg[t]);
            }
        }
        print "(struct TagItem *)_tags);})";
        print "#endif /* !NO_INLINE_STDARG */";
        print "";
    }

    narg = 0;
}
END {
    print "#endif /* _INLINE_"INCNAME"_H */"
}
