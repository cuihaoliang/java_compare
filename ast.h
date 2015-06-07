#ifndef __AST_H__
#define __AST_H__

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    NODE_FILE,
    NODE_PACKAGE,
    NODE_IMPORT,
    NODE_CLASS,
    NODE_IDENTIFIER, /* 4 */
    NODE_CLASSHEADER,
    NODE_FIELDDECLARATIONS,
    NODE_MODIFIERS,
    NODE_EXTENDS,
    NODE_INTERFACES,
    NODE_TYPESPECIFIER,
    NODE_DIM,
    NODE_PARAMETERS,
    NODE_METHODDECLARATION,
    NODE_DECLARATORNAME,
    NODE_METHODDECLARATOR,
    NODE_VARIABLEDECLARATION,
    NODE_VARIABLEDECLARATOR
} node_type;

typedef struct _ast_node {
    node_type type;
    unsigned int body_count;

    union {
        char *identifier;
        struct _ast_node **body;
    } u;

    struct _ast_node *next;
} ast_node;

ast_node *node_create(node_type type);

extern ast_node *current_root;

void traverse_ast(ast_node *node);

void delete_ast(ast_node *node);

/* needed by parser.y */
void print_node(ast_node *node);
void delete_node(ast_node *node);

void add_to_list(ast_node *list, ast_node *node);

void add_identifier(char **loc, char *text);

#ifdef __cplusplus
}
#endif

#endif

