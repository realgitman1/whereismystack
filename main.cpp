#include <iostream>
#include <vector>
#include "parser.tab.h"
#include "common.h"

using namespace std;
extern std::vector<Instruction> bytecode;
extern int yyparse();

void run_vm() {

    vector<int> numstack(30000,0);
    
    numstack[0] = 1;
    numstack[1] = 1;
    
    vector<int> outputstack(30000,0);

    int numpointer = 1;
    int outputpointer = 0;
    int pc = 0;
    Instruction &prevbyte = bytecode[0];
    
    while (pc < bytecode.size()) {
	
        
	Instruction &inst = bytecode[pc];

	switch(inst.op){
		case 0 : {
			numstack[numpointer+1] = inst.value;
			numpointer++;
			break;
			}

                case 1: {
                    if(numpointer < 1) { fprintf(stderr,"Underflow\n"); exit(1); }
                    unsigned long long a = numstack[numpointer-1];
                    unsigned long long b = numstack[numpointer];
                    numstack[numpointer+1] = a + b;
		    numpointer++;
                    break;
                }

                case 2: {
                    if(numpointer < 1) { fprintf(stderr,"Underflow\n"); exit(1); }
                    unsigned long long a = numstack[numpointer-1];
                    unsigned long long b = numstack[numpointer];
                    numstack[numpointer+1] = (a >= b ? a-b : b-a);
		    numpointer++;
                    break;
                }

                case 3: {
                    if(numpointer < 1) { fprintf(stderr,"Underflow\n"); exit(1); }
                    unsigned long long a = numstack[numpointer-1];
                    unsigned long long b = numstack[numpointer];
                    numstack[numpointer+1] = a * b;
		    numpointer++;
                    break;
                }

                case 4: {
                    if(numpointer < 1) { fprintf(stderr,"Underflow\n"); exit(1); }
                    unsigned long long a = numstack[numpointer-1];
                    unsigned long long b = numstack[numpointer];
                    if(b == 0){ fprintf(stderr,"Div by zero\n"); exit(1); }
                    numstack[numpointer+1] = a / b;
		    numpointer++;
                    break;
                }

       
		case 5: {
		if(numpointer < 1) { fprintf(stderr,"Underflow\n"); exit(1); }

    		string a = to_string(numstack[numpointer-1]);
    		string b = to_string(numstack[numpointer]);
    
   		try {
        		long long combined = stoll(a + b);
        		int r = static_cast<int>(combined % 128);
        		if (r < 0) r += 128; 
        		numstack[numpointer] = r;
		    	numpointer++;
		        outputstack[outputpointer] = (unsigned char)r;
			outputpointer++;
  		} catch (const std::exception& e) {
        		fprintf(stderr, "Concatenation error: %s\n", e.what());
       			exit(1);
    			}
		break;
		}


		case 6 : {
    			if(numpointer < 1) { fprintf(stderr, "Underflow\n"); exit(1); }
			int M = numstack[numpointer-1];
			numstack.erase(numstack.begin() + numpointer-1);
			
			int N = numstack[numpointer-1];
			numstack.erase(numstack.begin() + numpointer-1);

			numpointer -= 2;

    			if((!(M < N)) && (N-M>2)) {
        			printf("Error! M should be less than N\n");
        			exit(1);
    			}

			int sum = 0;

    			for(int i = M; i < N; i++) {
        			sum += numstack[i];
    			}
    			
    			numstack[numpointer+1] = sum;
		    	numpointer++;
//				cout << sum << endl;
    			break;
		}
                case 7: {
                    if(numpointer < 1) break;
                    int t = numstack[numpointer];
                    numstack[numpointer] = numstack[numpointer-1];
                    numstack[numpointer-1] = t;
                    break;
                }

		case 8: {
                	if(inst.value == 0){
		//			cout << "hello 8" << endl;
				for(char charc : outputstack){
                        		cout << charc << endl;
					break;
				}

			} else{
			
                	        for(unsigned int i=0;i<numpointer+1;i++)
                        	printf("%llu ", numstack[i]);
                        	printf("\n");
	            		break;
			}
		}

		case 9: {
			printf("hello");
			return;
		}

        }

	Instruction &prevbyte = bytecode[numpointer];
	pc++;
    }
}


int main(int argc, char** argv) {
    
    std::cout << "Compiling..." << std::endl;
    if (yyparse() != 0) {
        std::cerr << "Compilation failed!" << std::endl;
        return 1;
    }

    std::cout << "Running VM..." << std::endl;
    run_vm(); 

    return 0;
}
