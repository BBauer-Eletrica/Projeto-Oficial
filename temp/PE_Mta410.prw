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
	Local _lBlqCom // Determina se o pedido deve ter bloqueio para aprovacao
	Local _nMaiorDesc

	_aFaixas := {}
	_lRet    := .T.
	_lBlqCom := .F.
	// Calcular o desconto aplicado ao item do pedido de venda
	// Guardar o percentual de comiss�o padr�o recebido do produto
	// Se houver varia��o no percentual, deduzir da comiss�o padr�o do produto
	// Emitir aviso se o pedido que estiver sendo alterado, j� possuir itens liberados, com percentuais de comiss�es, diferentes das calculadas
	_nPosItem   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ITEM"   })
	_nPosPro    := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_PRODUTO" })
	_nPosQuant  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_QTDVEN"  })
	_nPosQLib   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_QTDLIB"  })
	_nPosQEmp   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_QTDEMP"  })
	_nPosPLis   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_PRUNIT"  })
	_nPosPVen   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_PRCVEN"  })
	_nPosCo1    := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS1"  })
	_nPosCo2    := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS2"  })
	_nPosCo3    := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS3"  })
	_nPosCo4    := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS4"  })
	_nPosCo5    := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_COMIS5"  })
	_nPosPTab   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZPRTAB"  })
	_nPosPDes   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZPERDES" })
	_nPosRcom   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZREDCOM" })
	_nPosPCom   := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C6_ZPERCOM" })
	_nMaiorDesc := 0
	// Verificar se os vendedores do pedido, n�o est�o bloqueados
	if !(m->C5_TIPO $ "BD")
		if !Empty(M->C5_VEND1)
			DbSelectArea("SA3")
			DbSetOrder(1)
			if DbSeek(xFilial("SA3")+M->C5_VEND1) .and. SA3->A3_MSBLQL == "1"
				MsgInfo("VENDEDOR: "+M->C5_VEND1+" - "+AllTrim(SA3->A3_NOME)+" ESTA BLOQUEADO PARA USO!!!")
				Return(.F.)
			endif
		endif
		if !Empty(M->C5_VEND2)
			DbSelectArea("SA3")
			DbSetOrder(1)
			if DbSeek(xFilial("SA3")+M->C5_VEND2) .and. SA3->A3_MSBLQL == "1"
				MsgInfo("VENDEDOR: "+M->C5_VEND2+" - "+AllTrim(SA3->A3_NOME)+" ESTA BLOQUEADO PARA USO!!!")
				Return(.F.)
			endif
		endif
	endif
	// Verificar se vendedor tem comiss�o
	DbSelectArea("SA3")
	DbSetOrder(1)
	DbSeek(xFilial("SA3")+M->C5_VEND1)
	// Validar preco de vendas, somente para pedidos do tipo normal
	if (Inclui .or. Altera) .and. M->C5_TIPO == 'N'
		if SA3->A3_ZCALCOM == "S" .and. Empty(SA3->A3_ZTBREDC)
			MsfInfo(OemToAnsi("Tabela de Descontos n�o encontrada no cadastro de vendedor!!!",'Verificar campo "Tab.Red.Com."'))
		endif
		For _nCount := 1 to Len(aCols)
			_lDeletado := .F.
			If aCols[_nCount,Len(aHeader)+1] == .T. // Verifica se o item esta marcado para exclusao
				_lDeletado := .T.
			EndIf
			if !_lDeletado
				if SA3->A3_ZCALCOM != "S" // Se n�o houver c�lculo de comiss�o os percentuais ser�o zerados
					aCols[_nCount][_nPosPCom]  := 0
					aCols[_nCount][_nPosCo1]   := 0
					aCols[_nCount][_nPosCo2]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo3]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo4]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo5]   := aCols[_nCount][_nPosCo1]
				elseif SA3->A3_ZCALCOM == "S"// Ajustar o percentual de comiss�o
					DbSelectArea("SB1")
					DbSetOrder(1)
					DbSeek(xFilial("SB1")+aCols[_nCount][_nPosPro])
					aCols[_nCount][_nPosPCom]  := SB1->B1_COMIS
					aCols[_nCount][_nPosCo1]   := SB1->B1_COMIS
					// Percentual de comiss�o do vendedor 2 sempres ser� fixo, pelo pedido
					aCols[_nCount][_nPosCo2]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo2]   := 0
					aCols[_nCount][_nPosCo3]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo4]   := aCols[_nCount][_nPosCo1]
					aCols[_nCount][_nPosCo5]   := aCols[_nCount][_nPosCo1]
				endif
				if Empty(m->C5_TABELA)
					//MsgStop(OemToAnsi("Tabela de pre�o n�o digitada"),"Falta Tabela de Pre�o")
					//_lRet := .F.
				else
					if aCols[_nCount][_nPosPLis] != 0 .and. aCols[_nCount][_nPosPLis] != aCols[_nCount][_nPosPTab]
						aCols[_nCount][_nPosPTab] := aCols[_nCount][_nPosPLis]
					endif
					// Zerar sempre o pre�o para n�o atribuir descontos ao pedido
					aCols[_nCount][_nPosPLis] := 0
					// Calcular o percentual de desconto do item do pedido
					if aCols[_nCount][_nPosPTab] != 0
						aCols[_nCount][_nPosPDes] := Round( ( ( 1 - ( aCols[_nCount][_nPosPVen] / aCols[_nCount][_nPosPTab] )  ) * 100  ) , TamSx3("C6_ZPERDES")[2] )// Para Valores positivos, vendas com desconto, para valores negativos, vendas com acrescimo
						// Se houve desconto no pedido de venda verificar se ser� enviado para aprova��o
						if aCols[_nCount][_nPosPDes] > 0 .and. aCols[_nCount][_nPosPDes] > _nMaiorDesc
							_nMaiorDesc := aCols[_nCount][_nPosPDes]
							_lBlqCom := .T.
						endif
					endif
					if aCols[_nCount][_nPosPDes] > 0 // Se houve desconto verificar na tabela de redu��o de percentual de comissoes
						if Len(_aFaixas) == 0 // Se o array de faixas de descontos estiver vazio, preencher com os dados
							DbSelectArea("Z01")
							DbSetOrder(1)
							DbSeek(xFilial("Z01")+SA3->A3_ZTBREDC)
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
						// Se for alteracao, verificar se o percentual de comissao � diferente do item e recalcular
						if Altera .and. aCols[_nCount][_nPosPCom] != 0
							aCols[_nCount][_nPosCo1] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo2] := 0
