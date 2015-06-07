#include <iostream>

extern "C" {
#include "parser.h"
#include "ast.h"
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

    /* testing */
    traverse_ast(current_root);
    delete_ast(current_root);

    parser_destroy();
    
    return 0;

    fail:
    parser_destroy();
    return 1;
}

