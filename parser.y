%{
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>
#include "node.h"
#include "common.h"
#include <fstream>

using namespace std;

vector<Instruction> bytecode;

void yyerror(const char *s);
extern int yylex();
int yyparse();


void generate(struct Node* n);
void save_to_file(const char* filename);
struct Node* create_val_node(int v);
struct Node* create_op(int op);
struct Node* append_node(struct Node* list, struct Node* new_node);

%}

%union {
    struct Node* node;
    int val;
}

%token <val> TOK_NUMBER
%token TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_EQUAL TOK_QUESTION TOK_REVERSE TOK_CARET TOK_HALT TOK_ERROR
%type <node> program commands command

%%

program:
    commands { generate($1);
    save_to_file("program.bin");
    }

commands:
      /* empty */        { $$ = NULL; }
    | commands command  { $$ = append_node($1, $2); }
    ;

command:
      TOK_NUMBER    { $$ = create_val_node($1); }
    | TOK_ADD      { $$ = create_op('+'); }
    | TOK_SUB     { $$ = create_op('-'); }
    | TOK_MUL      { $$ = create_op('*'); }
    | TOK_DIV       { $$ = create_op('/'); }
    | TOK_EQUAL     { $$ = create_op('='); }
    | TOK_CARET     { $$ = create_op('^'); }
    | TOK_QUESTION  { $$ = create_op('?'); }
    | TOK_REVERSE   { $$ = create_op('r'); }
    ;

%%

struct Node* create_val_node(int v){
    struct Node* n = (struct Node*)malloc(sizeof(struct Node));
    n->type = NODE_VAL;
    n->val = v;
    n->next = NULL;
    return n;
}

struct Node* create_op(int op){
    struct Node* n = (struct Node*)malloc(sizeof(struct Node));
    n->type = NODE_OP;
    n->op = op;
    n->next = NULL;
    return n;
}

struct Node* append_node(struct Node* list, struct Node* new_node){
    if(!list) return new_node;
    struct Node* t = list;
    while(t->next) t = t->next;
    t->next = new_node;
    return list;
}

struct Node* prev_node = NULL;

void generate(struct Node* n) {
    while(n) {
    	if(n->type == NODE_VAL){
		bytecode.push_back(Instruction{OP_NUMBER, n->val});
	}

	else{

            switch(n->op) {
                case '+': 
                    bytecode.push_back(Instruction{OP_ADD, 0}); 
                    break;
                case '-': 
                    bytecode.push_back(Instruction{OP_SUB, 0}); 
                    break;
                case '*': 
                    bytecode.push_back(Instruction{OP_MUL, 0});
                    break;
		case '/':
		    bytecode.push_back(Instruction{OP_DIV, 0});
                case '^': {
		if(prev_node && prev_node->type == NODE_OP && prev_node -> op == '='){
			bytecode.push_back(Instruction{OP_CARET, 0});
			break;
		}
		else{
			bytecode.push_back(Instruction{OP_CARET, 1});
			break;
		}
		}
		case '=':
		    bytecode.push_back(Instruction{OP_EQUAL, 0});
		    break;
		case '?': {
			bytecode.push_back(Instruction({OP_QUESTION, 0}));
			break;
		}
		case 'r':
		    bytecode.push_back(Instruction{OP_REVERSE, 0});
		    break;

		default:
                    fprintf(stderr, "Unknown operator: %c\n", n->op);

            }
	}
	
	prev_node = n;
        n = n->next;
        
	}
	
	bytecode.push_back(Instruction{OP_HALT,0});
    }


void save_to_file(const char* filename){
	ofstream outFile(filename, ios::binary);
	if(outFile){
		size_t count = bytecode.size();
		outFile.write((char*)&count, sizeof(count));
		outFile.write((char*)bytecode.data(), count * sizeof(Instruction));
		outFile.close();
	}
}

void yyerror(const char *s){
    fprintf(stderr,"Parse error: %s\n", s);
}

