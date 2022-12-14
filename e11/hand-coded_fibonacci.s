.data

form:
        .string	"%d\n"

.text

fib:
				# Callee prologue
	pushq %rbp		# Saving base pointer
	movq %rsp,%rbp		# Making stack pointer new base pointer

	movq 16(%rbp),%rax	# Assigning argument 1. to %rax; SL was omitted
	cmp $0,%rax		# Comparing %rax to the constant 0
	jne else_1		# Jump to else if not equal
	movq $0,%rax		# Assigning the result (the constant 0) to %rax
	jmp end			# Jump to end
else_1:
	cmp $1,%rax		# Comparing %rax to the constant 1
	jne else_2		# Jump to else if not equal
	movq $1,%rax		# Assigning the result (the constant 1) to %rax
	jmp end			# Jump to end
else_2:
	addq $-1,%rax		# Adding -1 to %rax
	pushq %rax		# Save argument for after the recursive calls

				# Caller prologue for fib(n-1)
	pushq %rax		# Pushing %rax (1. argument)
	call fib		# Automatically pushes return address ~ fib(n-1)
				# Caller epilogue
	addq $8,%rsp		# Popping argument off stack
				# By convention, return value is now in %rax
	popq %rdx		# Move earlier saved original argument to %rdx
	pushq %rax		# Save result for after the second recursive calls
	movq %rdx, %rax		# Prepare argument to second call in %rax
	addq $-1,%rax		# Adding -1 to %rax
				# Caller prologue for fib(n-2)
	pushq %rax		# Pushing %rax (1. argument)
	call fib		# Automatically pushes return address ~ fib(n-1)
				# Caller epilogue
	addq $8,%rsp		# Popping argument off stack
				# By convention, return value is now in %rax
	popq %rdx		# Move earlier saved original argument to %rdx
	addq %rdx,%rax		# %rax = %rdx + %rax ~ fib(n-1) + fib(n-2)
end:
				# Callee epilogue
	popq %rbp		# Restoring base pointer
	ret			# Return from call

.globl main
main:				# Program starts here
				# Callee prologue
	pushq %rbp		# Saving base pointer
	movq %rsp,%rbp		# Making stack pointer new base pointer

				# Caller prologue
	pushq $5		# Pushing the constant 5 (1. argument)
	call fib		# Automatically pushes return address
				# Caller epilogue
	addq $8,%rsp		# Popping argument off stack
				# By convention, return value is now in %rax

				# Caller prologue
	movq $form,%rdi		# Passing string address (1. argument)
	movq %rax,%rsi		# Passing %rax (2. argument)
	movq $0, %rax		# No floating point registers used
	call printf		# Automatically pushes return address
				# Caller epilogue (empty)

				# Callee epilogue
	popq %rbp		# Restoring base pointer
	movq $0, %rax		# Return "no error" exit code
	ret			# Return from call
