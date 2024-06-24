#include "tree.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct TreeNode* create_node(const char* token) {
    TreeNode* node = (TreeNode*)malloc(sizeof(TreeNode));
    node->token = strdup(token);
    node->children = NULL;
    node->child_count = 0;
    return node;
}

void add_child(struct TreeNode* parent, struct TreeNode* child) {
    parent->child_count++;
    parent->children = (TreeNode**)realloc(parent->children, parent->child_count * sizeof(TreeNode*));
    parent->children[parent->child_count - 1] = child;
}

void print_tree(struct TreeNode* node, int level) {
    int i;
    for (i = 0; i < level; i++) printf("  ");
    printf("%s\n", node->token);
    for (i = 0; i < node->child_count; i++) {
        print_tree(node->children[i], level + 1);
    }
}
