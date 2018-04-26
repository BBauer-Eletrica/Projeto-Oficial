#Include "protheus.ch"     

#DEFINE DMPAPER_A4	9

/*==========================================================================
 Funcao...........:	PEDCOMP
 Descricao........:	Pedido de Compra grafico
 Autor............:	Amedeo D. Paoli 	
 Parametros.......:	Nil
 Retorno..........:	Nil
==========================================================================*/
User Function PEDCOMP()
	Local aArea	:= GetArea()

	MsAguarde({|lEnd| IMPRIME()},"","Aguarde, Gerando pedido de Compras gráico",.F.)

	RestArea(aArea)
	
Return Nil

Static Function IMPRIME()
	Local aDescri	:= {}
	Local nX		:= 0
	Local cUM		:= ""
	Local nQuant	:= 0
	Local nPreco	:= 0
			
	Private oFont0	:= TFont():New("Times New Roman",,020,,.T.,,,,,.F.,.F.)
	Private oFont1	:= TFont():New("Arial",,010,,.T.,,,,,.F.,.F.)
	Private oFont1A	:= TFont():New("Arial",,009,,.T.,,,,,.F.,.F.)
	Private oFont2	:= TFont():New("Arial",,010,,.T.,,,,,.F.,.F.)
	Private oFont3	:= TFont():New("Times New Roman",,010,,.F.,,,,,.F.,.F.)
	Private oFont4	:= TFont():New("Times New Roman",,008,,.F.,,,,,.F.,.F.)
	Private oFont5	:= TFont():New("Times New Roman",,007,,.F.,,,,,.F.,.F.)
	
	Private nLin		:= 8000
	Private nMaxLin		:= 1400
	Private nPagina		:= 0
	Private lPrimeira	:= .T.

	Private cPedido		:= SC7->C7_NUM
	Private cMoeda		:= ""
	Private cFornece	:= ""
	Private cLojaFor	:= ""
	Private cCondPag	:= ""
	Private dEmissao	:= CtoD("")
	Private cContato	:= ""
	Private cComprador	:= ""
	Private cNatureza	:= ""
	Private cTpFrete	:= ""
	Private cVias		:= ""
	Private nTxMoeda	:= 0
	
	oPrint := TMSPrinter():New()
	oPrint:SetLandscape()
	oPrint:SetPaperSize(9)
	oPrint:StartPage()
	oPrint:Setup()

	DbSelectarea("SC7")
	SC7->(DbSetorder(1))
	If SC7->(Dbseek(xFilial("SC7") + cPedido))

		cMoeda 		:= SuperGetMv("MV_MOEDA"+AllTrim(Str(Max(SC7->C7_MOEDA,1),2)))
		nTxMoeda	:= SC7->C7_TXMOEDA
		cFornece	:= SC7->C7_FORNECE
		cLojaFor	:= SC7->C7_LOJA
		cCondPag	:= SC7->C7_COND
		dEmissao	:= SC7->C7_EMISSAO
		cContato	:= SC7->C7_CONTATO
		cNatureza	:= ""
		cVias		:= IIf(SC7->C7_QTDREEM > 0, + "  /  " + Str(SC7->C7_QTDREEM+1,2) + "a.Emissao","")
		
		If SC7->C7_TPFRETE == "C"
			cTpFrete	:= "CIF"
		ElseIf SC7->C7_TPFRETE == "F"
			cTpFrete	:= "FOB"
		ElseIf SC7->C7_TPFRETE == "T"
			cTpFrete	:= "TERCEIROS"
		ElseIf SC7->C7_TPFRETE == "S"
			cTpFrete	:= "SEM FRETE"
		Else
			cTpFrete	:= "CIF"
		EndIf
		
		PswOrder(1)
		If PswSeek( SC7->C7_USER )
			cComprador := Alltrim(PswRet(1)[1][4])
		EndIf

		While !SC7->(EOF()) .And. 	SC7->C7_FILIAL == xFilial("SC7") .And.;
									SC7->C7_NUM == cPedido
			If nLin > nMaxLin
				If lPrimeira
					ImpCabec()
				Else
					ImpCabec2()
				EndIf
			EndIf
			
			cUM		:= SC7->C7_UM
			nQuant	:= SC7->C7_QUANT
			nPreco	:= SC7->C7_PRECO
			
			oPrint:Say(nLin,0070,SC7->C7_ITEM										, oFont4)	//Item
			oPrint:Say(nLin,0220,SC7->C7_PRODUTO									, oFont4)	//Codigo
			oPrint:Say(nLin,1435,cUM												, oFont4)	//UM
			oPrint:Say(nLin,1580,Transform(nQuant, PesqPictQt("C7_QUANT"))			, oFont4)	//Quantidade
			oPrint:Say(nLin,1900,Transform(nPreco, PesqPictQt("C7_PRECO"))			, oFont4)	//Valor Unitario
			oPrint:Say(nLin,2110,IIF( Empty(SC7->C7_CODTAB), "Não", "Sim" )			, oFont4)	//Tabela
			oPrint:Say(nLin,2320,Transform(SC7->C7_IPI, "99.99%")					, oFont4)	//IPI
			oPrint:Say(nLin,2600,Transform(SC7->C7_TOTAL, PesqPictQt("C7_TOTAL"))	, oFont4)	//Valor Total
			oPrint:Say(nLin,2860,DtoC(SC7->C7_DATPRF)								, oFont4)	//Entrega
			oPrint:Say(nLin,3110,SC7->C7_CC											, oFont4)	//CC
			oPrint:Say(nLin,3210,SC7->C7_NUMSC										, oFont4)	//SC
			
			DbSelectarea("SB1")
			SB1->(DbSetorder(1))
			DbSeek(xFilial("SB1") + SC7->C7_PRODUTO)
			
			//Descricao em formato Array para nao estourar a Grade
			aDescri	:= GeraDesc( Alltrim(SB1->B1_DESC), 55 )
			
			For nX	:= 1 To Len(aDescri)

				oPrint:Say(nLin,0510,aDescri[nX], oFont4)	//Descricao

				IIF(Len(aDescri) <> nX, nLin := nLin + 50, .F.)

				If nLin > nMaxLin
					If lPrimeira
						ImpCabec()
					Else
						ImpCabec2()
					EndIf
				EndIf

			Next nX

			nLin := nLin + 50
			
			SC7->(DbSkip())

		Enddo

	EndIF

	oPrint:Preview()

