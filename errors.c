#include "errors.h"
#include "parser.tab.h"
#include <stdio.h>

void invalid_comment(int line) {
    printf("Ugnježdavanje komentara nije moguće. Greška u liniji: ",line);
}

void invalid_ident(int line, int col) {
    printf("Identifikator nije u redu. Greška u liniji: ", line, " koloni: ", col);
}

void invalid_int(int line, int col) {
    printf("Int nije u redu. Greška u liniji: ", line, " koloni: ", col);
}

void invalid_double(int line, int col) {
    printf("Double nije u redu. Greška u liniji: ", line, " koloni: ", col);
}

void invalid_string(int line, int col) {
    printf("String nije u redu. Greška u liniji: ", line, " koloni: ", col);
}