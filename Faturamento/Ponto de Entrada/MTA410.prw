#include 'protheus.ch'
#include 'parmtype.ch'
#include 'TOPCONN.CH'

/*====================================================================================\
|Programa  | MT410INC         | Autor | Leonardo Espinosa          | Data | 07/04/2018|
|=====================================================================================|
|Descrição | Função utilizada para validação TUDOOK do Pedido de Venda			      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico BBauer	                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User function MTA410()
Local	aArea		:= GetArea( )
Local	aAreaC5		:= SC5->(GetArea( ))

Local	cAlias		:= GetNextAlias( )
Local	cNoRef		:= SuperGetMV("BB_NOSC5",,"000000")
Local	cLastOrder	:= ""

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
		cLastOrder	:= (cAlias)->C5_NUM
	EndIf
	(cAlias)->(DBCloseArea())
	
	Do Case
		Case !Empty(cLastOrder) .AND. cLastOrder == cNoRef
			M->C5_NUM := SOMA1(cNoRef)
	
		Case !Empty(cLastOrder) .AND. cLastOrder > cNoRef
			M->C5_NUM := SOMA1(cLastOrder)
	
		Otherwise
			M->C5_NUM := SOMA1(cNoRef)
			
	End Case
	
	MsgInfo("Pedido "+M->C5_NUM+" gerado com sucesso!" )
	
	PutMV("BB_NOSC5",M->C5_NUM )

RestArea(aArea	)
RestArea(aAreaC5)

Return .T.