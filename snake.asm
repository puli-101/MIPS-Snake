#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


# David Pulido

################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal 
										
colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff, 0x00ffffff, 
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16
.eqv white 20
#		  gray		red	 orange	    yellow	  green      blue	 purple	    violet
rainbow: .word 0x00dcdcdc, 0x00fc2847, 0x00ffa343, 0x00fdfc74, 0x0071bc78, 0x000f4c81, 0x007442c8, 0x00fb7efd
.eqv gray 0
.eqv redV2   4
.eqv orange 8
.eqv yellow  12
.eqv greenV3 16
.eqv blue 20
.eqv purple 24
.eqv violet 28
# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################ indexToHex ####################
# Parametres : a0 indice du bloc de la serpent
# Retour : v0 couleur de l'arc en ciel d'indice a0
##############################################
indexToHex: 
la $t0 rainbow
rem $a0 $a0 8	#il y a 8 couleurs possibles 
mul $t1 $a0 4
add $t0 $t0 $t1
lw $v0 ($t0)

endItHex:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + white
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4
 
PSLoop:
bge $s1 $s0 endPSLoop
  div $a0 $s1 4
  jal indexToHex	#rainbow snake
  move $a0 $v0
  #lw $a0 colors + greenV2
  
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115			
beq $t0 $t1 GIhaut
li $t1 122			
beq $t0 $t1 GIbas
li $t1 	113			
beq $t0 $t1 GIgauche
li $t1 	100			
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
lw $a0 speed
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie 1                                      #
################################################################################

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

nLevel:		.word 0		#Niveau actuel
deltaLevel:	.word 8		#Difference de points entre chaque niveau
 
textLUp:	.asciiz	"Level-Up! Arc-en-Ciel complété !\n"
textNiveau:	.asciiz "Niveau : "

textGameOver:	.asciiz	"Game Over\n"
textScore:	.asciiz	"Score : "
textNRainbows:	.asciiz " arc-en-ciel(s) complété(s) ! \n"
returnC:	.asciiz "\n"
motGentil:	.asciiz "La prochaine sera la bonne ;)\n"

spaceComma:	.asciiz " , "	#Debuggage

speed: 		.word 500 	#vitesse du jeu
speedDiff:	.word 50 	#difference de vitesse par niveau
maxSpeed:	.word 200	#vitesse maximale
.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:
# En haut, ... en bas, ... à gauche, ... à droite, ... ces soirées là ...
#prelude
subu $sp $sp 8
sw $a0 ($sp)
sw $ra 4($sp)
#corps

#traduction en C :
#void majDirection(int n) {
#	if (n == 4) return;		//if invalid input (n=4) then exit 
#	if (abs(snakeDir - n) != 2) 	//si on ne veut pas faire un demi-tour
#		snakeDir = n			//alors mettre a jour la valeur de snakeDir
#}

beq $a0 4 mD_fin		#if n == 4 then return;

lw $t1 snakeDir			#t1 = snakeDir

sub $t0 $t1 $a0 		#t0 = snakeDir  - n
abs $t0 $t0			#t0 = abs(t0)

beq $t0 2 mD_fin		#if (t0 == 2) goto fin;		//si on veut faire un demi-tour alors sortir de majDirection

sw $a0 snakeDir			#snakeDir = n				//si aucune commande illegale -> mettre a jour snakeDir

mD_fin:
#epilogue
lw $a0 ($sp)
lw $ra 4($sp)
addi $sp $sp 8
jr $ra

############################### Decalage ###############################
# Paramètres: $a0 : t : adresse du tableau		
#				$a1 : n : nombre d'elements a decaler 
# Retour: Aucun
# Effet de bord: Decalage a droit des elements du tableau
#####################################################################
decalage:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)
#corps
#void decalage(int *t, int n) {
#	for (int i = n; i > 0; i--)			//on suppose qu'on peut ecrire dans t[n]
#		t[i] = t[i-1];
#}
move $t0 $a1 			#t0 : i = n