Return Nil

//===============================================
// Function IMPCABEC - Cabecalho da Pagina
//===============================================
Static Function ImpCabec()
	Local nTotMerc	:= 0
	Local nTotImp	:= 0
	Local nIpi		:= 0
	Local nFrete	:= 0
	Local nGrupo	:= 0
	Local nICMS		:= 0
	Local nDesconto	:= 0
	Local nDespesa	:= 0
	Local nSeguro	:= 0
	Local nTotGer	:= 0
	Local cObserva1	:= ""
	Local aObserva	:= {}
  	Local cLogo		:= FisxLogo("1")
  	Local aAreaC7	:= SC7->(GetArea())
  	Local aAreaA5	:= SA5->(GetArea())
	Local nX		:= 0
	Local nLiObs	:= 1670
	lPrimeira 		:= .F.
	
	nPagina ++

	nLin 	:= 550
	
	oPrint:SayBitmap(0170,0050,cLogo,400,250)
	
	oPrint:Box(0100,0050,0500,3300)		//Box Superior
	oPrint:Box(0500,0050,0550,3300)		//Box do cabecalho dos Itens
	oPrint:Box(0550,0050,1450,3300)		//Box Ate local de Entrega
	oPrint:Box(1450,0050,1500,3300)		//Box Local de Cobranca
	oPrint:Box(1500,0050,1600,3300)		//Box condicao de Pagamento
	oPrint:Box(1600,0050,2000,3300)		//Box Observacoes
	oPrint:Box(2000,0050,2200,3300)		//Box Assinaturas

	oPrint:Line(0100,0500,0500,0500)	//Linha do Logo
	oPrint:Line(0100,1400,0550,1400)	//Linha do Nome da Empresa
	oPrint:Line(0250,1400,0250,3300)	//Linha do Pedido de Compras
	oPrint:Line(0100,2800,0250,2800)	//Linha da Moeda
	oPrint:Line(0100,3050,0250,3050)	//Linha do Nro. do Pedido
	
	oPrint:Line(0500,0200,1450,0200)	//Linha do Item
	oPrint:Line(0500,0500,1500,0500)	//Linha do Codigo
	oPrint:Line(0500,1400,1450,1400)	//Linha da Descricao
	oPrint:Line(0500,1550,1450,1550)	//Linha da UM
	oPrint:Line(0500,1750,1450,1750)	//Linha da Quantidade
	oPrint:Line(0500,2070,1450,2070)	//Linha do Valor Unitario
	oPrint:Line(0500,2200,1450,2200)	//Linha da tabela
	oPrint:Line(0500,2500,1450,2500)	//Linha do Valor IPI
	oPrint:Line(0500,2780,1450,2780)	//Linha do Valor Total Mercadoria
	oPrint:Line(0500,3050,1450,3050)	//Linha da Entrega
	oPrint:Line(0500,3200,1450,3200)	//Linha da CC

	oPrint:Line(1550,1750,1550,3300)	//Linha divisoria total das Mercadorias / Impostos
	oPrint:Line(1500,1100,1600,1100)	//Linha da Emissao Esquerda
	oPrint:Line(1500,1750,2000,1750)	//Linha da Emissao Direita

	oPrint:Line(1600,0050,1600,3300)	//Linha Observacoes Horizontal
	oPrint:Line(1650,0050,1650,3300)	//Linha IPI Horizontal
	oPrint:Line(1700,1750,1700,3300)	//Linha Frete Horizontal
	oPrint:Line(1750,1750,1750,3300)	//Linha Grupo Horizontal
	oPrint:Line(1800,1750,1800,3300)	//Linha Total Geral
	oPrint:Line(1850,1750,1850,3300)	//Linha Liberacao do Pedido Horizontal
	oPrint:Line(1900,2850,1900,3300)	//Linha Natureza Horizontal

	oPrint:Line(1550,2150,1750,2150)	//Linha divisoria IPI
	oPrint:Line(1550,2500,1750,2500)	//Linha divisoria IPI Valor
	oPrint:Line(1550,2850,2000,2850)	//Linha divisoria ICMS

	oPrint:Line(2000,1100,2200,1100)	//Linha divisoria de Assinaturas (Comprador)
	oPrint:Line(2000,2200,2200,2200)	//Linha divisoria de Assinaturas (Gerencia)

	oPrint:Line(1990,1850,1990,2750)	//Linha Assinatura (Liberacao do Pedido)
	oPrint:Line(2190,2300,2190,3200)	//Linha Assinatura (Diretoria)

	oPrint:Say(0150,1650,"P E D I D O  D E  C O M P R A S", oFont0)

	oPrint:Say(0120,2850,"MOEDA"					, oFont1)
	oPrint:Say(0120,3090,"NÚMERO"					, oFont1)
	
	If SC7->C7_MOEDA <> 1
		oPrint:Say(0200,2830,"TX: "	+ Transform(nTxMoeda,PesqPictQT("C7_TXMOEDA"))		, oFont4)
	EndIf
	If !Empty(SC7->C7_CODTAB)
		oPrint:Say(0200,3120,"Tabela"													, oFont4)
	EndIf
	
	oPrint:Say(0505,0070,"Item"						, oFont1)
	oPrint:Say(0505,0230,"Cóigo"					, oFont1)
	oPrint:Say(0505,0700,"Descrição do Material"	, oFont1)
	oPrint:Say(0505,1430,"UM"						, oFont1)
	oPrint:Say(0505,1580,"Quant."					, oFont1)
	oPrint:Say(0505,1800,"Valor Unitário"			, oFont1)
	oPrint:Say(0505,2090,"Tabela"					, oFont1)
	oPrint:Say(0505,2320,"IPI"						, oFont1)
	oPrint:Say(0505,2540,"Valor Total"				, oFont1)
	oPrint:Say(0505,2850,"Entrega"					, oFont1)
	oPrint:Say(0505,3100,"C.C"						, oFont1)
	oPrint:Say(0505,3220,"S.C"						, oFont1)
	
	oPrint:Say(1455,0100,"Local de Cobrança : "		, oFont1)
	oPrint:Say(1455,0510,	Alltrim(SM0->M0_NOMECOM) + " - " +;
							Alltrim(SM0->M0_ENDCOB) + " - " +;
							Alltrim(SM0->M0_CIDCOB) + " - " +;
							Alltrim(SM0->M0_ESTCOB) + " - " +;
							"CEP : " + Alltrim(SM0->M0_CEPCOB) + " - " +;
							"CNPJ : " + Alltrim(SM0->M0_CGC) + " - " +;
							"I.E. : " + Alltrim(SM0->M0_INSC) , oFont1)
	
	oPrint:Say(1530,0060,"CONDIÇÃO DE PAGAMENTO - " + Posicione("SE4",1,xFilial("SE4") + cCondPag, "SE4->E4_DESCRI")	, oFont2)
	oPrint:Say(1530,1250,"EMISSÃO : "	+ DtoC(dEmissao)		, oFont2)

	oPrint:Say(1600,0600,"Observações"				, oFont1)

	oPrint:Say(1505,1760,"Total das Mercadorias : "	, oFont1)
	oPrint:Say(1555,1760,"Total com Impostos : "	, oFont1)

	oPrint:Say(1605,1760,"IPI : "					, oFont1)
	oPrint:Say(1655,1760,"Frete : "					, oFont1)
	oPrint:Say(1705,1760,"Grupo : "					, oFont1)
	oPrint:Say(1755,1760,"TOTAL GERAL : "			, oFont1)

	oPrint:Say(1555,2580,"Desconto : "				, oFont1)
	oPrint:Say(1605,2580,"ICMS : "					, oFont1)
	oPrint:Say(1655,2580,"Despesas : "				, oFont1)
	oPrint:Say(1705,2580,"Seguro : "				, oFont1)

	oPrint:Say(1805,2100,"LIBERAÇÃO DO PEDIDO"		, oFont1)

	oPrint:Say(1805,2880,"Obs. Frete :  " + cTpFrete , oFont1)

	oPrint:Say(1855,2900,"Natureza da Compra"		, oFont1)
	oPrint:Say(1915,2880,"Cod.: " + cNatureza , oFont5)
	oPrint:Say(1955,2880,Posicione("SED",1,xFilial("SED") + cNatureza, "SED->ED_DESCRIC")	, oFont5)

	oPrint:Say(2050,0450,"COMPRADOR"				, oFont1)
	oPrint:Say(2050,2600,"DIRETORIA"				, oFont1)
	
	//Dados nas Variaveis
	oPrint:Say(0110,0510,SM0->M0_NOMECOM				, oFont1)
	oPrint:Say(0160,0510,SM0->M0_ENDCOB					, oFont3)
	oPrint:Say(0210,0510,"CEP: " 	+ SM0->M0_CEPCOB + " - " + Alltrim(SM0->M0_CIDCOB) + " / "	+ SM0->M0_ESTCOB, oFont3)
	oPrint:Say(0260,0510,"TEL: " 	+ SM0->M0_TEL		, oFont3)
	oPrint:Say(0310,0510,"FAX: " 	+ SM0->M0_FAX		, oFont3)
	oPrint:Say(0360,0510,"CNPJ: " 	+ SM0->M0_CGC		, oFont3)
	oPrint:Say(0410,0510,"I.E.: " 	+ SM0->M0_INSC		, oFont3)

	oPrint:Say(0160,2870,cMoeda									, oFont4)
	oPrint:Say(0160,3100,cPedido + "/" + StrZero(nPagina,2)	, oFont4)

	DbSelectarea("SA2")
	SA2->(DbSetorder(1))
	If SA2->(DbSeek(xFilial("SA2") + cFornece + cLojaFor))
		oPrint:Say(0260,1410,Alltrim(SA2->A2_NOME)	+ "  (" + cFornece + "/" + cLojaFor + ")", oFont1)
		oPrint:Say(0310,1410,SA2->A2_END	, oFont3)
		oPrint:Say(0360,1410,"BAIRRO : " + Alltrim(SA2->A2_BAIRRO) + " - " + Alltrim(SA2->A2_MUN) + " / " + SA2->A2_EST		, oFont3)
		oPrint:Say(0410,1410,"CEP : " + Alltrim(SA2->A2_CEP) + " TEL : " + "("+Alltrim(A2_DDD)+")" + Alltrim(SA2->A2_TEL)	, oFont3)
		oPrint:Say(0460,1410,"CNPJ : " + Alltrim(SA2->A2_CGC) + " - I.E. : " + Alltrim(SA2->A2_INSCR) + "  - CONTATO : "	+ Alltrim(cContato), oFont3)
	EndIf
	
	oPrint:Say(2100,0380,cComprador	 , oFont3)

	SC7->(DbSetorder(1))
	SC7->(DbSeek(xFilial("SC7") + cPedido))
	
	While !SC7->(EOF()) .And. 	SC7->C7_FILIAL == xFilial("SC7") .And.;
								SC7->C7_NUM == cPedido

		nTotMerc	+= SC7->C7_TOTAL
		nIpi		+= SC7->C7_VALIPI
		nFrete		+= SC7->C7_VALFRE
		nGrupo		:= 0
		nICMS		+= SC7->C7_VALICM
		nDesconto	+= SC7->C7_VLDESC
		nDespesa	+= SC7->C7_DESPESA
		nSeguro		+= SC7->C7_SEGURO
		nTotGer		+= ((SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_VALFRE) - SC7->C7_VLDESC)
		nTotImp		+= SC7->C7_TOTAL + SC7->C7_VALIPI

		If !Empty(SC7->C7_OBS)
			If Empty(cObserva1)
				cObserva1	+= Alltrim(SC7->C7_OBS)
			Else
				cObserva1	+= " - " + Alltrim(SC7->C7_OBS)
			EndIf
		EndIf
		
		SC7->(dbskip())
	Enddo

	//Observacao do Item do Pedido (C7_OBS)
	If !Empty(cObserva1)
		aObserva := GeraDesc(cObserva1, 103)
		For nX := 1 To Len(aObserva)
			If nX > 10
				MsgInfo("As Observações Ultrapassam o tamanho Limite, Só será impresso uma parte")
				Exit
			Else
				oPrint:Say(nLiObs,0060,aObserva[nX], oFont4)
				nLiObs := nLiObs + 30
			EndIf
		Next nX
	EndIf
	
	oPrint:Say(1505,2280,Transform(nTotMerc,"@E 999,999,999.99")	, oFont1,,,0)
	oPrint:Say(1555,2280,Transform(nTotImp,"@E 999,999,999.99")		, oFont1,,,0)

	oPrint:Say(1605,2300, Transform(nIpi,"@E 999,999,999.99")  		, oFont3,,,0)
	oPrint:Say(1655,2300, Transform(nFrete,"@E 999,999,999.99")		, oFont3,,,0)
	oPrint:Say(1705,2300, Transform(nGrupo,"@E 999,999,999.99")		, oFont3,,,0)

	oPrint:Say(1555,3000, Transform(nDesconto,"@E 999,999,999.99")	, oFont3,,,0)
	oPrint:Say(1605,3000, Transform(nICMS,"@E 999,999,999.99")		, oFont3,,,0)
	oPrint:Say(1655,3000, Transform(nDespesa,"@E 999,999,999.99")	, oFont3,,,0)
	oPrint:Say(1705,3000, Transform(nSeguro,"@E 999,999,999.99")	, oFont3,,,0)
	
	oPrint:Say(1755,3000, Transform(nTotGer + nDespesa + nSeguro,"@E 999,999,999.99")	, oFont3,,,0)
    
	RestArea(aAreaC7)
	RestArea(aAreaA5)
	
