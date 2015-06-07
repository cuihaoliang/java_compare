#include <iostream>
#include <map>

#include <cstring>

#include "ast.h"
#include "array.h"

using namespace std;

ast_node *current_root = nullptr;

/* we need this map to delete identifiers which have been used within block
 * because we don't parse blocks
 * true indicates deleted, false not
 * needs to be stored per current_root.
 */
map<char*, bool> identifier_map;

ast_node *node_create(node_type type)
{
    ast_node *ret = nullptr;

    switch(type)
    {
        case NODE_FILE:
            ret = new ast_node;
            ret->u.body = array_create(ast_node*, 3);
            ret->body_count = 3;
            ret->type = NODE_FILE;
            ret->next = nullptr;
            break;
        case NODE_PACKAGE:
            ret = new ast_node;
            ret->u.body = array_create(ast_node*, 1);
            ret->body_count = 1;
            ret->type = NODE_PACKAGE;
            ret->next = nullptr;
            break;
        case NODE_IDENTIFIER:
            ret = new ast_node;
            ret->body_count = 0;
            ret->u.identifier = nullptr;
            ret->type = NODE_IDENTIFIER;
            ret->next = nullptr;
            break;
        case NODE_IMPORT:
            ret = new ast_node;
            ret->body_count = 2;
            ret->u.body = array_create(ast_node*, 2);
            ret->type = NODE_IMPORT;
            ret->next = nullptr;
            break;
        case NODE_CLASS:
            ret = new ast_node;
            ret->body_count = 2;
            /* body[0] == class_header
             * body[1] == variables/methods
             */
            ret->u.body = array_create(ast_node*, 2);
            ret->type = NODE_CLASS;
            ret->next = nullptr;
            break;
        case NODE_CLASSHEADER:
            ret = new ast_node;
            ret->body_count = 5;
            /* body[0] == modifiers
             * body[1] == class_word
             * body[2] == identifier
             * body[3] == extends
             * body[4] == interfaces
             */
            ret->u.body = array_create(ast_node*, 5);
            ret->type = NODE_CLASSHEADER;
            ret->next = nullptr;
            break;
        case NODE_EXTENDS:
            ret = new ast_node;
            ret->body_count = 1;
            ret->u.body = array_create(ast_node*, 1);
            ret->type = NODE_EXTENDS;
            ret->next = nullptr;
            break;
        case NODE_DIM:
            ret = new ast_node;
            ret->u.body = nullptr;
            ret->type = NODE_DIM;
            ret->next = nullptr;
            break;
        case NODE_TYPESPECIFIER:
            ret = new ast_node;
            ret->body_count = 2;
            /*
             * body[0] == types
             * body[1] == dims
             */
            ret->u.body = array_create(ast_node*, 2);
            ret->type = NODE_TYPESPECIFIER;
            ret->next = nullptr;
            break;
        case NODE_PARAMETERS:
            ret = new ast_node;
            ret->body_count = 3;
            /* body[0] == final or null
             * body[1] == type specifier
             * body[2] == declarator name
             */
            ret->u.body = array_create(ast_node*, 3);
            ret->type = NODE_PARAMETERS;
            ret->next = nullptr;
            break;
        case NODE_METHODDECLARATION:
            ret = new ast_node;
            ret->body_count = 5;
            /*
             * body[0] == modifiers
             * body[1] == type specifier
             * body[2] == method declarator
             * body[3] == throws
             * body[4] == body
             */
            ret->u.body = array_create(ast_node*, 5);
            ret->type = NODE_METHODDECLARATION;
            ret->next = nullptr;
            break;
        case NODE_DECLARATORNAME:
            ret = new ast_node;
            ret->body_count = 2;
            /*
             * body[0] == name
             * body[1] == dim or null
             */ 
            ret->u.body = array_create(ast_node*, 2);
            ret->type = NODE_DECLARATORNAME;
            ret->next = nullptr;
            break;
        case NODE_METHODDECLARATOR:
            ret = new ast_node;
            ret->body_count = 3;
            /*
             * body[0] == declarator name
             * body[1] == parameter list
             * body[2] == dim
             */
            ret->u.body = array_create(ast_node*, 3);
            ret->type = NODE_METHODDECLARATOR;
            ret->next = nullptr;
            break;
        case NODE_VARIABLEDECLARATION:
            ret = new ast_node;
            ret->body_count = 3;
            /*
             * body[0] == modifiers
             * body[1] == type specifier
             * body[2] == variable declarators
             */
            ret->u.body = array_create(ast_node*, 3);
            ret->type = NODE_VARIABLEDECLARATION;
            ret->next = nullptr;
            break;
        case NODE_VARIABLEDECLARATOR:
            ret = new ast_node;
            ret->body_count = 2;
            /* body[0] == declarator name
             * body[1] == variable initializer
             */
            ret->u.body = array_create(ast_node*, 2);
            ret->type = NODE_VARIABLEDECLARATOR;
            ret->next = nullptr;
            break;
        case NODE_FIELDDECLARATIONS:
            ret = new ast_node;
            ret->body_count = 1;
            /* body[0] = field declaration */
            ret->u.body = array_create(ast_node*, 1);
            ret->type = NODE_FIELDDECLARATIONS;
            ret->next = nullptr;
            break;
        default:
            cerr << "(node_create) unknown/unimpmenented node type: " << type << endl;
            exit(1);
            break;
    }

    return ret;
}