mul $t1 $t0 4
add $a0 $a0 $t1		#set a0 address to the address of the last element of the array

decalage_loop: 	blez $t0 decalage_fin	#loop while i > 0
		sub $a0 $a0 4
		lw $t1 ($a0)			#temp = t[i-1]
		sw $t1 4($a0)			#t[i] = temp
		addi $t0 $t0 -1			#t0 : i--
		b decalage_loop
decalage_fin:
#epilogue
lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### bougerSnake ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: On fait bouger le serpent
#       
################################################################################
bougerSnake:
#prologue
subu $sp $sp 4
sw $ra ($sp)

#corps
lw $a1 tailleSnake

la $a0 snakePosX			#on decale le tableau de positions en X vers la droite
jal decalage

la $a0 snakePosY			#on decale le tableau de positions en Y vers la droite
jal decalage					

							#la tete est mise a jour
#snakePosX[0] = snakePosX[1]	//deja fait par le decalage
#snakePosY[0] = snakePosY[1]	// " 

#switch (snakeDir) {
#	case 0:  	SnakePosY[0]++;		break;  		//(haut)
#	case 1: 	SnakePosX[0]++;		break; 			//(droite)
#	case 2: 	SnakePosY[0]--;		break; 			//(bas)
#	case 3: 	SnakePosX[0]--;		break;} 		//(gauche)

lw $t0 snakeDir		#t0 : snakeDir
bnez $t0 bS_case1	#case 0
	lw $t1 snakePosX		#temp = SnakePosY[0]
	addi $t1 $t1 1			#temp++;
	sw $t1 snakePosX	#SnakePosY[0] = temp
	j bS_fin				#break

bS_case1:
addi $t0 $t0 -1
bnez $t0 bS_case2	#case 1
	lw $t1 snakePosY		#temp = SnakePosX[0]
	addi $t1 $t1 1			#temp++;
	sw $t1 snakePosY	#SnakePosX[0] = temp
	j bS_fin				#break

bS_case2:
addi $t0 $t0 -1
bnez $t0 bS_case3	#case 2
	lw $t1 snakePosX		#temp = SnakePosY[0]
	addi $t1 $t1 -1		#temp--;
	sw $t1 snakePosX	#SnakePosY[0] = temp
	j bS_fin				#break

bS_case3:
addi $t0 $t0 -1
bnez $t0 bS_fin		#case 3
	lw $t1 snakePosY		#temp = SnakePosX[0]
	addi $t1 $t1 -1		#temp--;
	sw $t1 snakePosY	#SnakePosX[0] = temp

bS_fin:

#epilogue
lw $ra ($sp)
addi $sp $sp 4
jr $ra

############################### levelUp ###############################
# Paramètres: Aucun
# Retour: Aucun
# Affiche en console un level up 
########################################################################
levelUp:
lw $t0 nLevel
addi $t0 $t0 1
sw $t0 nLevel			#level++;
la $a0 textLUp			
li $v0 4
syscall				#print("Level-Up!\n")
la $a0 textNiveau			
li $v0 4
syscall				#print("Level : ")
move $a0 $t0
li $v0 1
syscall				#print(level)
la $a0 spaceComma		
li $v0 4
syscall				#print(" , ")
la $a0 textScore		
syscall				#print("Score : ")
lw $a0 scoreJeu			
li $v0 1
syscall				#print(score)
la $a0 returnC
li $v0 4			
syscall
syscall				#print("\n\n")

lw $t0 speed
lw $t1 maxSpeed
ble $t0 $t1 lUp_end		#if (speed <= maxSpeed) return; 
lw $t2 speedDiff
sub $t0 $t0 $t2			#speed = speed - speedDiff
sw $t0 speed

lUp_end:
jr $ra

