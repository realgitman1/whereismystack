#ifndef COMMON_H
#define COMMON_H

#include <vector>
#include <fstream>
#include <iostream>

#pragma pack(push, n)
typedef enum {
    OP_NUMBER,
    OP_ADD,
    OP_SUB,
    OP_MUL,
    OP_DIV,
    OP_EQUAL,
    OP_QUESTION,
    OP_REVERSE,
    OP_CARET,
    OP_HALT
} Opcode;
#pragma pack(pop)

struct Instruction{
	
	Opcode op;
	int value;
};

#endif

