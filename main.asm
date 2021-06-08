INCLUDE Irvine32FCIS.inc
.data
seq1r byte "Enter the first sequence: ",0
seq2r byte "Enter the second sequence: ",0
messg1 byte "*** Scoring Weights ***",0
messg2 byte "Enter the match Greater than Zero : ",0
messg3 byte "Enter the mismatch To be Less than Match OR Greater than: ",0
messg4 byte "Enter the gap penality to be Less than OR Equal Zero: ",0

seq1 byte 100 dup(?) 
seq2 byte 100 dup(?)
match dword ?
mismatch dword ?
gap_penality dword ?
actuallengthseq1 dword ?
actuallengthseq2 dword ?
isaver dword 0
jsaver dword 0
jcounter_saver dword 0
icounter_saver dword 0

i dword 0
j dword 0
icounter byte 0
jcounter byte 0
twoDarray dword 10000  dup(?)

MatchError byte "Invalid Match value ",0
MisMatchError byte "Invalid Missmatch value ",0
GapError byte "Invalid Gap Penalty value ",0
ms byte "Congratulations ",0

var1 dword ?
var2 dword ?
var3 dword ?
.code
main proc
mov edx, offset seq1r
call writestring
call crlf 
mov edx , offset seq1
mov ecx , lengthof seq1
call readstring  
mov actuallengthseq1,eax
inc actuallengthseq1


mov edx, offset seq2r
call writestring
call crlf 
mov edx , offset seq2
mov ecx , lengthof seq2
call readstring  
mov actuallengthseq2,eax
inc actuallengthseq2
one :
mov edx, offset messg1
call writestring
call crlf

mov edx, offset messg2
call writestring
call crlf
call readint
mov match, eax

mov edx, offset messg3
call writestring
call crlf
call readint
mov mismatch, eax

mov edx, offset messg4
call writestring
call crlf
call readint
mov gap_penality, eax

cmp match , 0
jle nomatch 
mov edi , match
cmp mismatch , edi 
jge nomismatch
cmp gap_penality, 0
jg nogap
jmp outt 

nomatch :
mov edx, offset MatchError 
call writestring
call crlf
jmp outt1

nomismatch :
mov edx, offset MisMatchError 
call writestring
call crlf
jmp outt1

nogap :
mov edx, offset GapError 
call writestring
call crlf
 jmp outt
 outt:
mov edx, offset ms 
call writestring
call crlf
push offset seq1
push offset seq2
call dp
outt1:
 jmp one 
exit 
 main endp
dp proc,SEQ_1:ptr byte,SEQ_2:ptr byte
    
    mov esi,SEQ_1
    mov edi,SEQ_2
    
  mov twoDarray [0] ,0
  mov ecx , actuallengthseq2  
  L2:
  mov eax ,i
  mul actuallengthseq2
  mov ebx, eax
  mov ebp,j
 cmp j , 0
 je gapputting
 jmp outch
 gapputting:
 movzx eax,icounter
 imul gap_penality
 mov twoDarray [ebx +ebp] ,eax
 outch:
 inc icounter
 add i,4 
 loop l2 
 push eax
 mov eax , i
 mov isaver , eax 
 pop eax
  mov ecx , actuallengthseq1 
  mov i,0
  l1 :
  mov eax ,i
  mul actuallengthseq2
  mov ebx, eax
  mov ebp,j 
 cmp i,0
 je gapputting2
 jmp outch2
 gapputting2:
 movzx eax,jcounter
 imul gap_penality
 mov twoDarray [ebx +ebp] ,eax
 outch2:
 inc jcounter
 add j,4 
 loop l1
 push eax
 mov eax , j 
 mov jsaver , eax  
 pop eax 

 mov ecx, actuallengthseq2
 l3:
 push ecx
 mov ecx, actuallengthseq1
 l4:
 push edx
 mov edx, isaver
 sub edx, 4
 mov eax ,edx
 mul actuallengthseq2
 mov ebx, eax
 mov ebp,jsaver
 mov ebx, twoDarray[ebp+ebx] 
 add ebx, gap_penality
 mov var1, ebx
 pop edx

 push edx
 mov edx, jsaver
 sub edx, 4
 mov eax ,isaver
 mul actuallengthseq2
 mov ebx, eax
 mov ebp,edx
 mov ebx, twoDarray[ebp+ebx] 
 add ebx, gap_penality
 mov var2, ebx
 pop edx


 push edx
 mov edx, isaver
 sub edx, 4
 mov eax ,edx
 mul actuallengthseq2
 mov ebx, eax
 push edi
 mov edi, jsaver
 sub edi, 4
 mov ebp,edi
  pop edi
 mov ebx, twoDarray[ebp+ebx] 
 push eax 
 mov  eax , [edi]
 cmp [esi], eax 
  pop eax
 je matchyputting
 add ebx , mismatch 
 mov  var3 ,ebx 
jmp outy 

 matchyputting :
 add ebx , match 
 mov  var3 ,ebx 

 outy :
 add edi , 1
add esi , 1 
 pop edx

 
 push  edi
 mov edi , var1
 cmp var2 , edi 
 jge ll1
 cmp edi,var3 
 jge ll3
 ll1: 
 push esi 
 mov esi , var3
 cmp var2 , esi
 jge ll2
 cmp esi,var3
 jge ll3
 jl ll4
 ll2:
 mov eax ,isaver
 mul actuallengthseq2
 mov ebx, eax
 mov ebp,jsaver
 push edx
 mov edx,var2
 mov twoDarray[ebp+ebx] ,edx
 pop edx
 jmp x
 ll3:
 mov eax ,isaver
 mul actuallengthseq2
 mov ebx, eax
 mov ebp,jsaver
 mov twoDarray[ebp+ebx] ,esi
 pop edx
 pop esi 
 pop edi
 jmp x
 ll4:
 mov eax ,isaver
 mul actuallengthseq2
 mov ebx, eax
 mov ebp,jsaver
 push edx
 mov edx,var3
 mov twoDarray[ebp+ebx] ,edx
 pop edx
 jmp x 

 add jsaver,4
jnz l4
pop ecx
add isaver,4
 jnz l3
;Dool 3shan at2ked n l gap atmlt sah
x:
 mov eax,twoDarray [0]
 call writedec
 call crlf
 mov eax,twoDarray [4]
 call writeint
 call crlf
 mov eax,twoDarray [8]
 call writeint
 call crlf
  mov eax,twoDarray [12]
 call writeint
 call crlf
 mov eax,twoDarray [16]
 call writeint
 call crlf
 mov eax,twoDarray [20]
 call writeint
 call crlf
 mov eax,twoDarray [28]
 call writeint
 call crlf
 mov eax,twoDarray [32]
 call writeint
 call crlf

 mov eax,twoDarray [24]
 call writeint
 call crlf
 ret
 dp endp
    END main 