############################### testBonbon ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
###########################################################################
testBonbon:
#prologue
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)
#corps
#void testBonbon() {
#	if (snake.x == candy.x) {
#		if (snake.y == candy.y) { 
#			score++
#			size++;
#			
#			bonbon = newRandomObjectPosition;
#
#			decalage(obstacles);
#			obstacle[0] = newRandomObjectPosition;
#			numObstacles++;
#		}
#	}
#}
lw $t0 snakePosX
lw $t1 snakePosY

lw $t2 candy
lw $t3 candy + 4

bne $t0 $t2 testB_end	#if (snake.x != candy.x) goto end;
bne $t1 $t3 testB_end	#if (snake.y != candy.y) goto end;

lw $t0 scoreJeu
addi $t0 $t0 1
sw $t0 scoreJeu 		#scoreJeu++

lw $t0 tailleSnake
addi $t0 $t0 1
sw $t0 tailleSnake 		#tailleSnake++

jal newRandomObjectPosition
sw $v0 candy			
sw $v1 candy + 4		#bonbon = newPosition();

lw $a1 numObstacles
la $a0 obstaclesPosX		#on decale le tableau des positions en X des obstacles vers la droite
jal decalage
la $a0 obstaclesPosY		#on decale le tableau des positions en Y des obstacles vers la droite
jal decalage

jal newRandomObjectPosition
sw $v0 obstaclesPosX
sw $v1 obstaclesPosY		#obstacle[0] = newPosition();

lw $t0 numObstacles
addi $t0 $t0 1
sw $t0 numObstacles 		#numObstacles++

lw $t0 scoreJeu			#if (score % deltaLevel == 0) then Level-Up!
lw $t3 deltaLevel
rem $t1 $t0 $t3
bnez $t1 testB_end
jal levelUp

testB_end:
#epilogue
lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:
# jal hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt
#prelude
subu $sp $sp 4
sw $ra ($sp)
#corps
jal bougerSnake	#on decale les tableaux de positions et on fait la mise a jour de la tete d'apres snakeDir
jal testBonbon 	#on teste si la serpent a mangé le bonbon
#epilogue
lw $ra ($sp)
addi $sp $sp 4
jr $ra

############################### dedansGrille ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si la serpent se trouve dedans la grille
################################################################################
dedansGrille:
#prologue
subu $sp $sp 8
sw $ra ($sp)
sw $a0 4($sp)
#corps
#int dedansGrille() {
#	if (snake.x >= 0) {
#		if (snake.x < 16) {
#			if (snake.y >= 0) {
#				if (snake.y < 16) {
#					return 0;
#				}
#			}
#		}
#	}
#	return 1;
#}

lw $t0 snakePosX	#t0 : snake.x
lw $t1 snakePosY	#t1 : snake.y

bltz $t0 dG_echec	#if (snake.x < 0) return 1; 
bge $t0 16 dG_echec	#if (snake.x >= 16) return 1;

bltz $t1 dG_echec	#if (snake.y < 0) return 1; 
bge $t1 16 dG_echec	#if (snake.y >= 16) return 1;

li $v0 0		
j dG_end		#return 0;

dG_echec:
li $v0 1	#return 1

dG_end:
#epilogue
lw $ra ($sp)
lw $a0 4($sp)
addi $sp $sp 8

jr $ra

############################### contactObstacle ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si la tête du serpent ne rentre pas en contact avec un obstacle
################################################################################
contactObstacle:
#prologue
subu $sp $sp 4
sw $ra ($sp)
#corps
#int dedansGrille() {
#	for (int i = 0; i < num_obstacles; i++) {
#		if (snake.x == obstacle[i].x) {
#			if (snake.y == obstacle[i].y)
#				return 1;
#		}
#	}
#	return 0;
#}

