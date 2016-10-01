grammar BFAssembly;

@header {
	import java.util.Stack;
}

@members {
	Stack<Integer> loops = new Stack<>();
	int counter = 0;
}

program :
	{
		System.out.println("%define SYSCALL_READ 0x2000003");
		System.out.println("%define SYSCALL_WRITE 0x2000004");
		System.out.println("%define SYSCALL_EXIT  0x2000001");
		System.out.println("global _main");
		System.out.println("global _start");
		System.out.println("_main:");
		System.out.println("_start:");
		System.out.println("  mov rbx, array");
	}
		general*
	{
		System.out.println("  mov rax, SYSCALL_EXIT");
		System.out.println("  mov rdi, 0");
		System.out.println("  syscall");
		System.out.println();
		System.out.println("section .data");
		System.out.println("  array: times 32767 db 0");
	}
		;

general :
					whilestmt
					| expression
          ;
whilestmt : WHILE
						{
							loops.push(counter);
							counter++;
							System.out.println("while_" + loops.peek() + ":");
              System.out.println("  mov cl, [rbx]");
							System.out.println("  cmp cl, 0");
							System.out.println("  je endwhile_" + loops.peek());
						}
						(expression*)
					  ENDWHILE
						{
							System.out.println("  jmp while_" + loops.peek());
							System.out.println("endwhile_" + loops.pop() + ":");
						}
						;
expression : LEFT { System.out.println("  dec rbx"); }
						| RIGHT { System.out.println("  inc rbx"); }
 					  | PLUS {
								System.out.println("  mov cl, [rbx]");
								System.out.println("  inc cl");
								System.out.println("  mov [rbx], cl");
 							}
 						| MINUS {
								System.out.println("  mov cl, [rbx]");
								System.out.println("  dec cl");
								System.out.println("  mov [rbx], cl"); }
 						| PRINT  {
								System.out.println("  mov rdi, 1");
					  		System.out.println("  mov rsi, rbx");
								System.out.println("  mov rdx, 1");
					  		System.out.println("  mov rax, SYSCALL_WRITE");
					  		System.out.println("  syscall");
							}
						| INPUT {
                System.out.println("  mov rdi, 0");
								System.out.println("  mov rsi, rbx");
								System.out.println("  mov rdx, 1");
								System.out.println("  mov rax, SYSCALL_READ");
								System.out.println("  syscall");
 							}
						;

LEFT: '<';
RIGHT: '>' ;
PLUS: '+' ;
MINUS: '-' ;
PRINT: '.' ;
INPUT: ',' ;
WHILE: '[';
ENDWHILE: ']';

WS_AND_COMMENTS: [ \t\r\n]+ -> skip ;
