#-------------------------------------------------------------------------
#		Organização e Arquitetura de Computadores - Turma C 
#			Trabalho 1 - Programação Assembler
#
# Nome: Raphael Rodrigues		Matrícula: 11/0039530
# Nome: Ulrich Koffi			Matrícula: 11/0089561

.data

image_name:   	.asciiz "lenaeye.raw"   # nome da imagem a ser carregada
address: 	.word   0x10040000	# endereco do bitmap display na memoria	
buffer:		.word   0		# configuracao default do MARS
size:		.word	4096		# numero de pixels da imagem

texto0:		.asciiz "Carregando imagem "
texto1:		.asciiz	"\nDefina o numero da opcao desejada\n1) Obtem ponto\n2) Desenha ponto\n3) Desenha retangulo sem preenchimento\n4) Converte para negativo da imagem\n5) Carrega imagem\n6) Encerra\n"
obtem_ponto_s1:	.asciiz	"Digite o valor de x: \n"
obtem_ponto_s2:	.asciiz	"Digite o valor de y: \n"
obtem_ponto_s3:	.asciiz	"Digite o valor de xi: \n"
obtem_ponto_s4:	.asciiz	"Digite o valor de xf: \n"
obtem_ponto_s5:	.asciiz	"Digite o valor de yi: \n"
obtem_ponto_s6:	.asciiz	"Digite o valor de yf: \n"
valor_R:	.asciiz "Digite o valor de R: "
valor_G:	.asciiz "Digite o valor de G: "
valor_B:	.asciiz "Digite o valor de B: "

quebra_linha:	.asciiz "\n"

.text

#Inicializa a memória com a cor 0x004B0082 -> indigo
inicializacao:
	lw $t1, address
	lw $t2, size
	li $t3, 0x004B0082
	#Armazena o endereço 10040000 em t0
	add $t0, $zero, $t1
	
	j pintaFundoPreto

#Label do menu principal	
menu:
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	
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
	
	#beq $v0, 1, obtem_ponto #get_point
	#beq $v0, 2, desenha_ponto #draw_point
	beq $v0, 3,desenha_retangulo_sem_preenchimento#draw_empty_rectangle
	beq $v0, 4, inicializaParaNegativo #convert_negative
	beq $v0, 5, carregaImagem #load_image
	beq $v0, 6, exit
	
	#Caso não seja igual a 6, retorna para a função menu, senão sai do programa.
	j menu

#-------------------------------------------------------------------------------------------------------------



desenha_retangulo_sem_preenchimento:



#Fun��o para desenhar retangulo sem preenchimento 
#Carrega o endereço da string obtem_ponto_s3 em t0

	la $t0, obtem_ponto_s3
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de xi
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------
	#Armazena o inteiro lido (xi) em v0
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Armazena em a0 o valor de xi
	move $a0, $v0
	
	#guardar o valor de $s0 (xi) em registrador para uso posterior
	add $s0, $zero,$a0
	
	
		#-------------------------------------------------------------------------
	
	#Zera o registrador $t5
	add $t5, $zero, $zero
	
	
	
	#Restaura o valor de a0 (xi)
	move $a0, $t1
	
	#Inverte as posições x
	li $t5, 63
	sub $a0, $t5, $a0
	
	#Zera o registrador $t5
	add $t5, $zero, $zero
	
	
	#Carrega o endereço da string obtem_ponto_s5 em t0
	la $t0, obtem_ponto_s5
	
	#Salva o valor de a0 (xi) em t1
	move $t1, $a0
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de yi
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------

	#-------------------------------------------------------------------------
	#Armazena o inteiro lido em v0 (yi)
	li $v0, 5
	syscall
	
	
	#Armazena em a1 o valor de y
	move $a1, $v0
	
	#guardar o valor de $a1 (yi) em registrador para uso posterior
	add $s1, $zero,$a1
	

	
