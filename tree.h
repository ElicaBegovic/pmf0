#ifndef TREE_H
#define TREE_H

typedef struct TreeNode {
    char* token;
    struct TreeNode** children;
    int child_count;
} TreeNode;

TreeNode* create_node(const char* token);
void add_child(TreeNode* parent, TreeNode* child);
void print_tree(TreeNode* node, int level);

#endif /* TREE_H */
