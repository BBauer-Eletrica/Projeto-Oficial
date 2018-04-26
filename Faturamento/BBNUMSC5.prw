#include 'protheus.ch'
#include 'parmtype.ch'

User function BBNUMSC5()
Local	aArea	:= GetArea( )	

Local	cAlias		:= GetNextAlias( )

BeginSQL Alias cAlias
	SELECT
		MAX(C5_NUM) C5_NUM
	FROM
		%Table:SC5% SC5 (NOLOCK)
	WHERE
		C5_FILIAL = %xFilial:SC5%	AND
		SC5.%NotDel%
	
EndSQL
	
DBSelectArea(cAlias)
If !EOF( )
	cOrder	:= AllTrim(SOMA1((cAlias)->C5_NUM))
//Else
	//cOrder	:= GetSXENum("SC5","C5_NUM")
EndIf
(cAlias)->(DBCloseArea())

RestArea(aArea)
Return cOrder