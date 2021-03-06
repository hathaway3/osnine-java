/*
 * Program to read or change the name of an OS-9 disk.
 */
#include <stdio.h>
#include <direct.h>

/*
 * An os9 string is terminated with highorder bit set
 * This helpful function copies it into a C-convention string.
 */
static char *
strcpyh(s1, s2)
    char *s1;
    char *s2;
{
    char *p = s1;
    while(*s2 > 0)
        *p++ = *s2++;
    *p++ = *s2 & 127;
    *p = '\0';
    return s1;
}

/*
 * Copy a C-string to an OS-9 string with highorder bit set.
 */
static int strcpyc(s1, s2, n)
    char *s1;
    char *s2;
    int n;
{
    while(n && *s2) {
        *s1++ = *s2++;
        n--;
    }
    s1--;
    *s1 |= 128;
    return;
}

main(argc,argv)
    int argc;
    char *argv[];
{
    FILE *dfp;
    long totsect;
    int e;
    char buffer[40];
    struct ddsect idsector;

    pflinit();
    if (argc > 3) {
        fprintf(stderr, "Usage: %s {disk} [new label]\n", argv[0]);
        exit(0);
    }

    if (argc == 1) {
        strcpy(buffer, defdrive());
    } else {
        strncpy(buffer, argv[1], 8);
    }
    strcat(buffer, "@");

    dfp = fopen(buffer, (argc == 3)?"r+":"r");
    if (dfp == NULL) {
        fprintf(stderr, "Unable to open: %s\n", argv[1]);
        exit(0xd6);
    }
    fread(&idsector, sizeof(idsector), 1, dfp);

    l3tol(&totsect, idsector.dd_tot, 1);
    totsect >>= 2;

    if (argc == 3) {
        if (strlen(argv[2]) > 32) {
            fprintf(stderr, "Label maximum length: 32\n");
            exit(3);
        }
        strcpyc(idsector.dd_name, argv[2], 32);
        e = rewind(dfp);
        if (e == -1) {
            fprintf(stderr, "Unable to rewind\n");
            exit(1);
        }
        fwrite(&idsector, sizeof(idsector), 1, dfp);
    }
    strcpyh(buffer, idsector.dd_name);
    fclose(dfp);
    printf("Label: %s\n", buffer);
    printf("Capacity: %ld KB\n", totsect);
    printf("ID: %X\n", idsector.dd_dsk);
}