void add_to_list(ast_node *list, ast_node *node)
{
    ast_node *it = list;
    while(it->next != nullptr)
    {
        it = it->next;
    }
    it->next = node;
}

void print_identifier_node(ast_node *node)
{
    ast_node *it = node;
    while(it != nullptr)
    {
        cout << it->u.identifier;
        it = it->next;
        if(it != nullptr)
        {
            cout << ".";
        }
    }
}

void print_imports_node(ast_node *node)
{
    ast_node *it = node;
    while(it != nullptr)
    {
        cout << "import ";
        print_node(it->u.body[0]);
        cout << ";" << endl;
        it = it->next;
    }
}

void print_file_node(ast_node *node)
{
    for(unsigned int i = 0;i < node->body_count;i++)
    {
        if(node->u.body[i] != nullptr) print_node(node->u.body[i]);
    }
}

void print_package_node(ast_node *node)
{
    cout << "package ";
    print_node(node->u.body[0]);
    cout << ";" << endl;
}

void print_fielddeclarations_node(ast_node *node)
{
    ast_node *it = node;
    while(it != nullptr)
    {
        if(it->u.body[0] != nullptr) print_node(it->u.body[0]);
        it = it->next;
    }
}

void print_modifiers_node(ast_node *node)
{
    ast_node *it = node;
    while(it != nullptr)
    {
        cout << it->u.identifier;
        it = it->next;
        if(it != nullptr)
        {
            cout << " ";
        }
    }
}

void print_extends_node(ast_node *node)
{
    ast_node *it = node->u.body[0];
    if(it != nullptr)
    {
        cout << "extends ";
    }
    while(it != nullptr)
    {
        cout << it->u.identifier;
        it = it->next;
        if(it != nullptr)
        {
            cout << " ";
        }
    }
}

void print_interfaces_node(ast_node *node)
{
    ast_node *it = node;
    if(it != nullptr)
    {
        cout << "implements ";
    }
    while(it != nullptr)
    {
        cout << it->u.identifier;
        it = it->next;
        if(it != nullptr)
        {
            cout << " ";
        }
    }
}

void print_classheader_node(ast_node *node)
{
    if(node->u.body[0] != nullptr) print_modifiers_node(node->u.body[0]);
    cout << " ";
    print_node(node->u.body[1]);
    cout << " ";
    print_node(node->u.body[2]);
    cout << " ";
    if(node->u.body[3] != nullptr) print_node(node->u.body[3]);
    cout << " ";
    if(node->u.body[4] != nullptr) print_node(node->u.body[4]);
    cout << endl;
}