li $t0 0 		#t0 : i = 0
lw $t1 numObstacles	#t1 : num_obstacles
lw $t2 snakePosX	#t2 : snake.x
lw $t3 snakePosY	#t3 : snake.y
la $t4 obstaclesPosX	#t4 : &obstacleX[i]
la $t5 obstaclesPosY	#t5 : &obstacleY[i]
			#t6 : *(&obstacleX[i]) = obstacleX[i]
			#t7 : *(&obstacleY[i]) = obstacleY[i]

cO_for:		bge $t0 $t1 cO_end_for	#while (i < num_obstacles) {
		
		lw $t6 ($t4)
		lw $t7 ($t5)
		
		bne $t2 $t6 cO_diff	#	if (snake.x != obstacle[i].x) continue;
		bne $t3 $t7 cO_diff	#	if (snake.y != obstacle[i].y) continue;
		
		li $v0 1
		j contactO_end		#	return 1;
		
		cO_diff:
		
		addi $t4 $t4 4
		addi $t5 $t5 4
		addi $t0 $t0 1		#	i++;
		b cO_for		#}
cO_end_for:

li $v0 0				#return 0;

contactO_end:
#epilogue
lw $ra ($sp)
addi $sp $sp 4

jr $ra

############################### contactCorps ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si la tete du serpent n'est pas en contact avec son propre corps
################################################################################
contactCorps:
#prologue
subu $sp $sp 4
sw $ra ($sp)
#corps
#int contactCorps() {
#	for (int i = 1; i < taille_snake; i++) {
#		if (snake.x == snake[i].x) {
#			if (snake.y == snake[i].y) {
#				return 1;
#			}
#		}
#	}
#	return 0;
#}
li $t0 1 		#t0 : i = 1
lw $t1 snakePosX	#t1 : snake.x
lw $t2 snakePosY	#t2 : snake.y
la $t3 snakePosX + 4	#t3 : &snake[i].x
la $t4 snakePosY + 4	#t4 : &snake[i].y
lw $t5 tailleSnake	#t5 : taille_snake
			#t6 : *(&snake[i].x) = snake[i].x
			#t7 : *(&snake[i].x) = snake[i].x
			
contactC_for:		bge $t0 $t5 contactC_end_for	#while (i < taille_snake) {
			
			lw $t6 ($t3)			
			lw $t7 ($t4)			
			
			bne $t1 $t6 cC_continue_for	#	if (snake.x != snake[i].x) continue;
			bne $t2 $t7 cC_continue_for	#	if (snake.y != snake[i].y) continue;
			
			li $v0 1
			j contactC_end			#	return 1;
			
			cC_continue_for:
			addi $t3 $t3 4
			addi $t4 $t4 4
			addi $t0 $t0 1			#	i++;
			b contactC_for			#}
contactC_end_for:
li $v0 0

contactC_end:
#epilogue
lw $ra ($sp)
addi $sp $sp 4

jr $ra

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:
#prologue
subu $sp $sp 4
sw $ra ($sp)
#corps
#int finJeu() {
#	if (dedansGrille() != 0) return 1;		//la tête du serpent ne doit pas dépasser la bordure de la grill
#	if (contactObstacle() != 0) return 1;	//la tête du serpent ne doit pas rentrer en contact avec un obstacle
#	if (contactCorps() != 0) return 1;		//le serpent ne doit pas rencontrer une partie de son propre corps
#	return 0;
#}
jal dedansGrille
bnez $v0 cFJ_echec	#if (dedansGrille() != 0) return 1;

jal contactObstacle
bnez $v0 cFJ_echec	#if (contactObstacle() != 0) return 1;

jal contactCorps
bnez $v0 cFJ_echec	#if (contactCorps() != 0) return 1;

j cFJ_reussite		#return 0;

cFJ_echec:		#return 1;
li $v0 1
j conditionFJ_end

cFJ_reussite:		#return 0;
li $v0 0

conditionFJ_end:
#epilogue
lw $ra ($sp)
addi $sp $sp 4

jr $ra


