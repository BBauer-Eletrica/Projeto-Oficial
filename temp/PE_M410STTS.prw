// #########################################################################################
// Projeto: BBauer
// Modulo :
// Fonte  : PE_M410STTS.prw
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/09/16 | Gerson Belini     | Ponto-de-entrada para validacao de pedidos de vendas
// ---------+-------------------+-----------------------------------------------------------

#Include 'Protheus.ch'

User Function M410STTS()
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
	
	_cPedido    := SC5->C5_NUM
	_lBlqCom    := iif(SC5->C5_BLQCOM == "S",.T.,.F.)
	_nMaiorDesc := 0
	// Verificar se o pedido ficou com bloqueio comercial na inclusão / Alteração
	if Inclui .or. Altera
		if _lBlqCom // Verificar níveis de aprovação do pedido de venda
			DbSelectArea("SC6")
			DbSetOrder(1)
			DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)
			While !Eof() .and. SC5->C5_FILIAL == SC6->C6_FILIAL .and. SC5->C5_NUM == SC6->C6_NUM
				if SC6->C6_ZPERDES > _nMaiorDesc
					_nMaiorDesc := SC6->C6_ZPERDES
				endif
				DbSelectArea("SC6")
				DbSkip()
			End
			VerAprova(_nMaiorDesc)

		endif
		
	endif


Return(_lRet)

Static Function VerAprova(_nMaiorDesc)

	Local _cProcApr := SuperGetMV("CL_APRPV",.T.,"PEDVENDA")+Space(TamSX3("Z04_PROCES")[1]-Len(AllTrim(SuperGetMV("CL_APRPV",.T.,"PEDVENDA")))) // Deixar o processo com 10 posições para pesquisa
	Local _cAprGer  := SuperGetMV("CL_APRGR",.T.,"000021")

	// Verificar se existe o documento na tabela de aprovação
	DbSelectArea("Z04")
	DbSetOrder(1)
	DbSeek(xFilial("Z04")+_cProcApr+SC5->C5_FILIAL+SC5->C5_NUM)
	While !Eof() .and. Z04->Z04_FILIAL == xFilial("Z04") .and. AllTrim(Z04->Z04_PROCES) == AllTrim(_cProcApr) .and. AllTrim(Z04->Z04_DOCUME) == AllTrim(SC5->C5_FILIAL+SC5->C5_NUM)
		RecLock("Z04",.F.)
		DbDelete()
		MsUnLock()
		DbSelectArea("Z04")
		DbSkip()
	End
	// Verificar se existe alçada de aprovação para o processo
	DbSelectArea("Z03")
	DbSetOrder(1)
	DbSeek(xFilial("Z03")+AllTrim(_cProcApr))
	_nOrder := 0
	_lProcCad := .F.
	While !Eof() .and. Z03->Z03_FILIAL == xFilial("Z03") .and. AllTrim(Z03->Z03_PROCES) == AllTrim(_cProcApr)
		_lProcCad := .T.
		// Verificar se o aprovador é o mesmo que o digitador do pedido, em caso positivo, não enviar para este aprovador
		if AllTrim(Z03->Z03_APROVA) == AllTrim(RetCodUsr())
			DbSelectArea("Z03")
			DbSkip()
			Loop
		endif
		if Z03->Z03_VALOR <= _nMaiorDesc
			_nOrder ++
			// Criar registro na tabela Z04
			RecLock("Z04",.T.)
			Z04->Z04_FILIAL := xFilial("Z04")
			Z04->Z04_PROCES := AllTrim(_cProcApr)
			Z04->Z04_DOCUME := SC5->C5_FILIAL+SC5->C5_NUM
			Z04->Z04_ORDAPR := StrZero(_nOrder,3) 
			Z04->Z04_APROVA := Z03->Z03_APROVA
			Z04->Z04_DTACAO := Date()
			Z04->Z04_HORACA := Time()
			Z04->Z04_RESULT := "N"
			Z04->Z04_OBSC   := "Inclusao de registro de aprovacao"
			Z04->Z04_MAILAP := ""
			Z04->Z04_ACAO   := "0"
			Z04->Z04_STATUS := iif(_nOrder==1,"A","")
			Z04->Z04_MOTREJ := ""
			Z04->Z04_NOME   := ""
			Z04->Z04_IPMAQ  := ""
			Z04->Z04_NLOGIN := ""
			Z04->Z04_NMAQ   := ""
