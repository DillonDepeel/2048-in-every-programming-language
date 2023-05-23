SetUpEditor T48,B,A,L6,L5,L4,L3,L2,L1
1->dim(LT48
cumSum(binomcdf(15,0
.1+.1remainder(Ans-1,4)+int(.25(3+Ans->A
Ans->L1
rand (28->B
DelVar [A]DelVar C{4,4->dim([A]
identity(4->[B]
1->B
int(1+LB(B)sum(not(not(L1->A
2+2(.9<LB(B+1->[A](10fPart(L1(Ans)),iPart(L1(Ans
0->L1(A
SortD(L1
ClrHome
Disp "2048 BY SiMON","BEST:",LT48(1),"TRY TO GET 2048!","PRESS 2ND TO END
Repeat getKey:End
Repeat K=21
	1+remainder(B,28->B
	If [A]!=[B] and max(L1:Then
		int(1+LB(B)sum(not(not(L1
		2+2(.9<LB(Ans+1->[A](10fPart(L1(Ans)),iPart(L1(Ans
		getKey
		ClrHome
		Disp [A],C
	End
	Repeat max(Ans={21,24,25,26,34
		getKey->K
	End
	If K!=21:Then
		[A]->[B]
		If 1=abs(K-25
		Ans^^-1
		If 4=abs(K-30
		Then
		rSwapAns,1,4:rSwapAns,2,3:End
		Matr>list(Ans,L6,L5,L4,L3
		If L6(1:Then
			5-max({0,3,2,1}(L6=L6(1
			If not(5=AnsBoxplot(2) and Ans>2=4 and L6(3:Then
				0->L6(Ans
				2L6(1->L6(1
				C+Ans->C
			End
		End
		If L6(2:Then
			5-max({0,0,2,1}(L6=L6(2
			If not(5=Ans=4 and L6(3
			Then
				0->L6(Ans
				2L6(2->L6(2
				C+Ans->C
			End
		End
		L6(3
		If Ans and Ans=L6(4:Then
			2Ans->L6(3
			C+Ans->C
			0->L6(4
		End
		If L5(1:Then
			5-max({0,3,2,1}(L5=L5(1
			If not(5=Ans>2 and L5(2)=4 and L5(3
			Then
				0->L5(Ans
				2L5(1->L5(1
				C+Ans->C
			End
		End
		If L5(2:Then
			5-max({0,0,2,1}(L5=L5(2
			If not(5=Ans=4 and L5(3
			Then
				0->L5(Ans
				2L5(2->L5(2
				C+Ans->C
			End
		End
		L5(3
		If Ans and Ans=L5(4:Then
			2Ans->L5(3
			C+Ans->C
			0->L5(4
		End
		If L4(1:Then
			5-max({0,3,2,1}(L4=L4(1
			If not(5=Ans>2 and L4(2)=4 and L4(3
			Then
				0->L4(Ans
				2L4(1->L4(1
				C+Ans->C
			End
		End
		If L4(2:Then
			5-max({0,0,2,1}(L4=L4(2
			If not(5=Ans=4 and L4(3
			Then
				0->L4(Ans
				2L4(2->L4(2
				C+Ans->C
			End
		End
		L4(3
		If Ans and Ans=L4(4:Then
			2Ans->L4(3
			C+Ans->C
			0->L4(4
		End
		If L3(1:Then
			5-max({0,3,2,1}(L3=L3(1
			If not(5=Ans>2 and L3(2)=4 and L3(3
			Then
				0->L3(Ans
				2L3(1->L3(1
				C+Ans->C
			End
		End
		If L3(2:Then
			5-max({0,0,2,1}(L3=L3(2
			If not(5=Ans=4 and L3(3
			Then
				0->L3(Ans
				2L3(2->L3(2
				C+Ans->C
			End
		End
		L3(3
		If Ans and Ans=L3(4:Then
			2Ans->L3(3
			C+Ans->C
			0->L3(4
		End
		{4,3,2,1}not(not(L6->L2
		SortD(L2,L6
		{4,3,2,1}not(not(L5->L2
		SortD(L2,L5
		{4,3,2,1}not(not(L4->L2
		SortD(L2,L4
		{4,3,2,1}not(not(L3->L2
		SortD(L2,L3
		List>matr(L6,L5,L4,L3,[A]
		[A]
		If 4=abs(K-30
		Then
		rowSwap(Ans,1,4:rowSwap(Ans,2,3:End
		If 1=abs(K-25
		Ans^^-1
		Matr>list(Ans,L6,L5,L4,L3
		Ans->[A]
		LAnot(augment(L6,augment(L5,augment(L4,L3->L1
		SortD(L1
	End
End
max(LT48,{C->LT48
Disp "Game Over","Score:",C,"Best:",max(Ans
DelVar [A]DelVar [B]DelVar LBDelVar LAArchive LT48