############################### drawHorizontal ################################
# Paramètres: 	a0 taille de la ligne, 
#		a1 position initial en X, 
#		a2 position initial en Y
#		a3 couleur de la ligne
# Retour: Aucun
# Effet de bord: Affiche une ligne horizontal de taille a0 
#	qui commence dans les coordonnees (x,y) = (a1,a2)
################################################################################
drawHorizontal:
subu $sp $sp 24
sw $ra ($sp)
sw $s0 4($sp)
sw $s1 8($sp)
sw $s2 12($sp)
sw $s3 16($sp)
sw $s4 20($sp)

move $s0 $a0	#s0 : n
move $s1 $a1	#s3 : X
move $s2 $a2	#s2 : Y
move $s3 $a3	#s3 : couleur

li $s4 0	#s4 : i

dH_for: bge $s4 $s0 dH_end_for	#while (i < n)
	move $a0 $s3
	move $a1 $s1
	add $a2 $s2 $s4
	jal printColorAtPosition
	addi $s4 $s4 1		#i++
	b dH_for
dH_end_for:

lw $ra ($sp)
lw $s0 4($sp)
lw $s1 8($sp)
lw $s2 12($sp)
lw $s3 16($sp)
lw $s4 20($sp)
addi $sp $sp 24
jr $ra

############################### drawVertical ################################
# Paramètres: 	a0 taille de la ligne, 
#		a1 position initial en X, 
#		a2 position initial en Y
#		a3 couleur de la ligne
# Retour: Aucun
# Effet de bord: Affiche une ligne horizontal de taille a0 
#	qui commence dans les coordonnees (x,y) = (a1,a2)
################################################################################
drawVertical:
subu $sp $sp 24
sw $ra ($sp)
sw $s0 4($sp)
sw $s1 8($sp)
sw $s2 12($sp)
sw $s3 16($sp)
sw $s4 20($sp)

move $s0 $a0	#s0 : n
move $s1 $a1	#s3 : X
move $s2 $a2	#s2 : Y
move $s3 $a3	#s3 : couleur

li $s4 0	#s4 : i

dV_for: bge $s4 $s0 dV_end_for	#while (i < n)
	move $a0 $s3
	add $a1 $s1 $s4		#new_x = x + i
	move $a2 $s2
	jal printColorAtPosition
	addi $s4 $s4 1		#i++
	b dV_for
dV_end_for:

lw $ra ($sp)
lw $s0 4($sp)
lw $s1 8($sp)
lw $s2 12($sp)
lw $s3 16($sp)
lw $s4 20($sp)
addi $sp $sp 24
jr $ra

############################### draw8 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 8 dans le Bitmap Display
###############################################################
draw8:
subu $sp $sp 20
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $s0 12($sp)
sw $s1 16($sp)

move $s0 $a0
move $s1 $a1

li $a0 5	#n		ligne haut
move $a1 $s0	#X
move $a2 $s1	#Y
lw $a3 colors + green
jal drawHorizontal	

li $a0 5	#n		ligne bas
add $a1 $s0 8	#X + 8
move $a2 $s1	#Y
lw $a3 colors + green
jal drawHorizontal

li $a0 9	#n		ligne gauche
move $a1 $s0	#X
move $a2 $s1	#Y
lw $a3 colors + green
jal drawVertical

li $a0 9	#n		ligne droite
move $a1 $s0	#X 
add $a2 $s1 4	#Y + 4
lw $a3 colors + green
jal drawVertical

li $a0 5	#n		ligne au mileu
add $a1 $s0 4	#X + 4
move $a2 $s1	#Y
lw $a3 colors + green
jal drawHorizontal

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $s0 12($sp)
lw $s1 16($sp)
addi $sp $sp 20

jr $ra


############################### draw9 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 9 dans le Bitmap Display
###############################################################
draw9:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)

jal draw8

move $t0 $a0
move $t1 $a1

li $a0 3		#n		supprimer sous ligne gauche en bas
add $a1 $t0 5		#X + 5
move $a2 $t1		#Y
lw $a3 colors + black
jal drawVertical

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### draw0 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 0 dans le Bitmap Display
###############################################################
draw0:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)

