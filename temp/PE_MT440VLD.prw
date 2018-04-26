// #########################################################################################
// Projeto: BBauer
// Modulo :
// Fonte  : PE_MT440VLD.prw
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/09/16 | Gerson Belini     | Ponto-de-entrada para validacao de pedidos de vendas
// ---------+-------------------+-----------------------------------------------------------

#Include 'Protheus.ch'

User Function MT440VLD()
	Local _lRet
	Local _aAreaVld := GetArea()
	
	_lRet := .F.
	DbSelectArea("SC5")
	DbsetOrder(1)
	DbSeek(SC6->C6_FILIAL+SC6->C6_NUM)
	if Empty(SC5->C5_BLQCOM) .or.  AllTrim(SC5->C5_BLQCOM) $ " ##A" //Vazio ou A=Aprovado
		_lRet := .T.
	elseif AllTrim(SC5->C5_BLQCOM) == "R"
		MsgStop("Pedido de venda reprovado comercialmente")
		_lRet := .F.
	elseif AllTrim(SC5->C5_BLQCOM) == "S"
		MsgStop("Pedido de venda em processo de aprovação")
		_lRet := .F.
	endif
	RestArea(_aAreaVld)
Return(_lRet)