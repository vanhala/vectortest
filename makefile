

vectortest: main.o vectortest.o vectortest_asm.o vectortest_asm_2.o vectortest_asm_3.o vectortest.S
	g++ vectortest.o vectortest_asm.o vectortest_asm_2.o vectortest_asm_3.o main.o -o vectortest

main.o: main.cpp
	g++ main.cpp -c -o main.o

vectortest.o: vectortest.cpp
	g++ -O3 -march=native vectortest.cpp -c -o vectortest.o

vectortest.S: vectortest.cpp
	g++ -O3 -march=native vectortest.cpp -c -S -o vectortest.S

vectortest_asm.o: vectortest_asm.s
	nasm  vectortest_asm.s -felf64 -o vectortest_asm.o

vectortest_asm_2.o: vectortest_asm_2.s
	nasm  vectortest_asm_2.s -felf64 -o vectortest_asm_2.o

vectortest_asm_3.o: vectortest_asm_3.s
	nasm  vectortest_asm_3.s -felf64 -o vectortest_asm_3.o

clear:
	rm *.o
	rm vectortest.S