void print_dim_node(ast_node *node)
{
    ast_node *it = node;
    while(it != nullptr)
    {
        cout << "[]";
        it = it->next;
    }
}

void print_typespecifier_node(ast_node *node)
{
    print_node(node->u.body[0]);
    if(node->u.body[1] != nullptr) print_node(node->u.body[1]);
}

void print_declaratorname_node(ast_node *node)
{
    print_node(node->u.body[0]);
    if(node->u.body[1] != nullptr) print_node(node->u.body[1]);
}

void print_variabledeclaration_node(ast_node *node)
{
    if(node->u.body[0] != nullptr) print_node(node->u.body[0]);
    cout << " ";
    print_node(node->u.body[1]);
    cout << " ";
    print_node(node->u.body[2]);
    cout << ";" << endl;
}

void print_variabledeclarator_node(ast_node *node)
{
    print_node(node->u.body[0]);
    if(node->u.body[1] != nullptr) print_node(node->u.body[1]);
}

void print_parameter_node(ast_node *node)
{
    if(node->u.body[0] != nullptr) print_node(node->u.body[0]);
    print_node(node->u.body[1]);
    cout << " ";
    print_node(node->u.body[2]);
}

void print_parameterlist_node(ast_node *node)
{
    ast_node *it = node;
    cout << "(";
    while(it != nullptr)
    {
        /* cannot use print_node here */
        print_parameter_node(it);
        if(it->next != nullptr) cout << ", ";
        it = it->next;
    }
    cout << ")";
}

void print_methoddeclarator_node(ast_node *node)
{
    print_node(node->u.body[0]);
    if(node->u.body[1] != nullptr)
    {
        cout << " ";
        print_node(node->u.body[1]);
    }
    if(node->u.body[2] != nullptr)
    {
        cout << " ";
        print_node(node->u.body[2]);
    }
}

void print_throws_node(ast_node *node)
{
    ast_node *it = node;
    cout << "throws ";
    while(it != nullptr)
    {
        cout << it->u.identifier;
        if(it->next != nullptr) cout << ", ";
        it = it->next;
    }
}

void print_methoddeclaration_node(ast_node *node)
{
    if(node->u.body[0] != nullptr)
    {
        print_node(node->u.body[0]);
        cout << " ";
    }
    print_node(node->u.body[1]);
    cout << " ";
    print_node(node->u.body[2]);
    if(node->u.body[3] != nullptr)
    {
        cout << " ";
        print_node(node->u.body[3]);
    }
    cout << endl << "{/* NOT IMPLEMENTED */}" << endl;
}

void print_class_node(ast_node *node)
{
    /* class header */
    print_node(node->u.body[0]);
    cout << "{" << endl;
    /* field declarations */
    print_node(node->u.body[1]);
    cout << "}" << endl;
}

void print_node(ast_node *node)
{
    if(node)
    {
        switch(node->type)
        {
            case NODE_FILE:
                print_file_node(node);
                break;
            case NODE_PACKAGE:
                print_package_node(node);
                break;
            case NODE_IMPORT:
                print_imports_node(node);
                break;
            case NODE_CLASS:
                print_class_node(node);
                break;
            case NODE_IDENTIFIER:
                print_identifier_node(node);
                break;
            case NODE_CLASSHEADER:
                print_classheader_node(node);
                break;
            case NODE_FIELDDECLARATIONS:
                print_fielddeclarations_node(node);
                break;
            case NODE_MODIFIERS:
                print_modifiers_node(node);
                break;
            case NODE_EXTENDS:
                print_extends_node(node);
                break;
            case NODE_INTERFACES:
                print_interfaces_node(node);
                break;
            case NODE_TYPESPECIFIER:
                print_typespecifier_node(node);
                break;
            case NODE_DIM:
                print_dim_node(node);
                break;
            case NODE_PARAMETERS:
                print_parameterlist_node(node);
                break;
            case NODE_METHODDECLARATION:
                print_methoddeclaration_node(node);
                break;
            case NODE_DECLARATORNAME:
                print_declaratorname_node(node);
                break;
            case NODE_METHODDECLARATOR:
                print_methoddeclarator_node(node);
                break;
            case NODE_VARIABLEDECLARATION:
                print_variabledeclaration_node(node);
                break;
            case NODE_VARIABLEDECLARATOR:
                print_variabledeclarator_node(node);
                break;
        default:
            cerr << "(print_node) unknown/unimpmenented node type: " << node->type << endl;
            exit(1);
            break;
        }
    }
    else
    {
        cout << "(print_node) node == nullptr" << endl;
    }
}

