#Include "Totvs.ch"

/*==========================================================================
 Funcao...........:	TK271ROTM
 Descricao........:	Ponto de entrada para adicionar botao na tela do
 					TeleVendas
 Autor............:	Fabrica de Software (Fabritech)
 Parametros.......:	Nil
 Retorno..........:	Nil
==========================================================================*/
User Function TK271ROTM()
	Local aRetorno	:= {}
	
	Aadd(aRetorno, { "Impressão Gráfica"	, "U_TMKR3A( SUA->UA_NUM )"	, 0, 7})

Return aRetorno