jal draw8

move $t0 $a0
move $t1 $a1

li $a0 3		#n		supprimer sous ligne au milieu
add $a1 $t0 4		#X + 4
add $a2 $t1 1		#Y + 1
lw $a3 colors + black
jal drawHorizontal

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### draw1 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 1 dans le Bitmap Display
###############################################################
draw1:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)

move $t0 $a0
move $t1 $a1

li $a0 9		#n		ligne droite unique
move $a1 $t0		#X
add $a2 $t1 4		#Y + 1
lw $a3 colors + green
jal drawVertical

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### draw6 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 6 dans le Bitmap Display
###############################################################
draw6:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)

jal draw8

move $t0 $a0
move $t1 $a1

li $a0 3		#n		supprimer sous ligne droite en haut
add $a1 $t0 1		#X + 1
add $a2 $t1 4		#Y + 4
lw $a3 colors + black
jal drawVertical

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### draw5 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 6 dans le Bitmap Display
###############################################################
draw5:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)

jal draw9

move $t0 $a0
move $t1 $a1

li $a0 3		#n		supprimer sous ligne droite en haut
add $a1 $t0 1		#X + 1
add $a2 $t1 4		#Y + 4
lw $a3 colors + black
jal drawVertical

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### draw7 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 7 dans le Bitmap Display
###############################################################
draw7:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)

jal draw1

move $t0 $a0
move $t1 $a1

li $a0 4		#n		ajout sous ligne horizontal en haut
move $a1 $t0		#X
move $a2 $t1 		#Y
lw $a3 colors + green
jal drawHorizontal

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### draw3 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 3 dans le Bitmap Display
###############################################################
draw3:
subu $sp $sp 12
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)

jal draw9

move $t0 $a0
move $t1 $a1

li $a0 3		#n		supprimer sous ligne gauche en haut
add $a1 $t0 1		#X + 1
move $a2 $t1		#Y
lw $a3 colors + black
jal drawVertical

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
addi $sp $sp 12

jr $ra

############################### draw4 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 4 dans le Bitmap Display
###############################################################
draw4:
subu $sp $sp 20
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $s0 12($sp)
sw $s1 16($sp)

jal draw9

move $s0 $a0
move $s1 $a1

li $a0 3		#n		supprimer sous ligne en haut
move $a1 $s0		#X
add $a2 $s1 1		#Y + 1
lw $a3 colors + black
jal drawHorizontal

li $a0 4		#n		supprimer sous ligne en bas
add $a1 $s0 8		#X + 8
move $a2 $s1		#Y
lw $a3 colors + black
jal drawHorizontal

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $s0 12($sp)
lw $s1 16($sp)
addi $sp $sp 20

jr $ra

############################### draw2 #########################
# Paramètres: 	a0 : X
#		a1 : Y
# Retour: Aucun
# Effet de bord: Affiche un 2 dans le Bitmap Display
###############################################################
draw2:
subu $sp $sp 20
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $s0 12($sp)
sw $s1 16($sp)

jal draw8

move $s0 $a0
move $s1 $a1

li $a0 3		#n		supprimer sous ligne gauche en haut
add $a1 $s0 1		#X + 1
move $a2 $s1		#Y
lw $a3 colors + black
jal drawVertical

li $a0 3		#n		supprimer sous ligne droit en bas
add $a1 $s0 5		#X + 5
add $a2 $s1 4		#Y + 4
lw $a3 colors + black
jal drawVertical

lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $s0 12($sp)
lw $s1 16($sp)
addi $sp $sp 20

jr $ra

############################### drawScore ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score en surimpression du jeu.
################################################################################
drawScore:
subu $sp $sp 28
sw $ra ($sp)
sw $a0 4($sp)
sw $a1 8($sp)
sw $s0 12($sp)
sw $s1 16($sp)
sw $s2 20($sp)
sw $s3 24($sp)
#(2,2) pour les decimes (2,8) pour les unites

