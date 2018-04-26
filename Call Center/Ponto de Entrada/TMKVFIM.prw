#Include "Totvs.ch"

/*==========================================================================
Funcao...........:	TMKVFIM
Descricao........:	Ponto de Entrada na Confirmacao do Atendimento
Autor............:	Amedeo D. Paoli
Parametros.......:	Nil
Retorno..........:	Nil
==========================================================================*/
User Function TMKVFIM()
	Local aAreaUA	:= SUA->(GetArea())
	Local aAreaC5	:= SC5->(GetArea())
	Local aAreaAT	:= GetArea()
	
	// Faturamento (Orcamento - Pedido de Venda)
	If SUA->UA_OPER == "1"
		
		Dbselectarea("SC5")
		SC5->(DbSetorder(1))
		If SC5->(Dbseek(xFilial("SC5") + SUA->UA_NUMSC5))
			SC5->(Reclock("SC5",.F.))
				SC5->C5_VOLUME1	:= SUA->UA_XVOLUME
				SC5->C5_ESPECI1	:= SUA->UA_XESPECI
				SC5->C5_XOBS	:= MSMM(SUA->UA_CODOBS,43)
			SC5->(MSUNLOCK())
		EndIf
	
	EndIf
	
	RestArea(aAreaUA)
	RestArea(aAreaC5)
	RestArea(aAreaAT)

Return Nil
