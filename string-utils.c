#include <stdio.h>
#include <string.h>
#include <ctype.h>

#include "string-utils.h"

void trim(char *s) {
    int i, j;
    for( i = strlen(s)-1; i >= 0 && isspace( s[i] ); i-- );
    s[i+1] = '\0';
    for( i = 0; isspace( s[i] ); i++ ) ;
    if( i > 0 ) {
        j = 0;
        while( s[i] ) s[j++] = s[i++];
        s[j] = '\0';
    }
}

char pop_back(char *str) {
    const int len = strlen(str);
    if ( len == 0 ) {
        return '\0';
    } else {
        char c = str[len-1];
        str[len-1] = '\0';
        return c;
    }
}
