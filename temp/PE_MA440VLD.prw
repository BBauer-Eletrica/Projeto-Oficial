// #########################################################################################
// Projeto: BBauer
// Modulo :
// Fonte  : PE_MA440VLD.prw
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/09/16 | Gerson Belini     | Ponto-de-entrada para validacao de pedidos de vendas
// ---------+-------------------+-----------------------------------------------------------

#Include 'Protheus.ch'

User Function MA440VLD()
	Local _lRet
	
	_lRet := .F.
	if Empty(SC5->C5_BLQCOM) .or. AllTrim(SC5->C5_BLQCOM) $ " ##A" //Vazio ou A=Aprovado
		_lRet := .T.
	elseif AllTrim(SC5->C5_BLQCOM) == "R"
		MsgStop("Pedido de venda reprovado comercialmente")
		_lRet := .F.
	elseif AllTrim(SC5->C5_BLQCOM) == "S"
		MsgStop("Pedido de venda em processo de aprovação")
		_lRet := .F.
	endif
Return(_lRet)