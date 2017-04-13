#-------------------------------------------------------------------------
#		Organização e Arquitetura de Computadores - Turma C 
#			Trabalho 1 - Programação Assembler
#
# Nome: Raphael Rodrigues		Matrícula: 11/0039530
# Nome: Ulrich Koffi			Matrícula: 
# Nome: 				Matrícula: 

.data

image_name:   	.asciiz "/home/nothereboy/Documents/UnB/OAC/2017_1/Trabalho 1/lenaeye.raw"   # nome da imagem a ser carregada
address: 	.word   0x10040000	# endereco do bitmap display na memoria	
buffer:		.word   0		# configuracao default do MARS
size:		.word	4096		# numero de pixels da imagem

texto0:		.asciiz "Carregando imagem "
texto1:		.asciiz	"\nDefina o numero da opcao desejada\n1) Obtem ponto\n2) Desenha ponto\n3) Desenha retangulo sem preenchimento\n4) Converte para negativo da imagem\n5) Carrega imagem\n6) Encerra\n"
obtem_ponto_s1:	.asciiz	"Digite o valor de x: \n"
obtem_ponto_s2:	.asciiz	"Digite o valor de y: \n"
quebra_linha:	.asciiz "\n"

.text

#Label do menu principal	
menu:
	#Armazena em t0 o endereço do menu
	la $t0, texto1
	
	#-------------------------------------------------------------------------
	#Printa o menu inicial de 6 opções
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------
	#Lê a opção desejada
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	beq $v0, 1, obtem_ponto
	beq $v0, 5, carregaImagem
	beq $v0, 6, exit
	
	#Caso não seja igual a 6, retorna para a função menu, senão sai do programa.
	j menu

obtem_ponto:
	
	#Carrega o endereço da string obtem_ponto_s1 em t0
	la $t0, obtem_ponto_s1
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de x
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------
	#Armazena o inteiro lido em v0 (x)
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Armazena em a0 o valor de x
	move $a0, $v0
	
	#Carrega o endereço da string obtem_ponto_s2 em t0
	la $t0, obtem_ponto_s2
	
	#Salva o valor de a0 (x) em t1
	move $t1, $a0
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de y
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------

	#Restaura o valor de a0 (x)
	move $a0, $t1
	
	#-------------------------------------------------------------------------
	#Armazena o inteiro lido em v0 (y)
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Armazena em a1 o valor de y
	move $a1, $v0
	
	#Achar o valor correspondente à memória dado pelo par (x,y)
	#Se começar com (0,0), x=0, y=0
	#valor_mem = x.256 + y.4

	#(x.256)
	mul $a0, $a0, 256
	
	#-------------------------------------------------------------------------
	#Printa inteiro (a0)
	li $v0, 1
	syscall
	#-------------------------------------------------------------------------
	
	jal quebralinha
	
	#(y.4)
	mul $a1, $a1, 4
	#t0 = (x.256)+(y.4)
	add $t0, $a0, $a1
	#Pega o endereço total do pixel
	lw $t1, address
#	add $t0, $t0, $t1
#	lw $t0, 0($t0)
	
	#-------------------------------------------------------------------------
	#Printa inteiro (a0) 
	li $v0, 1
	add $a0, $t0, $zero
	syscall
	#-------------------------------------------------------------------------
	
	#Falta armazenar o valor da posição da memória + o valor de t0
	
#	lw $t0, 0()
	
	#Se começar com (1,1), x=1, y=1
	#valor_mem = (x-1).256 + (y-1).4
	
	j menu

#Label para fazer a operação de \n
quebralinha:

	#-------------------------------------------------------------------------
	#Printa inteiro (a0)
	li $v0, 1
	syscall
	#-------------------------------------------------------------------------

	#Aloca o espaço para 1 registrador na pilha
	addi $sp, $sp, -4
	#Salva o valor de a0 na pilha
	sw $a0, 0($sp)
	
	li $v0, 4
	la $a0, quebra_linha
	syscall
	
	#Restaura o valor de a0 da pilha
	lw $a0, 0($sp)
	#Desaloca o espaço de 1 registrador da pilha
	addi $sp, $sp, 4
	
	#-------------------------------------------------------------------------
	#Printa inteiro (a0)
	li $v0, 1
	syscall
	#-------------------------------------------------------------------------
	
	jr $ra

# Label para carregar imagem, especificados através dos parâmentros do campo data.
carregaImagem:
	
	#Armazena em t0 o endereço de texto0
	la $t0, texto0
	
	#-------------------------------------------------------------------------
	#Printa o menu
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	la $a0, image_name
	
	#Armazena em t0 o endereço do menu
#	move $t0, $a0
	
	#-------------------------------------------------------------------------
	#Printa o menu
	li $v0, 4
	syscall
	#-------------------------------------------------------------------------
	
#	move $a0, $t0
	
	lw $a1, address
	la $a2, buffer
	lw $a3, size
	jal load_image
	
	j menu

#-------------------------------------------------------------------------
# O label load_image: carrega uma imagem em formato RAW RGB para memoria
# Formato RAW: sequencia de pixels no formato RGB, 8 bits por componente
# de cor, R o byte mais significativo
#
# Parametros:
#  $a0: endereco do string ".asciiz" com o nome do arquivo com a imagem
#  $a1: endereco de memoria para onde a imagem sera carregada
#  $a2: endereco de uma palavra na memoria para utilizar como buffer
#  $a3: tamanho da imagem em pixels
load_image:
	# salvar parametros da funcao nos termporarios
	move $t7, $a0		# nome do arquivo
	move $t8, $a1		# endereco de carga
	move $t9, $a2		# buffer para leitura de um pixel do arquivo

	li $v0, 13		# system call para abertura de arquivo
	li $a1, 0		# Abre arquivo para leitura (parâmtros são 0: leitura, 1: escrita)
	li $a2, 0		# modo é ignorado
	syscall			# abre um arquivo (descritor do arquivo é retornado em $v0)
	move $t6, $v0		# salva o descritor do arquivo
  
	move $a0, $t6		# descritor do arquivo
	move $a1, $t9		# endereço do buffer
	li $a2, 3		# largura do buffer
	
	j loop

loop:

	beq $a3, $zero, close
  
	li $v0, 14		# system call para leitura de arquivo
	syscall			# lê o arquivo
	lw $t0, 0($a1)		# lê pixel do buffer
	sw $t0, 0($t8)		# escreve pixel no display
	addi $t8, $t8, 4	# próximo pixel
	addi $a3, $a3, -1	# decrementa contador

	j loop
  
# fecha o arquivo 
close:  
	li $v0, 16		# system call para fechamento do arquivo
	move $a0, $t6		# descritor do arquivo a ser fechado
	syscall			# fecha arquivo
  	
	jr $ra

#Label para a saída do programa
exit:
	#-------------------------------------------------------------------------
	#Encerra o programa
	li $v0, 10
	syscall
	#-------------------------------------------------------------------------
