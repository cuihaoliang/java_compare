#include <iostream>
#include <list>
#include <string>

#include <cstdlib>

#include <boost/filesystem.hpp>

extern "C" {

#include "parser.h"
#include "ast.h"

extern FILE *yyin;
extern void yyrestart(FILE *f);
}

using namespace std;

using namespace boost::filesystem;

void usage(char *name)
{
    cout << "usage:" << endl;
    cout << name << " dir1 dir2" << endl;
    cout << "\tdir1, dir2\tdirectories with decompiled java code to compare, must exist" << endl;
}

list<string> find_files(char *directory)
{
    list<string> files;
    recursive_directory_iterator it(directory), end;

    while(it != end)
    {
        if(!is_directory(it->path()))
        {
            files.push_back(it->path().string());
        }
        it++;
    }

    return files;
}

pair<string, ast_node*> create_ast(string filename)
{
    int parser_result;

    yyin = fopen(filename.c_str(), "r");
    yyrestart(yyin);

    parser_create();

    parser_result = yyparse();

    if(parser_result != 0)
    {
        cerr << "parser failed!" << endl;
        fclose(yyin);
        delete_ast(current_root); /* save? */
        parser_destroy();
        return make_pair(filename, nullptr);
    }

    fclose(yyin);

    parser_destroy();

    return make_pair(filename, current_root);
}
int main(int argc, char *argv[])
{
    char *dir_one, *dir_two;
    list<string> dir1_files, dir2_files;
    list<pair<string, ast_node*>> dir1_trees, dir2_trees;
    bool failed = false;

    if(argc != 3)
    {
        usage(argv[0]);
        return -1;
    }

    dir_one = argv[1];
    dir_two = argv[2];

    if((!exists(dir_one) || !is_directory(dir_one)) || (!exists(dir_two) || !is_directory(dir_two)))
    {
        usage(argv[0]);
        return -2;
    }

    dir1_files = find_files(dir_one);
    dir2_files = find_files(dir_two);

    if(atexit(parser_destroy) != 0)
    {
        cerr << "could not register exit hook parser_destroy" << endl;
        parser_destroy();
        return -1;
    }

    for(list<string>::iterator it = dir1_files.begin();it != dir1_files.end();it++)
    {
        pair<string, ast_node*> tree;
        tree = create_ast(*it);
        if(tree.second != nullptr)
        {
            dir1_trees.push_back(tree);
        }
        else
        {
            cerr << "failed to parse: " << *it << endl;
        }
    }

    for(list<string>::iterator it = dir2_files.begin();it != dir2_files.end();it++)
    {
        pair<string, ast_node*> tree;
        tree = create_ast(*it);
        if(tree.second != nullptr)
        {
            dir2_trees.push_back(tree);
        }
        else
        {
            cerr << "failed to parse: " << *it << endl;
        }
    }

    for(list<pair<string, ast_node*>>::iterator it = dir1_trees.begin();it != dir1_trees.end();it++)
    {
        delete_ast(it->second);
    }

    for(list<pair<string, ast_node*>>::iterator it = dir2_trees.begin();it != dir2_trees.end();it++)
    {
        delete_ast(it->second);
    }
    
    if(failed) return -2;
    return 0;
}

