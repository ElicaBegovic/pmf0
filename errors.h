#ifndef errors_h
#define errors_h

void invalid_ident(int line, int col);
void invalid_comment(int line);
void invalid_int(int line, int col);
void invalid_double(int line, int col);
void invalid_string(int line, int col); 

#endif