li $s0 0		#s0 : i
li $s1 1		#s1 : X
li $s2 7		#s2 : Y
lw $s3 scoreJeu		#s3 : Score

dS_loop: bge $s0 2 dS_end_loop	#repeter deux fois afficher chiffre du Score
	rem $t0 $s3 10		#t0 = score % 10
	
	move $a0 $s1
	move $a1 $s2
	
	dS_case0: 
		bnez $t0 dS_case1
		jal draw0
		j dS_end_switch
	dS_case1:addi $t0 $t0 -1
		bnez $t0 dS_case2
		jal draw1
		j dS_end_switch
	dS_case2:addi $t0 $t0 -1
		bnez $t0 dS_case3
		jal draw2
		j dS_end_switch
	dS_case3:addi $t0 $t0 -1
		bnez $t0 dS_case4
		jal draw3
		j dS_end_switch
	dS_case4:addi $t0 $t0 -1
		bnez $t0 dS_case5
		jal draw4
		j dS_end_switch
	dS_case5:addi $t0 $t0 -1
		bnez $t0 dS_case6
		jal draw5
		j dS_end_switch
	dS_case6:addi $t0 $t0 -1
		bnez $t0 dS_case7
		jal draw6
		j dS_end_switch
	dS_case7:addi $t0 $t0 -1
		bnez $t0 dS_case8
		jal draw7
		j dS_end_switch
	dS_case8:addi $t0 $t0 -1
		bnez $t0 dS_case9
		jal draw8
		j dS_end_switch
	dS_case9:
		jal draw9
	
	dS_end_switch:
	addi $s0 $s0 1		
	addi $s2 $s2 -6		#on bouge 6 unites a gauche
	div $s3 $s3 10		#tempScore /= 10
	b dS_loop

dS_end_loop:

li $a0 7		#point d'exclamation 
li $a1 1
li $a2 14
lw $a3 colors + rose
jal drawVertical

li $a0 1
li $a1 9
li $a2 14
lw $a3 colors + rose
jal drawVertical
 			#smiley

li $a0 2			#yeux
li $a1 11
li $a2 8
lw $a3 rainbow + yellow 
jal drawVertical

li $a0 2			
li $a1 11
li $a2 6
lw $a3 rainbow + yellow 
jal drawVertical

li $a0 5			#bouche
li $a1 14
li $a2 5
lw $a3 rainbow + yellow
jal drawHorizontal

lw $a0 rainbow + yellow 
li $a1 13	
li $a2 4
jal printColorAtPosition

lw $a0 rainbow + yellow 
li $a1 13	
li $a2 10
jal printColorAtPosition	
			#fin smiley
#epilogue
lw $ra ($sp)
lw $a0 4($sp)
lw $a1 8($sp)
lw $s0 12($sp)
lw $s1 16($sp)
lw $s2 20($sp)
lw $s3 24($sp)
addi $sp $sp 28
 
jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
subu $sp $sp 8
sw $ra ($sp)
sw $a0 4($sp)

la $a0 textGameOver	#print("Game Over\n")
li $v0 4
syscall

la $a0 textScore	#print("Score : ")
li $v0 4
syscall

lw $a0 scoreJeu		#print(score)
li $v0 1
syscall

la $a0 returnC		#print("\n")
li $v0 4
syscall

lw $a0 nLevel		#print(level)
li $v0 1
syscall

la $a0 textNRainbows	#print(" arc-en-ciel accompli(s) !\n")
li $v0 4
syscall 

la $a0 motGentil	#print("La prochaine sera la bonne ;)\n")
li $v0 4
syscall

jal resetAffichage
jal drawScore		#affichage graphique

# Fin.
lw $ra ($sp)
lw $a0 4($sp)
addi $sp $sp 8

jr $ra