void delete_identifier(char *id)
{
    /* free string, has been allocated with strdup */
    identifier_map[id] = true;
    free(id);
}

void delete_identifier_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        delete_identifier(it->u.identifier);
        tmp = it->next;
        delete it;
        it = tmp;
    }
}

void delete_imports_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        delete_node(it->u.body[0]);
        tmp = it->next;
        delete[] it->u.body;
        delete it;
        it = tmp;
    }
}

void delete_file_node(ast_node *node)
{
    for(unsigned int i = 0;i < node->body_count;i++)
    {
        if(node->u.body[i] != nullptr) delete_node(node->u.body[i]);
    }
    delete[] node->u.body;
    delete node;
}

void delete_package_node(ast_node *node)
{
    delete_node(node->u.body[0]);
    delete[] node->u.body;
    delete node;
}

void delete_fielddeclarations_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        if(it->u.body[0] != nullptr) delete_node(it->u.body[0]);
        tmp = it->next;
        delete[] it->u.body;
        delete it;
        it = tmp;
    }
}

void delete_modifiers_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        delete_identifier(it->u.identifier);
        tmp = it->next;
        delete it;
        it = tmp;
    }
}

void delete_extends_node(ast_node *node)
{
    ast_node *it = node->u.body[0];
    ast_node *tmp;
    while(it != nullptr)
    {
        delete_identifier(it->u.identifier);
        tmp = it->next;
        delete it;
        it = tmp;
    }
    delete[] node->u.body;
    delete node;
}

void delete_interfaces_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        delete_identifier(it->u.identifier);
        tmp = it->next;
        delete it;
        it = tmp;
    }
}

void delete_classheader_node(ast_node *node)
{
    if(node->u.body[0] != nullptr) delete_node(node->u.body[0]);
    delete_node(node->u.body[1]);
    delete_node(node->u.body[2]);
    if(node->u.body[3] != nullptr) delete_node(node->u.body[3]);
    if(node->u.body[4] != nullptr) delete_node(node->u.body[4]);
    delete[] node->u.body;
    delete node;
}

void delete_dim_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        tmp = it->next;
        delete it;
        it = tmp;
    }
}

void delete_typespecifier_node(ast_node *node)
{
    delete_node(node->u.body[0]);
    if(node->u.body[1] != nullptr) delete_node(node->u.body[1]);
    delete[] node->u.body;
    delete node;
}

void delete_declaratorname_node(ast_node *node)
{
    delete_node(node->u.body[0]);
    if(node->u.body[1] != nullptr) delete_node(node->u.body[1]);
    delete[] node->u.body;
    delete node;
}

void delete_variabledeclarators_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        delete_node(it->u.body[0]);
        if(it->u.body[1] != nullptr) delete_node(it->u.body[1]);
        tmp = it->next;
        delete[] it->u.body;
        delete it;
        it = tmp;
    }
}

void delete_variabledeclaration_node(ast_node *node)
{
    if(node->u.body[0] != nullptr) delete_node(node->u.body[0]);
    delete_node(node->u.body[1]);
    delete_node(node->u.body[2]);
    delete[] node->u.body;
    delete node;
}

void delete_variabledeclarator_node(ast_node *node)
{
    delete_node(node->u.body[0]);
    if(node->u.body[1] != nullptr) delete_node(node->u.body[1]);
    delete[] node->u.body;
    delete node;
}