Return Nil

// Function IMPCABEC2 - Cabecalho da Pagina 2 em diante
Static Function ImpCabec2()

  	Local cLogo	:= FisxLogo("1")
	
	nPagina ++

	oPrint:EndPage()
	oPrint:StartPage()
	
	nLin 	:= 550
	nMaxLin	:= 2150	

	oPrint:SayBitmap(0170,0050,cLogo,400,250)
	
	oPrint:Box(0100,0050,0500,3300)		//Box Superior
	oPrint:Box(0500,0050,0550,3300)		//Box do cabecalho dos Itens
	oPrint:Box(0550,0050,2200,3300)		//Box ate o fim da Pagina

	oPrint:Line(0100,0500,0500,0500)	//Linha do Logo
	oPrint:Line(0100,1400,0550,1400)	//Linha do Nome da Empresa
	oPrint:Line(0250,1400,0250,3300)	//Linha do Pedido de Compras
	oPrint:Line(0100,2800,0250,2800)	//Linha da Moeda
	oPrint:Line(0100,3050,0250,3050)	//Linha do Nro. do Pedido
	
	oPrint:Line(0500,0200,2200,0200)	//Linha do Item
	oPrint:Line(0500,0500,2200,0500)	//Linha do Codigo
	oPrint:Line(0500,1400,2200,1400)	//Linha da Descricao
	oPrint:Line(0500,1550,2200,1550)	//Linha da UM
	oPrint:Line(0500,1750,2200,1750)	//Linha da Quantidade
	oPrint:Line(0500,2070,2200,2070)	//Linha do Valor Unitario
	oPrint:Line(0500,2200,2200,2200)	//Linha da tabela
	oPrint:Line(0500,2500,2200,2500)	//Linha do Valor IPI
	oPrint:Line(0500,2850,2200,2850)	//Linha do Valor Total Mercadoria
	oPrint:Line(0500,3100,2200,3100)	//Linha da Entrega
	oPrint:Line(0500,3200,2200,3200)	//Linha da CC

	oPrint:Say(0150,1650,"P E D I D O  D E  C O M P R A S", oFont0)

	oPrint:Say(0120,2850,"MOEDA"					, oFont1)
	oPrint:Say(0120,3100,"NÚMERO"					, oFont1)
	
	If SC7->C7_MOEDA <> 1
		oPrint:Say(0200,2830,"TX: "	+ Transform(nTxMoeda,PesqPictQT("C7_TXMOEDA"))		, oFont4)
	EndIf
	If !Empty(SC7->C7_CODTAB)
		oPrint:Say(0200,3120,"Tabela"													, oFont4)
	EndIf

	oPrint:Say(0505,0070,"Item"						, oFont1)
	oPrint:Say(0505,0230,"Código"					, oFont1)
	oPrint:Say(0505,0700,"Descrição do Material"	, oFont1)
	oPrint:Say(0505,1430,"UM"						, oFont1)
	oPrint:Say(0505,1580,"Quant."					, oFont1)
	oPrint:Say(0505,2090,"Tabela"					, oFont1)
	oPrint:Say(0505,1800,"Valor Unitário"			, oFont1)
	oPrint:Say(0505,2320,"IPI"						, oFont1)
	oPrint:Say(0505,2540,"Valor Total"				, oFont1)
	oPrint:Say(0505,2850,"Entrega"					, oFont1)
	oPrint:Say(0505,3100,"C.C"						, oFont1)
	oPrint:Say(0505,3220,"S.C"						, oFont1)
	
	//Dados nas Variaveis
	oPrint:Say(0110,0510,SM0->M0_NOMECOM				, oFont1)
	oPrint:Say(0160,0510,SM0->M0_ENDCOB					, oFont3)
	oPrint:Say(0210,0510,"CEP: " 	+ SM0->M0_CEPCOB + " - " + Alltrim(SM0->M0_CIDCOB) + " / "	+ SM0->M0_ESTCOB, oFont3)
	oPrint:Say(0260,0510,"TEL: " 	+ SM0->M0_TEL		, oFont3)
	oPrint:Say(0310,0510,"FAX: " 	+ SM0->M0_FAX		, oFont3)
	oPrint:Say(0360,0510,"CNPJ: " 	+ SM0->M0_CGC		, oFont3)
	oPrint:Say(0410,0510,"I.E.: " 	+ SM0->M0_INSC		, oFont3)

	oPrint:Say(0160,2870,cMoeda									, oFont4)
	oPrint:Say(0160,3100,cPedido + "/" + StrZero(nPagina,2)	, oFont4)

	DbSelectarea("SA2")
	SA2->(DbSetorder(1))
	If SA2->(DbSeek(xFilial("SA2") + cFornece + cLojaFor))
		oPrint:Say(0260,1410,SA2->A2_NOME	, oFont1)
		oPrint:Say(0310,1410,SA2->A2_END	, oFont3)
		oPrint:Say(0360,1410,"BAIRRO : " + Alltrim(SA2->A2_BAIRRO) + " - " + Alltrim(SA2->A2_MUN) + " / " + SA2->A2_EST		, oFont3)
		oPrint:Say(0410,1410,"CEP : " + Alltrim(SA2->A2_CEP) + " TEL : " + Alltrim(SA2->A2_TEL)	, oFont3)
		oPrint:Say(0460,1410,"CNPJ : " + Alltrim(SA2->A2_CGC) + " - I.E. : " + Alltrim(SA2->A2_INSCR) + "  - CONTATO : "	+ Alltrim(cContato), oFont3)
	EndIf

