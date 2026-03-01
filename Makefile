CXX = g++
CXXFLAGS = -std=c++11 -Wall

LEX = flex
YACC = bison
YFLAGS = -d

TARGET = whereismystack
LEX_SRC = lexer.l
YACC_SRC = parser.y

# 생성될 중간 파일들
LEX_OUT = lex.yy.c
YACC_TAB_C = parser.tab.c
YACC_TAB_H = parser.tab.h

all : $(TARGET)

$(TARGET) : $(YACC_TAB_C) $(LEX_OUT) main.cpp
	$(CXX) $(CXXFLAGS) -o $@ $^

$(YACC_TAB_C) $(YACC_TAB_H) : $(YACC_SRC) node.h
	$(YACC) $(YFLAGS) $(YACC_SRC)

$(LEX_OUT) : $(LEX_SRC) $(YACC_TAB_H)
	$(LEX) $(LEX_SRC)

clean :
	rm -f $(TARGET) $(LEX_OUT) $(YACC_TAB_C) $(YACC_TAB_H)

re : clean all

	.PHONY : all clean re
