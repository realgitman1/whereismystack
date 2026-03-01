#ifndef NODE_H
#define NODE_H

#define NODE_VAL 1
#define NODE_OP  2

struct Node {
    int type;
    long long val;
    int op;
    struct Node* next;
};

struct Node* create_val_node(long long v);
struct Node* create_op(int op);
struct Node* append_node(struct Node* list, struct Node* new_node);
void execute(struct Node* node);

#endif