Return Nil

// Function GERADESC - Cria Array para Descricao do Item
Static Function GeraDesc(cString, nTam)
	Local aRetorno	:= {}
	Local cAux		:= Alltrim(Upper(cString))
    Local lContinua	:= .T.
    Local nAux		:= 0
		
	//Caso exista Enter no MEMO, Remove
	If At(Chr(13) + Chr(10), cAux) > 0
		cAux := StrTran(cAux, Chr(13) + Chr(10), "")
	EndIf

	//Caso exista TAB no MEMO, Remove
	If At(Chr(09), cAux) > 0
		cAux := StrTran(cAux, Chr(09), "")
	EndIf

	While !Empty(cAux)
		
		lContinua := .T.
		
		Aadd(aRetorno, SubStr(cAux,1,nTam))
		
		If Len(SubStr(cAux, nTam + 1)) > 0
			nAux := Len(aRetorno[Len(aRetorno)])
			If !Empty(Right(aRetorno[Len(aRetorno)],1))
				While lContinua
					nAux := nAux - 1
					If Empty(Right(SubStr(cAux,1,nAux),1))
						lContinua := .F.
					EndIf
				Enddo
				aRetorno[Len(aRetorno)] := SubStr(cAux,1,nAux)
			EndIf
		EndIf

		cAux := SubStr(cAux, Len(aRetorno[Len(aRetorno)]) + 1)
		
	Enddo
	
Return aRetorno