void delete_parameter_node(ast_node *node)
{
    if(node->u.body[0] != nullptr) delete_node(node->u.body[0]);
    delete_node(node->u.body[1]);
    delete_node(node->u.body[2]);
    delete[] node->u.body;
    delete node;
}

void delete_parameterlist_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        tmp = it->next;
        /* cannot use delete_node here */
        delete_parameter_node(it);
        it = tmp;
    }
}

void delete_methoddeclarator_node(ast_node *node)
{
    delete_node(node->u.body[0]);
    if(node->u.body[1] != nullptr)
    {
        delete_node(node->u.body[1]);
    }
    if(node->u.body[2] != nullptr)
    {
        delete_node(node->u.body[2]);
    }
    delete[] node->u.body;
    delete node;
}

void delete_throws_node(ast_node *node)
{
    ast_node *it = node;
    ast_node *tmp;
    while(it != nullptr)
    {
        delete_identifier(it->u.identifier);
        tmp = it->next;
        delete it;
        it = tmp;
    }
}

void delete_methoddeclaration_node(ast_node *node)
{
    if(node->u.body[0] != nullptr)
    {
        delete_node(node->u.body[0]);
    }
    delete_node(node->u.body[1]);
    delete_node(node->u.body[2]);
    if(node->u.body[3] != nullptr)
    {
        delete_node(node->u.body[3]);
    }
    delete[] node->u.body;
    delete node;
}

void delete_class_node(ast_node *node)
{
    delete_node(node->u.body[0]);
    delete_node(node->u.body[1]);
    delete[] node->u.body;
    delete node;
}

void delete_node(ast_node *node)
{
    if(node)
    {
        switch(node->type)
        {
            case NODE_FILE:
                delete_file_node(node);
                break;
            case NODE_PACKAGE:
                delete_package_node(node);
                break;
            case NODE_IMPORT:
                delete_imports_node(node);
                break;
            case NODE_CLASS:
                delete_class_node(node);
                break;
            case NODE_IDENTIFIER:
                delete_identifier_node(node);
                break;
            case NODE_CLASSHEADER:
                delete_classheader_node(node);
                break;
            case NODE_FIELDDECLARATIONS:
                delete_fielddeclarations_node(node);
                break;
            case NODE_MODIFIERS:
                delete_modifiers_node(node);
                break;
            case NODE_EXTENDS:
                delete_extends_node(node);
                break;
            case NODE_INTERFACES:
                delete_interfaces_node(node);
                break;
            case NODE_TYPESPECIFIER:
                delete_typespecifier_node(node);
                break;
            case NODE_DIM:
                delete_dim_node(node);
                break;
            case NODE_PARAMETERS:
                delete_parameterlist_node(node);
                break;
            case NODE_METHODDECLARATION:
                delete_methoddeclaration_node(node);
                break;
            case NODE_DECLARATORNAME:
                delete_declaratorname_node(node);
                break;
            case NODE_METHODDECLARATOR:
                delete_methoddeclarator_node(node);
                break;
            case NODE_VARIABLEDECLARATION:
                delete_variabledeclaration_node(node);
                break;
            case NODE_VARIABLEDECLARATOR:
                delete_variabledeclarator_node(node);
                break;
        default:
            cerr << "(delete_node) unknown/unimpmenented node type: " << node->type << endl;
            exit(1);
            break;
        }
    }
    else
    {
        cout << "(delete_node) node == nullptr" << endl;
    }
}

void traverse_ast(ast_node *node)
{
    current_root = node;

    print_node(node);
}

void delete_ast(ast_node *node)
{
    current_root = node;

    delete_node(node);
}

void cleanup_asts()
{
    /* delete not already deleted identifiers */
    for(map<char*, bool>::iterator it = identifier_map.begin();it != identifier_map.end();it++)
    {
        if(!it->second)
        {
            /* identifiers have been allocated with strdup */
            free(it->first);
            it->second = true;
        }
    }

}

void add_identifier(char **loc, char *text)
{
    *loc = strdup(text);
    identifier_map[*loc] = false;
}