#----------------------------Endere�o definido pelo valor decimais xf, yf---------------------------
#Carrega o endereço da string obtem_ponto_s4 em t0

	la $t0, obtem_ponto_s4
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de xf
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------
	#Armazena o inteiro lido (xf) em v0
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Armazena em a2 o valor de xf
	move $a0, $v0
	
	#guardar o valor de $a2 (xf) em registrador para uso posterior
	add $s2, $zero,$a0
	
	#Carrega o endereço da string obtem_ponto_s6 em t0
	la $t0, obtem_ponto_s6
	
	#Salva o valor de a2 (xf) em t1
	move $t1, $a0
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de yf
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------

        #Zera o registrador $t5
	add $t5, $zero, $zero
	#Restaura o valor de a2 (xf)
	move $a0, $t1
	
	
	#Inverte as posições x
	li $t5, 63
	sub $a0, $t5, $a0
	
	#Zera o registrador $t5
	add $t5, $zero, $zero
	
	#-------------------------------------------------------------------------
	#Armazena o inteiro lido em v0 (yf)
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Armazena em a3 o valor de yf
	move $a1, $v0
	
	#guardar o valor de $a3 (yf) em registrador para uso posterior
	add $s3, $zero,$a1
	
	
#------------------------------------------VALOR RGB PARA IMPRIMIR UMA COR A CADA PONTO-------------------------------
	
	#Carrega o endereço da string valor_R em t0
	la $t0, valor_R
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de R
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------
	#Armazena o R em v0
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Salva o valor de R em a2
	move $a2, $v0
	
	#Carrega o endereço da string valor_G em t0
	la $t0, valor_G
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de G
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------
	#Armazena o G em v0
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Salva o valor de G em a3
	move $a3, $v0
	
	sll $a2, $a2, 16
	sll $a3, $a3, 8
	
	xor $a2, $a2, $a3
	
	#Carrega o endereço da string valor_B em t0
	la $t0, valor_B
	
	#-------------------------------------------------------------------------
	#Printa para que seja digitado o valor de B
	li $v0, 4
	move $a0, $t0
	syscall
	#-------------------------------------------------------------------------
	
	#-------------------------------------------------------------------------
	#Armazena o B em v0
	li $v0, 5
	syscall
	#-------------------------------------------------------------------------
	
	#Salva o valor de B em a3
	move $a3, $v0
	
	xor $a2, $a2, $a3
	
	#----------------------------------------CALCULO DA POSI�AO DA MEMORIA----------------------------------------	
	
	#Largura do retangulo
	slt $t7, $s0 ,$s2
	bne $t7, $zero, LINHAS
	beq $t7, $zero, LINHAS2
	
	# comprimento do retangulo
	slt $t7, $s1,$s3
	bne $t7, $zero, COLUNAS
	beq $t7, $zero, COLUNAS2

	#-----------------calculo dos contadores t3 para as linhas e t4 para as colunas
				
	LINHAS:
	sub $t3, $s2,$s0
	jr $ra 
 	
	LINHAS2:
	sub $t3, $s0,$s2
	jr $ra 	

	COLUNAS:
	sub $t4, $s3,$s1
	jr $ra 
 	
	COLUNAS2:
	sub $t4, $s1,$s3
	jr $ra 

	#--------------------------------------Xi e Yi----------------------------------
	#Achar o valor correspondente à memória dado pelo par (x,y)
	#Se começar com (0,0), x=0, y=0
	#valor_mem = x.256 + y.4

	move $t6, $s0
	#(x.256)
	mul $s0, $s0, 256
	
	#jal quebralinha
	
	move $t8, $s1
	#(y.4)
	mul $s1, $s1, 4		
	#t0 = (x.256)+(y.4)
	add $t0, $s0, $s1
	#Pega o conteúdo do endereço total do pixel
	lw $t1, address
	add $t0, $t0, $t1
	
	#carrega a cor em RGB
	add $t5, $a2, $zero
	
	#restaura os valores digitados de xi e yi
	move $s0, $t6
	move $s1, $t8
	#--------------------------------------Xf e Yf----------------------------------	
	
	#Achar o valor correspondente à memória dado pelo par (x,y)
	#Se começar com (0,0), x=0, y=0
	#valor_mem = x.256 + y.4
	
	move $t6, $s2
	#(x.256)
	mul $s2, $s2, 256
	
	#-------------------------------------------------------------------------
	#Printa inteiro (a0)
	#li $v0, 1
	#syscall
	#-------------------------------------------------------------------------

	#jal quebralinha
	move  $t9, $s3
	#(y.4)
	mul $s3, $s3, 4
	#t0 = (x.256)+(y.4)
	add $t2, $s2, $s3
	#------retaura os valores digitados para xf e yf--------------------
	move $s3,$t9	
	move $s2,$t6
	
	#----------------------condi��o para saber que configura��o de dire��o para realizar o desenho do retangulo------------------------
	slt $t7, $s1,$s3  
	bne $t7, $zero,LOOP1
	beq $t7, $zero,LOOP4
	
	#loop para variar a coluna(y------------>)e manter a linha(x) 
