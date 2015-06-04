#include <iostream>

extern "C" {
#include "parser.h"

extern void parser_create();    // TODO: move this to parser.h?
extern void parser_destroy();   // TODO: -"-
int yyparse(void);              // TODO: -"-
}

using namespace std;

int main(int argc, char *argv[])
{
    int parser_result;

    parser_create();

    if(atexit(parser_destroy) != 0)
    {
        cerr << "could not register exit hook parser_destroy" << endl;
        goto fail;
    }

    parser_result = yyparse();

    /* TODO */
    if(parser_result == 0)
    {
        cout << "parser succeeded!" << endl;
    }
    else
    {
        cout << "parser failed!" << endl;
        goto fail;
    }

    parser_destroy();
    
    return 0;

    fail:
    parser_destroy();
    return 1;
}