//			Z04->Z04_MSFIL  := cFilAnt

			// Criar registro na tabela Z04
			RecLock("Z04",.T.)
			Z04->Z04_FILIAL := xFilial("Z04")
			Z04->Z04_PROCES := AllTrim(_cProcApr)
			Z04->Z04_DOCUME := SC5->C5_FILIAL+SC5->C5_NUM
			Z04->Z04_ORDAPR := StrZero(_nOrder,3) 
			Z04->Z04_APROVA := Z03->Z03_APROVA
			Z04->Z04_DTACAO := stod("")
			Z04->Z04_HORACA := ""
			Z04->Z04_RESULT := "N"
			Z04->Z04_OBSC   := "Registro de envio para aprovação"
			Z04->Z04_MAILAP := ""
			Z04->Z04_ACAO   := "1"
			Z04->Z04_STATUS := iif(_nOrder==1,"A","")
			Z04->Z04_MOTREJ := ""
			Z04->Z04_NOME   := ""
			Z04->Z04_IPMAQ  := ""
			Z04->Z04_NLOGIN := ""
			Z04->Z04_NMAQ   := ""
//			Z04->Z04_MSFIL  := cFilAnt

			MsUnLock("Z04")
		endif
		DbSelectArea("Z03")
		DbSkip()
	End
	// Verificar se foi enviado pelo menos para um aprovador, caso contrário utilizar um aprovador responsável
	// Pedido ficará bloqueado até existir cadastro para o processo
	if _nOrder == 0
		if _lProcCad
			RecLock("SC5",.F.)
			SC5->C5_BLQCOM := " "
			MsUnLock("SC5")
		else
			MsgInfo("Processo de aprovação não encontrado, pedido bloqueado até que o cadastro do processo de aprovação seja feito")
		endif
		
		/*
			_nOrder ++
			// Criar registro na tabela Z04
			RecLock("Z04",.T.)
			Z04->Z04_FILIAL := xFilial("Z04")
			Z04->Z04_PROCES := AllTrim(_cProcApr)
			Z04->Z04_DOCUME := SC5->C5_FILIAL+SC5->C5_NUM
			Z04->Z04_ORDAPR := StrZero(_nOrder,3) 
			Z04->Z04_APROVA := _cAprGer
			Z04->Z04_DTACAO := Date()
			Z04->Z04_HORACA := Time()
			Z04->Z04_RESULT := "N"
			Z04->Z04_OBSC   := "Inclusao de registro de aprovacao"
			Z04->Z04_MAILAP := ""
			Z04->Z04_ACAO   := "0"
			Z04->Z04_STATUS := "A"
			Z04->Z04_MOTREJ := ""
			Z04->Z04_NOME   := ""
			Z04->Z04_IPMAQ  := ""
			Z04->Z04_NLOGIN := ""
			Z04->Z04_NMAQ   := ""
//			Z04->Z04_MSFIL  := cFilAnt

			// Criar registro na tabela Z04
			RecLock("Z04",.T.)
			Z04->Z04_FILIAL := xFilial("Z04")
			Z04->Z04_PROCES := AllTrim(_cProcApr)
			Z04->Z04_DOCUME := SC5->C5_FILIAL+SC5->C5_NUM
			Z04->Z04_ORDAPR := StrZero(_nOrder,3) 
			Z04->Z04_APROVA := _cAprGer
			Z04->Z04_DTACAO := stod("")
			Z04->Z04_HORACA := ""
			Z04->Z04_RESULT := "N"
			Z04->Z04_OBSC   := "Registro de envio para aprovação"
			Z04->Z04_MAILAP := ""
			Z04->Z04_ACAO   := "1"
			Z04->Z04_STATUS := "A"
			Z04->Z04_MOTREJ := ""
			Z04->Z04_NOME   := ""
			Z04->Z04_IPMAQ  := ""
			Z04->Z04_NLOGIN := ""
			Z04->Z04_NMAQ   := ""
//			Z04->Z04_MSFIL  := cFilAnt

			MsUnLock("Z04")
			*/

	endif
Return