antlr4 := java -Xmx500M -cp ".:/usr/local/lib/antlr-4.5.3-complete.jar" org.antlr.v4.Tool
genfile := javac -cp ".:/usr/local/lib/antlr-4.5.3-complete.jar"
grun := java -cp ".:/usr/local/lib/antlr-4.5.3-complete.jar" org.antlr.v4.gui.TestRig

all: echo2 hello

echo2: echo2.o
	gcc echo2.o -o echo2

echo2.o: echo2.asm
	nasm -f macho64 echo2.asm

echo2.asm: BFAssembly*.class
	$(grun) BFAssembly program echo2.bf > echo2.asm

hello: hello.o
	gcc hello.o -o hello

hello.o: hello.asm
	nasm -f macho64 hello.asm

hello.asm: BFAssembly*.class
	$(grun) BFAssembly program hello.bf > hello.asm

BFAssembly*.class: BFAssembly*.java
	$(genfile) BFAssembly*.java

BFAssembly*.java: BFAssembly.g4
	$(antlr4) BFAssembly.g4

clean:
	rm *.java *.o *.asm *.class *.tokens hello echo2