//							aCols[_nCount][_nPosCo2] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo3] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo4] := aCols[_nCount][_nPosPCom]
							aCols[_nCount][_nPosCo5] := aCols[_nCount][_nPosPCom]
						endif
						aCols[_nCount][_nPosRcom]  := _nDesconto
						if SA3->A3_ZCALCOM == "S" // Se n�o houver c�lculo de comiss�o os percentuais ser�o zerados
							aCols[_nCount][_nPosPCom]  := aCols[_nCount][_nPosCo1]
						else
							aCols[_nCount][_nPosPCom]  := 0
							aCols[_nCount][_nPosCo1]   := 0
						endif
						aCols[_nCount][_nPosCo1]   := Round( ( aCols[_nCount][_nPosCo1] - Round( ( aCols[_nCount][_nPosCo1] * ( aCols[_nCount][_nPosRcom] / 100 ) ) , 2 ) ) , 2 )
//						aCols[_nCount][_nPosCo2]   := aCols[_nCount][_nPosCo1]
						aCols[_nCount][_nPosCo2]   := 0
						aCols[_nCount][_nPosCo3]   := aCols[_nCount][_nPosCo1]
						aCols[_nCount][_nPosCo4]   := aCols[_nCount][_nPosCo1]
						aCols[_nCount][_nPosCo5]   := aCols[_nCount][_nPosCo1]
					endif
					// Verificar se existe bloqueio comercial e quantidade liberada maior que zero
					if _lBlqCom .and. aCols[_nCount][_nPosQLib] != 0
						MsgStop("Pedido com bloqueio comercial, n�o permitida a libera��o de quantidade!!!")
						_lRet := .F.
					endif
				endif
			endif
		Next _nCount
	endif
	if _lBlqCom
		m->C5_BLQCOM := "S"
	endif
Return(_lRet)