LOOP1:	
	sw $t5, 0($t0)
	addi $t0, $t0,4
	
	addi $t4, $t4,-1
	beq $t4, $zero, sair1
	j LOOP1
	
	# SAIR1 para variar a linha(x) para cima ou para baixo e manter a coluna(y)   
	sair1:
	slt $t7, $s0,$s2 
	bne $t7, $zero,LOOP2 
	beq $t7, $zero, LOOP3
	
	#LOOP2 para variar x para cima
	LOOP2:
	sw $t5, 0($t0)
	addi $t0, $t0, 256
	
	addi $t3, $t3,-1
	beq $t3, $zero, sair2
	j LOOP2

	#SAIR2 para variar a coluna(y<----------------) e manter o (x)  
		sair2:		
			sw $t5, 0($t0)
			addi $t0, $t0, -4
	
			addi $t4, $t4,-1
			beq $t4, $zero, sair3
			j sair2
	
	#sair3 para variar a linha (x) de cima para baixo
			sair3:	
  				sw $t5, 0($t0)
				addi $t0, $t0, -256
	
				addi $t3, $t3,-1
				beq $t3, $zero, menu
				j sair3

	#LOOP3 para variar as linhas x para baixo
	LOOP3:
		sw $t5, 0($t0)
		addi $t0, $t0, -256
	
		addi $t3, $t3,-1
		beq $t3, $zero, sair4
		j LOOP2
	#sair4 par variar as conlunas y(<-------------)
		sair4: 
			sw $t5, 0($t0)
			addi $t0, $t0, -4
	
			addi $t4, $t4,-1
			beq $t4, $zero, sair5
			j sair4
	#sair5 para variar as linhas(x) de baixo para cima
			
			sair5:
				sw $t5, 0($t0)
				addi $t0, $t0, 256
	
				addi $t3, $t3,-1
				beq $t3, $zero, menu
				j sair5
#LOOP CONTRARIO AO LOOP 1


LOOP4:	
	#loop para variar a coluna(y<------------)e manter a linha(x) 	
	sw $t5, 0($t0)
	addi $t0, $t0,-4
	
	addi $t4, $t4,-1
	beq $t4, $zero, sair6	
	j LOOP4
	
	# SAIR6 para variar a linha(x) para cima ou para baixo e manter a coluna(y)   
	sair6:
	slt $t7, $s0,$s2 
	bne $t7, $zero,LOOP5 
	beq $t7, $zero, LOOP6
	
	#LOOP5 para variar as linhas(x) para cima
	LOOP5:
	sw $t5, 0($t0)
	addi $t0, $t0, 256
	
	addi $t3, $t3,-1
	beq $t3, $zero, sair7
	j LOOP5

	#SAIR7 para variar a coluna(y---------------->) e manter o (x)  
		sair7:		
			sw $t5, 0($t0)
			addi $t0, $t0, 4
	
			addi $t4, $t4,-1
			beq $t4, $zero, sair8
			j sair7
	
	#sair8 para variar a linha (x) de cima para baixo
			sair8:	
  				sw $t5, 0($t0)
				addi $t0, $t0, -256
	
				addi $t3, $t3,-1
				beq $t3, $zero, menu
				j sair8

	#LOOP6 para variar as linhas x  de cima para baixo
	LOOP6:
		sw $t5, 0($t0)
		addi $t0, $t0, -256
	
		addi $t3, $t3,-1
		beq $t3, $zero, sair9
		j LOOP6
	#sair8 par variar as conlunas y(------------->)
		sair9: 
			sw $t5, 0($t0)
			addi $t0, $t0, 4
	
			addi $t4, $t4,-1
			beq $t4, $zero, sair10
			j sair9
	#sair5 para variar as linhas(x) de baixo para cima
			
			sair10:
				sw $t5, 0($t0)
				addi $t0, $t0, 256
	
				addi $t3, $t3,-1
				beq $t3, $zero, menu
				j sair10
	


	#-------------------------------------------------------------------------
	#Printa inteiro (a0) 
	#li $v0, 1
	#add $a0, $t0, $zero
	#syscall
	#-------------------------------------------------------------------------

	


