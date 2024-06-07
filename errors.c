#include "errors.h"
#include "parser.tab.h"
#include <stdio.h>

void invalid_comment(int line) {
    printf("Ugnježdavanje komentara nije moguće. Greška u liniji: ",line);
}

void invalid_ident(int line, int col) {
    printf("Identifikator je predugačak. Greška u liniji: ", line, " koloni: ", col);
}