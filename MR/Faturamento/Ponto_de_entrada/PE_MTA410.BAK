// #########################################################################################
// Projeto: BBauer
// Modulo :
// Fonte  : PE_Mta410.prw
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/09/16 | Gerson Belini     | Ponto-de-entrada para validacao de pedidos de vendas
// ---------+-------------------+-----------------------------------------------------------

#Include 'Protheus.ch'


User Function Mta410()
	Local _lRet
	Local _nPosItem
	Local _nPosPorduto
	Local _nPosQuant
	Local _nPosQtdLib
	Local _nPosCo1
	Local _nPosPrunit
	Local _nPosPrcTab
	Local _nPosPerdes
	Local _nPosRcom
	Local _nPosPCom
	Local _lDeletado
	Local _aFaixas


	_aFaixas := {}
	_lRet := .T.
// Calcular o desconto aplicado ao item do pedido de venda
// Guardar o percentual de comissão padrão recebido do produto
// Se houver variação no percentual, deduzir da comissão padrão do produto
// Emitir aviso se o pedido que estiver sendo alterado, já possuir itens liberados, com percentuais de comissões, diferentes das calculadas
	_nPosItem  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ITEM"   })
	_nPosPro   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_PRODUTO"})
	_nPosQuant := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_QTDVEN" })
	_nPosQLib  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_QTDLIB" })
	_nPosPLis  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_PRUNIT" })
	_nPosPVen  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_PRCVEN" })
	_nPosCo1   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS1" })
	_nPosCo2   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS2" })
	_nPosCo3   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS3" })
	_nPosCo4   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS4" })
	_nPosCo5   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS5" })
	_nPosPTab  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZPRTAB" })
	_nPosPDes  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZPERDES" })
	_nPosRcom  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZREDCOM" })
	_nPosPCom  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZPERCOM" })
	// Verificar se vendedor tem comissão
	DbSelectArea("SA3")
	DbSetOrder(1)
	DbSeek(xFilial("SA3")+M->C5_VEND1)
// Validar preco de vendas, somente para pedidos do tipo normal
	if (Inclui .or. Altera) .and. M->C5_TIPO == 'N'
		if SA3->A3_ZCALCOM == "S" .and. Empty(SA3->A3_ZTBREDC)
			MsfInfo(OemToAnsi("Tabela de Descontos não encontrada no cadastro de vendedor!!!",'Verificar campo "Tab.Red.Com."'))
		endif
		For _nCount := 1 to Len(aCols)
			_lDeletado := .F.
			If aCols[_nCount,Len(aHeader)+1] == .T. // Verifica se o item esta marcado para exclusao
				_lDeletado := .T.
			EndIf
			if !_lDeletado
				if SA3->A3_ZCALCOM != "S" // Se não houver cálculo de comissão os percentuais serão zerados
					aCols[_nCount][_nPosPCom]  := 0
					aCols[_nCount][_nPosCo1]   := 0
					aCols[_nCount][_nPosCo2]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo3]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo4]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo5]   := aCols[_nCount][_nPosCo1]
				endif
				if Empty(m->C5_TABELA)
					MsgStop(OemToAnsi("Tabela de preço não digitada"),"Falta Tabela de Preço")
					//_lRet := .F.
				else
					if aCols[_nCount][_nPosPLis] != 0 .and. aCols[_nCount][_nPosPLis] != aCols[_nCount][_nPosPTab]
						aCols[_nCount][_nPosPTab] := aCols[_nCount][_nPosPLis]
					endif
					// Zerar sempre o preço para não atribuir descontos ao pedido
					aCols[_nCount][_nPosPLis] := 0
					// Calcular o percentual de desconto do item do pedido
					if aCols[_nCount][_nPosPTab] != 0  
						aCols[_nCount][_nPosPDes] := Round( ( ( 1 - ( aCols[_nCount][_nPosPVen] / aCols[_nCount][_nPosPTab] )  ) * 100  ) , TamSx3("C6_ZPERDES")[2] )// Para Valores positivos, vendas com desconto, para valores negativos, vendas com acrescimo 
					endif
					if aCols[_nCount][_nPosPDes] > 0 // Se houve desconto verificar na tabela de redução de percentual de comissoes
						if Len(_aFaixas) == 0 // Se o array de faixas de descontos estiver vazio, preencher com os dados
							DbSelectArea("Z01")
							DbSetOrder(1)
							DbSetSeek(xFilial("Z01")+SA3->A3_ZTBREDC)
							While !Eof() .and. SA3->A3_ZTBREDC == Z01->Z01_CODIGO
								aadd(_aFaixas,{Z01->Z01_FXINI,Z01->Z01_FXFIM,Z01->Z01_PERRED})
								DbSkip()
							End
						endif
						// Identificar em qual faixa de se encontra o item 
						_nDesconto := 0
						For _nCtDes := 1 to Len(_aFaixas)
							if _aFaixas[_nCtDes][1] <= aCols[_nCount][_nPosPDes] .and. _aFaixas[_nCtDes][2] > aCols[_nCount][_nPosPDes]
								_nDesconto := _aFaixas[_nCtDes][3]
							endif
						Next _nCtDes
						// Se for alteracao, verificar se o percentual de comissao é diferente do item e recalcular
						if Altera .and. aCols[_nCount][_nPosPCom] != 0
							aCols[_nCount][_nPosCo1] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo2] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo3] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo4] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo5] := aCols[_nCount][_nPosPCom]
						endif
						aCols[_nCount][_nPosRcom]  := _nDesconto
						if SA3->A3_ZCALCOM == "S" // Se não houver cálculo de comissão os percentuais serão zerados
							aCols[_nCount][_nPosPCom]  := aCols[_nCount][_nPosCo1]
						else
							aCols[_nCount][_nPosPCom]  := 0
							aCols[_nCount][_nPosCo1]   := 0
						endif
						aCols[_nCount][_nPosCo1]   := Round( ( aCols[_nCount][_nPosCo1] - Round( ( aCols[_nCount][_nPosCo1] * ( aCols[_nCount][_nPosRcom] / 100 ) ) , 2 ) ) , 2 )
						aCols[_nCount][_nPosCo2]   := aCols[_nCount][_nPosCo1]
						aCols[_nCount][_nPosCo3]   := aCols[_nCount][_nPosCo1]
						aCols[_nCount][_nPosCo4]   := aCols[_nCount][_nPosCo1]
						aCols[_nCount][_nPosCo5]   := aCols[_nCount][_nPosCo1]
					endif
				endif
			endif
		Next _nCount
	endif
Return(_lRet)