#Label para fazer a operação de \n
quebralinha:

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
	
	jr $ra




	
	#-------------------------------------------------------------------------
	#Printa inteiro (a0) 
	#li $v0, 1
	#add $a0, $t0, $zero
	#syscall
	#-------------------------------------------------------------------------




#---------------------------------------------fim desenha retangulo-------------------------------------------------------

#Função para pintar todos os pixels a partir da variável address em preto
pintaFundoPreto:
	
	sw $t3, 0($t0)

	addi $t0, $t0, 4
	
	beq $t2, $zero, menu
	addi $t2, $t2, -1
	
	j pintaFundoPreto

inicializaParaNegativo:
	# $t0 é o valor do endereço calculado da heap
	# $t1 é o hexa que será o negativo de $t0
	# $t2 é o valor de R
	# $t3 é o valor de G
	# $t4 é o valor de B
	# $t5 é o valor de 255
	# $t6 é o hexa para ser convertido
	# $t7 possui size
	
	#Carrega o valor de 10040000 para t0
	lw $t0, address
	
	#Armazena 255 em $t5
	addi $t5, $zero, 255
	
	lw $t7, size
	
	j converte_negativo

converte_negativo:
	
	#Lê o valor armazenado em t0
	lw $t6, 0($t0)
	
	#-------------------------------------------------------------------------
	#Conversão dos valores de RGB para negativo
	
	#Pega o valor do R e converte pra negativo
	sll $t2, $t6, 8
	srl $t2, $t2, 24
	sub $t2, $t5, $t2
	sll $t2, $t2, 16
	
	#Pega o valor do G e converte pra negativo
	sll $t3, $t6, 16
	srl $t3, $t3, 24
	sub $t3, $t5, $t3
	sll $t3, $t3, 8
	
	#Pega o valor do B e converte pra negativo
	sll $t4, $t6, 24
	srl $t4, $t4, 24
	sub $t4, $t5, $t4
	
	#Faz um xor com os valores de RGB
	xor $t1, $t2, $t3
	xor $t1, $t1, $t4
	#-------------------------------------------------------------------------
	
	#Armazena o negativo de RGB para o valor de t0
	sw $t1, 0($t0)
	
	#Enquanto não percorrer toda a memória, de 4096, irá continuar convertendo os pixels para negativo
	beq $t7, $zero, apaga_registradores
	
	addi $t7, $t7, -1
	
	#Aumenta em 4 o valor de t0
	addi $t0, $t0, 4
	
	j converte_negativo

#Função para zerar os registradores temporários
apaga_registradores:
	
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	add $t3, $zero, $zero
	add $t4, $zero, $zero
	add $t5, $zero, $zero
	add $t6, $zero, $zero
	add $t7, $zero, $zero
	
	j menu

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

	#-------------------------------------------------------------------------
	#Printa o menu
	li $v0, 4
	syscall
	#-------------------------------------------------------------------------
	
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
