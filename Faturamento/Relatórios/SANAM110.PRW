#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    ?SANAM110 ?Autor ?  SYMM CONSULTORIA    ?Data ?18/08/15  潮?
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escri噭o ?Programa para calcular a comissao dos vendedores e atuali-  潮?
北矰escri噭o ?zar o cadastro de manuten玢o de comissoes.                  潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/

User Function SANAM110()

	Local lRet 			:= .T.
	Local nOpca			:= 0
	Local aButtons		:= {}
	Local aSays			:= {}
	Local cPerg			:= Padr("SANAM110P",10)

	Private aTotVdas	:= {}
	//Private cTesVenda	:= U_SyTrataPar( GetMv("MV_SATESVD",,"5101|5102|5103|5104|5105|5106|5109|5110|5111|5112|5113|5114|5115|5116|5117|5118|5119|5120|5122|5123|5251|5252|5253|5254|5255|5256|5257|5258|5401|5402|5403|5405|5501|5502|5551|5922|6101|6102|6103|6104|6105|6106|6109|6110|6111|6112|6113|6114|6115|6116|6117|6118|6119|6120|6122|6123|6251|6252|6253|6254|6255|6256|6257|6258|6401|6402|6403|6405|6501|6502|6551|6922|6404|6108") )
	Private cTesVenda	:= ""
	Private cParam01	:= GetMv("MV_SAFILPG",,"R$|CD|DC|DH")

	cTesVenda := U_SyTrataPar( GetMv("MV_STESVD1",,"5101|5102|5103|5104|5105|5106|5109|5110|5111|5112|5113|5114|5115|5116|5117|5118|5119|5120|5122|5123|5251|5252|5253|5254|5255|5256|5257|5258|5401|5402|5403|5405|5501|5502|5551|5922") )
	cTesVenda += ","
	cTesVenda += U_SyTrataPar( GetMv("MV_STESVD2",,"6101|6102|6103|6104|6105|6106|6109|6110|6111|6112|6113|6114|6115|6116|6117|6118|6119|6120|6122|6123|6251|6252|6253|6254|6255|6256|6257|6258|6401|6402|6403|6405|6501|6502|6551|6922|6404|6108") )

	Aadd(aSays,OemToAnsi( "Este programa tem como objetivo calcular a comiss鉶 dos vendedores e atualizar o cadastro de " ) )
	Aadd(aSays,OemToAnsi( "manuten玢o de comiss鮡s (SE3). " ) )
	Aadd(aButtons, { 1,.T.,{|| nOpca := 1, FechaBatch()}} )
	Aadd(aButtons, { 2,.T.,{|| nOpca := 0, FechaBatch()}} )

	FormBatch( "Comiss鮡s dos vendedores", aSays, aButtons )

	IF nOpca == 0
		Return(.T.)
	EndIF

	AjustaSX1(cPerg)
	IF !Pergunte(cPerg,.T.)
		Return
	Else
		If Empty(Mv_Par06)
			MsgBox("Data de Vencimento n鉶 informado.")
			Return
		Endif
	Endif

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪??
	//矱xecuta a query somente para vendedores internos          ?
	//硃orque vendedores externos nao precisa calacula o markup. ?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪??
	If Mv_Par05==1
		FwMsgRun( ,{|| FilVdaSin() }, , "Por favor, aguarde calculando o markup global..." )
	Endif

	Begin Transaction
		FwMsgRun( ,{|| FilVdaAna() }, , "Por favor, aguarde gerando comiss鮡s dos vendedores..." )
	End Transaction

Return

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲ilVdaSint篈utor  ?SYMM Consultoria	 ?Data ? 18/05/15   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矲iltra totais das vendas para encontrar o percentual do    .罕?
北?         砿arkup.                                                     罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function FilVdaSin()

	Local cQuery  	:= ""
	Local cQrySin 	:= GetNextAlias()

	//-------------------------------------DEVOLUCOES------------------------------------------------------------------
	cQuery += "SELECT LOJA,CODVEN,VEND,SUM(TOTALDEVOLUCAO) TOTDEVOL,SUM(TOTALVENDA) TOTVEN,SUM(TOTALCUSTO) TOTCUS,SUM(TOTALNOTAS) QTNFE,ROUND((((SUM(TOTALVENDA)/SUM(NULLIF(TOTALCUSTO,0)))-1)*100),2) MARKUP,TABELA,AGLUTINA_VDA,NUMRH,FORMA FROM ( "
	cQuery += "SELECT LOJA,CODVEN,VEND,SUM(DEVOLUCAO) TOTALDEVOLUCAO,SUM(VENDAS) TOTALVENDA,SUM(CUSTO) TOTALCUSTO,SUM(QTDNFE) TOTALNOTAS,ROUND((((SUM(VENDAS)/SUM(NULLIF(CUSTO,0)))-1)*100),2) MARKUP,TABELA,AGLUTINA_VDA,NUMRH,FORMA FROM ( "
	cQuery += "SELECT LOJA,CODVEN,VEND,SUM(VLRDEV) DEVOLUCAO,SUM(VENDALIQ) VENDAS,ISNULL(SUM(CUSTOLIQ),0) CUSTO,COUNT(VENDALIQ) QTDNFE,ROUND(ISNULL((((SUM(VENDALIQ)/SUM(NULLIF(CUSTOLIQ,0)))-1)*100),0),2) MARKUP,TABELA,AGLUTINA_VDA,NUMRH,FORMA FROM ( "
	cQuery += "SELECT F2_FILIAL FILIAL,D1_NFORI NOTA ,F2_SERIE SERIE,F2_EMISSAO,F2_VEND1 VENDEDOR,SUM(D2_TOTAL) TOTVENDA, "
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0),2) VENDA, "
	cQuery += "ROUND(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0),2) CUSTO, "
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0),2) VLRDEV, "
	cQuery += "ROUND(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0),2) CUSDEV, "

	cQuery += "ISNULL(UA_XPCAQT,0) ARQUITETO, "
	cQuery += "ROUND(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100),2) VLRAQT, "

	cQuery += "ISNULL(UA_XPERC,0) KIT, "
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2) VLRKIT, "

	cQuery += "IIF(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)-ISNULL(SUM(D1_VUNIT*D1_QUANT),0)=0, ISNULL(SUM(D1_VUNIT*D1_QUANT),0)*(-1),ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)-ISNULL(SUM(D1_VUNIT*D1_QUANT),0)-IIF(UA_XPCAQT=0,0,((ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)) - (ISNULL(SUM(D1_VUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100))) VENDALIQ, "
	cQuery += "IIF(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO)-ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO) = 0, ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO)*(-1), ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO)-ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO) + IIF(UA_XPERC=0,0,((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO) - (ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO))) * (ISNULL(UA_XPERC,0)/100)))) CUSTOLIQ, "

	cQuery += "ROUND(((ISNULL(ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2) "
	cQuery += "/NULLIF(((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "
	cQuery += "+((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),0),0)-1)*100),2) MARKUP, "

	cQuery += "ISNULL(L1_FORMPG,SE4F.E4_FORMA) FORMA,A3_UNIDAD LOJA,A3_NOME VEND,A3_COD CODVEN, A3_XTABCOM TABELA,A3_XAGLVDA AGLUTINA_VDA,A3_CARGO CARGO, "
	cQuery += "A3_NUMRA NUMRH,F2_CLIENTE CODCLIENTE,F2_LOJA LJCLIENTE, CASE WHEN L1_ORCRES = '' THEN L1_NUM ELSE L1_ORCRES END PEDIDO "
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 "

	cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D_E_L_E_T_ =' ' "
	cQuery += "AND D2_FILIAL=F2_FILIAL "
	cQuery += "AND D2_DOC=F2_DOC "
	cQuery += "AND D2_SERIE=F2_SERIE "
	cQuery += "AND D2_CLIENTE=F2_CLIENTE "
	cQuery += "AND D2_LOJA=F2_LOJA "

	cQuery += "LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ =' ' "
	cQuery += "AND B1_FILIAL='"+xFilial("SB1")+"' "
	cQuery += "AND B1_COD=D2_COD "

	cQuery += "LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D_E_L_E_T_ =' ' "
	cQuery += "AND D1_FILIAL=D2_FILIAL "
	cQuery += "AND D1_NFORI=D2_DOC "
	cQuery += "AND D1_SERIORI=D2_SERIE "
	cQuery += "AND D1_ITEMORI=D2_ITEM "
	cQuery += "AND D1_COD=D2_COD "
	cQuery += "AND D1_TIPO='D' "
	cQuery += "AND D1_DTDIGIT BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' "

	cQuery += "LEFT JOIN "+RetSqlName("SL1")+" SL1 ON SL1.D_E_L_E_T_ =' ' "
	cQuery += "AND L1_FILIAL=F2_FILIAL "
	cQuery += "AND L1_SERIE=F2_SERIE "
	cQuery += "AND L1_DOC=F2_DOC "

	cQuery += "LEFT JOIN "+RetSqlName("SL2")+" SL2 ON SL2.D_E_L_E_T_ =' '  "
	cQuery += "AND L2_FILIAL=L1_FILIAL "
	cQuery += "AND L2_NUM=L1_NUM  "
	cQuery += "AND L2_ITEM=D1_ITEM "

	cQuery += "LEFT JOIN "+RetSqlName("SUB")+" SUB ON SUB.D_E_L_E_T_ =' '  	"
	cQuery += "AND SUB.UB_FILIAL=L2_FILIAL "
	cQuery += "AND SUB.UB_NUM=L2_NUM "
	//cQuery += "AND SUB.UB_ITEM=L2_ITEM   "+CRLF
	cQuery += "AND SUB.UB_PRODUTO=L2_PRODUTO  "
	cQuery += "AND F2_ESPECIE = 'CF' "

	cQuery += "LEFT JOIN "+RetSqlName("SUA")+" SUA ON SUA.D_E_L_E_T_ =' ' 	"
	cQuery += "AND UA_FILIAL=SUB.UB_FILIAL  "
	cQuery += "AND UA_NUM=SUB.UB_NUM "

	cQuery += "LEFT JOIN SUB010 SUBF (NOLOCK) ON SUBF.D_E_L_E_T_ = '' 		"
	cQuery += "AND SUBF.UB_XLOCSAI = SF2.F2_FILIAL							"
	cQuery += "AND SUBF.UB_NUMPVE = SD2.D2_PEDIDO							"
	cQuery += "AND SUBF.UB_ITEMPV = SD2.D2_ITEMPV							"
	cQuery += "AND F2_ESPECIE = 'SPED' "

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.D_E_L_E_T_ =' '   "
	cQuery += "AND SE4.E4_FILIAL='"+xFilial("SE4")+"' "
	cQuery += "AND SE4.E4_CODIGO=L1_COND "

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4F ON SE4F.D_E_L_E_T_ =' '   "
	cQuery += "AND SE4F.E4_FILIAL='"+xFilial("SE4")+"' "
	cQuery += "AND SE4F.E4_CODIGO=F2_COND "

	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.D_E_L_E_T_ =' '   "
	cQuery += "AND F4_FILIAL='"+xFilial("SF4")+"' "
	cQuery += "AND D2_TES=F4_CODIGO "

	cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON SA3.D_E_L_E_T_ =' ' "
	cQuery += "AND A3_COD=F2_VEND1 "

	cQuery += "WHERE F2_EMISSAO<'"+DTOS(Mv_Par01)+"' "
	cQuery += "AND D1_NFORI<>'' "
	cQuery += "AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' "
	cQuery += "AND SF2.D_E_L_E_T_ =' '  "
	cQuery += "AND F2_ESPECIE IN ('CF','SPED') "
	cQuery += "AND D2_CF IN ("+cTesVenda+") "
	cQuery += "AND A3_MSBLQL<>'1' "

	cQuery += "GROUP BY SL1.L1_ORCRES,F2_FILIAL,F2_DOC ,F2_SERIE ,F2_EMISSAO,F2_VEND1 ,UA_XPCAQT ,UA_XPERC,L1_FORMPG,L1_XCUSTO, "
	cQuery += "SE4F.E4_FORMA,SE4.E4_FORMA,A3_NOME,A3_COD,A3_UNIDAD,A3_XTABCOM,A3_XAGLVDA,A3_CARGO,A3_NUMRA,F2_CLIENTE,F2_LOJA, "
	cQuery += "L1_NUM,D1_NFORI "
	cQuery += ")TABA GROUP BY LOJA,CODVEN,VEND,TABELA,AGLUTINA_VDA,NUMRH,FORMA "
	cQuery += ")TABB GROUP BY LOJA,CODVEN,VEND,TABELA,AGLUTINA_VDA,NUMRH,FORMA "

	//-------------------------------------VENDAS------------------------------------------------------------------
	cQuery += "UNION ALL "

	cQuery += "SELECT LOJA,CODVEN,VEND,SUM(DEVOLUCAO) TOTALDEVOLUCAO,SUM(VENDAS) TOTALVENDA,SUM(CUSTO) TOTALCUSTO,SUM(QTDNFE) TOTALNOTAS,ROUND((((SUM(VENDAS)/SUM(NULLIF(CUSTO,0)))-1)*100),2) MARKUP,TABELA,AGLUTINA_VDA,NUMRH,FORMA FROM ( "
	cQuery += "SELECT LOJA,CODVEN,VEND,SUM(VLRDEV) DEVOLUCAO,SUM(VENDALIQ) VENDAS,ISNULL(SUM(CUSTOLIQ),0) CUSTO,COUNT(VENDALIQ) QTDNFE,ROUND(ISNULL((((SUM(VENDALIQ)/SUM(NULLIF(CUSTOLIQ,0)))-1)*100),0),2) MARKUP,TABELA,AGLUTINA_VDA,NUMRH,FORMA FROM ( "
	cQuery += "SELECT F2_FILIAL FILIAL,F2_DOC NOTA ,F2_SERIE SERIE,F2_EMISSAO,F2_VEND1 VENDEDOR, "
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0),2) VENDA, "
	cQuery += "ROUND(ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0),2) CUSTO, "
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0),2) VLRDEV, "
	cQuery += "ROUND(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0),2) CUSDEV, "

	cQuery += "ISNULL(UA_XPCAQT,0) ARQUITETO, "
	cQuery += "ROUND(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100),2) VLRAQT, "

	cQuery += "ISNULL(UA_XPERC,0) KIT, "
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2) VLRKIT, "

	cQuery += "CASE WHEN((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)))=0 THEN '0' "
	cQuery += "ELSE "
	cQuery += "	ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2)END AS VENDALIQ, "

	cQuery += "CASE	WHEN((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) = 0 THEN '0' "
	cQuery += "ELSE "
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0)-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2)END AS CUSTOLIQ, "

	cQuery += "ROUND(((ISNULL(ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2) "
	cQuery += "/NULLIF(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),0),0)-1)*100),2) MARKUP, "

	cQuery += "L1_FORMPG FORMA,A3_UNIDAD LOJA,A3_NOME VEND,A3_COD CODVEN, "
	cQuery += "A3_XTABCOM TABELA,A3_XAGLVDA AGLUTINA_VDA,A3_CARGO CARGO,A3_NUMRA NUMRH,F2_CLIENTE CODCLIENTE,F2_LOJA LJCLIENTE, CASE WHEN L1_ORCRES = '' THEN L1_NUM ELSE L1_ORCRES END PEDIDO "
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 "

	cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D_E_L_E_T_ =' ' "
	cQuery += "AND D2_FILIAL=F2_FILIAL "
	cQuery += "AND D2_DOC=F2_DOC "
	cQuery += "AND D2_SERIE=F2_SERIE "
	cQuery += "AND D2_CLIENTE=F2_CLIENTE "
	cQuery += "AND D2_LOJA=F2_LOJA "

	cQuery += "LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ =' ' "
	cQuery += "AND B1_FILIAL='"+xFilial("SB1")+"' "
	cQuery += "AND B1_COD=D2_COD "

	cQuery += "LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D_E_L_E_T_ =' ' "
	cQuery += "AND D1_FILIAL=D2_FILIAL "
	cQuery += "AND D1_NFORI=D2_DOC "
	cQuery += "AND D1_SERIORI=D2_SERIE "
	cQuery += "AND D1_ITEMORI=D2_ITEM "
	cQuery += "AND D1_COD=D2_COD "
	cQuery += "AND D1_TIPO='D' "
	cQuery += "AND D1_DTDIGIT BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SL1")+" SL1 ON SL1.D_E_L_E_T_ =' ' "
	cQuery += "AND L1_FILIAL=F2_FILIAL "
	cQuery += "AND L1_DOC=F2_DOC "
	cQuery += "AND L1_SERIE=F2_SERIE "

	cQuery += "LEFT JOIN "+RetSqlName("SL2")+" SL2 ON SL2.D_E_L_E_T_ =' ' "
	cQuery += "AND L2_FILIAL=L1_FILIAL "
	cQuery += "AND L2_NUM=L1_NUM "
	cQuery += "AND L2_ITEM=D2_ITEM "

	cQuery += "LEFT JOIN "+RetSqlName("SUB")+" SUB ON SUB.D_E_L_E_T_ =' ' "
	cQuery += "AND UB_FILIAL=L2_FILIAL "
	cQuery += "AND UB_NUM = CASE WHEN L1_ORCRES = '' THEN L1_NUM ELSE L1_ORCRES END "
	//cQuery += "AND UB_ITEM=L2_ITEM "
	cQuery += "AND UB_PRODUTO=L2_PRODUTO "

	cQuery += "LEFT JOIN "+RetSqlName("SUA")+" SUA ON SUA.D_E_L_E_T_ =' ' "
	cQuery += "AND UA_FILIAL=UB_FILIAL "
	cQuery += "AND UA_NUM = CASE WHEN L1_ORCRES = '' THEN L1_NUM ELSE L1_ORCRES END "

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.D_E_L_E_T_ =' ' "
	cQuery += "AND E4_FILIAL='"+xFilial("SE4")+"' "
	cQuery += "AND E4_CODIGO=L1_COND "

	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.D_E_L_E_T_ =' ' "
	cQuery += "AND F4_FILIAL='"+xFilial("SF4")+"' "
	cQuery += "AND D2_TES=F4_CODIGO "

	cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON SA3.D_E_L_E_T_ =' ' "
	cQuery += "AND A3_COD=F2_VEND1 "

	cQuery += "WHERE F2_EMISSAO BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF
	cQuery += "AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	cQuery += "AND SF2.D_E_L_E_T_ =' ' "
	cQuery += "AND F2_ESPECIE='CF' "
	cQuery += "AND F2_TIPO='N' "
	cQuery += "AND D2_CF IN("+cTesVenda+") " + CRLF
	cQuery += "AND L1_SITUA='OK' "
	cQuery += "AND A3_MSBLQL<>'1' "

	cQuery += "GROUP BY SL1.L1_NUM, SL1.L1_ORCRES, F2_FILIAL,F2_DOC ,F2_SERIE ,F2_EMISSAO,F2_VEND1 ,UA_XPCAQT ,UA_XPERC,L1_FORMPG,L1_XCUSTO, "
	cQuery += "E4_FORMA,A3_NOME,A3_COD,A3_UNIDAD,A3_XTABCOM,A3_XAGLVDA,A3_CARGO,A3_NUMRA,F2_CLIENTE,F2_LOJA, "
	cQuery += "L2_NUM "
	cQuery += ")TABA GROUP BY LOJA,CODVEN,VEND,TABELA,AGLUTINA_VDA,NUMRH,FORMA "

	cQuery += "UNION ALL "

	cQuery += "SELECT LOJA,CODVEN,VEND,SUM(VLRDEV) DEVOLUCAO,SUM(VENDALIQ) VENDAS,ISNULL(SUM(CUSTOLIQ),0) CUSTO,COUNT(VENDALIQ) QTDNFE,ROUND(ISNULL((((SUM(VENDALIQ)/SUM(NULLIF(CUSTOLIQ,0)))-1)*100),0),2) MARKUP,TABELA,AGLUTINA_VDA,NUMRH,FORMA FROM ( "
	cQuery += "SELECT F2_FILIAL FILIAL,F2_DOC NOTA ,F2_SERIE SERIE,F2_EMISSAO,F2_VEND1 VENDEDOR,SUM(D2_TOTAL) TOTVENDA, "
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0),2) VENDA, "
	cQuery += "ROUND(ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0),2) CUSTO, "
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0),2) VLRDEV, "
	cQuery += "ROUND(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0),2) CUSDEV, "

	cQuery += "ISNULL(UA_XPCAQT,0) ARQUITETO, "
	cQuery += "ROUND(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100),2) VLRAQT,

	cQuery += "ISNULL(UA_XPERC,0) KIT, "
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2) VLRKIT, "

	cQuery += "CASE WHEN((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)))=0 THEN'0' "
	cQuery += "ELSE "
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2)END AS VENDALIQ, "

	cQuery += "CASE WHEN ((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) = 0 THEN '0' "
	cQuery += "ELSE "
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0)-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2)END AS CUSTOLIQ, "

	cQuery += "ROUND(((ISNULL(ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2) "
	cQuery += "/NULLIF(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),0),0)-1)*100),2) MARKUP, "

	cQuery += "E4_FORMA FORMA,A3_UNIDAD LOJA,A3_NOME VEND,A3_COD CODVEN, "
	cQuery += "A3_XTABCOM TABELA,A3_XAGLVDA AGLUTINA_VDA,A3_CARGO CARGO,A3_NUMRA NUMRH,F2_CLIENTE CODCLIENTE,F2_LOJA LJCLIENTE,C5_NUM PEDIDO "
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 "

	cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D_E_L_E_T_ =' ' "
	cQuery += "AND D2_FILIAL=F2_FILIAL "
	cQuery += "AND D2_DOC=F2_DOC "
	cQuery += "AND D2_SERIE=F2_SERIE "
	cQuery += "AND D2_CLIENTE=F2_CLIENTE "
	cQuery += "AND D2_LOJA=F2_LOJA "

	cQuery += "LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ =' ' "
	cQuery += "AND B1_FILIAL='"+xFilial("SB1")+"' "
	cQuery += "AND B1_COD=D2_COD "

	cQuery += "LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D_E_L_E_T_ =' ' "
	cQuery += "AND D1_FILIAL=D2_FILIAL "
	cQuery += "AND D1_NFORI=D2_DOC "
	cQuery += "AND D1_SERIORI=D2_SERIE "
	cQuery += "AND D1_ITEMORI=D2_ITEM "
	cQuery += "AND D1_COD=D2_COD "
	cQuery += "AND D1_TIPO='D' "
	cQuery += "AND D1_DTDIGIT BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SUB")+" SUB ON SUB.D_E_L_E_T_ =' ' "
	cQuery += "AND D2_FILIAL=UB_XLOCSAI "
	cQuery += "AND D2_PEDIDO=UB_NUMPVE "
	cQuery += "AND D2_ITEMPV=UB_ITEMPV "
	cQuery += "AND D2_COD=UB_PRODUTO "

	cQuery += "LEFT JOIN "+RetSqlName("SUA")+" SUA ON SUA.D_E_L_E_T_ =' ' "
	cQuery += "AND UA_FILIAL=UB_FILIAL "
	cQuery += "AND UA_NUM=UB_NUM "

	cQuery += "LEFT JOIN "+RetSqlName("SC5")+" SC5 ON SC5.D_E_L_E_T_ =' ' "
	cQuery += "AND C5_FILIAL=D2_FILIAL "
	cQuery += "AND C5_NUM=D2_PEDIDO "

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.D_E_L_E_T_ =' ' "
	cQuery += "AND E4_FILIAL='"+xFilial("SE4")+"' "
	cQuery += "AND E4_CODIGO=F2_COND "

	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.D_E_L_E_T_ =' ' "
	cQuery += "AND F4_FILIAL='"+xFilial("SF4")+"' "
	cQuery += "AND D2_TES=F4_CODIGO "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON SA3.D_E_L_E_T_ =' ' "
	cQuery += "AND A3_COD=F2_VEND1 "

	cQuery += "WHERE F2_EMISSAO BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF
	cQuery += "AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	cQuery += "AND SF2.D_E_L_E_T_ =' ' "
	cQuery += "AND F2_ESPECIE='SPED' "
	//cQuery += "AND F2_NFCUPOM='' "
	cQuery += "AND F2_TIPO NOT IN ('D','B') "
	cQuery += "AND D2_CF IN("+cTesVenda+") " + CRLF
	cQuery += "AND A3_MSBLQL<>'1' "

	cQuery += "GROUP BY F2_FILIAL,F2_DOC ,F2_SERIE ,F2_EMISSAO,F2_VEND1 ,UA_XPCAQT ,UA_XPERC,F2_COND, "
	cQuery += "E4_FORMA,A3_NOME,A3_COD,A3_UNIDAD,A3_XTABCOM,A3_XAGLVDA,A3_CARGO,A3_NUMRA,F2_CLIENTE,F2_LOJA, "
	cQuery += "C5_NUM "
	cQuery += ")TABA GROUP BY LOJA,CODVEN,VEND,TABELA,AGLUTINA_VDA,NUMRH,FORMA "
	cQuery += ")TABB GROUP BY LOJA,CODVEN,VEND,TABELA,AGLUTINA_VDA,NUMRH,FORMA "
	cQuery += ")TABC GROUP BY LOJA,CODVEN,VEND,TABELA,AGLUTINA_VDA,NUMRH,FORMA "
	cQuery += "ORDER BY CODVEN "

	MemoWrite("C:\TEMP\QRY1_SINTETICA.SQL",cQuery)

	TCQUERY cQuery NEW ALIAS (cQrySin)

	(cQrySin)->(DbGotop())
	While (cQrySin)->(!EOF())

		If (cQrySin)->AGLUTINA_VDA=='1'

			cTabela	:= ''
			nPos 	:= Ascan(aTotVdas ,{|x| x[2] == (cQrySin)->CODVEN } )

			If nPos==0
				AAdd(aTotVdas ,{ "","","",0,0,0,0,0,"","","",0,"" } )
				nPos := Len(aTotVdas)

				//Apaga as comissoes do periodo
				DeletaSE3( (cQrySin)->CODVEN )
			Endif
			aTotVdas[nPos,01] := (cQrySin)->LOJA  														//1.Filial
			aTotVdas[nPos,02] := (cQrySin)->CODVEN														//2.Codigo do Vendedor
			aTotVdas[nPos,03] := (cQrySin)->VEND														//3.Nome do Vendedor
			aTotVdas[nPos,04] += (cQrySin)->TOTDEVOL													//4.Total de Devolucoes
			aTotVdas[nPos,05] += (cQrySin)->TOTVEN														//5.Total de Vendas
			aTotVdas[nPos,06] += (cQrySin)->TOTCUS														//6.Total de Custos
			aTotVdas[nPos,07] += (cQrySin)->QTNFE														//7.Total de Notas
			aTotVdas[nPos,08] := ( (aTotVdas[nPos,05] / aTotVdas[nPos,06] ) -1 )*100 					//8.Markup
			aTotVdas[nPos,09] := (cQrySin)->TABELA														//9.Codigo da Tabela de Comissao
			aTotVdas[nPos,10] := (cQrySin)->NUMRH														//10.Codigo do funcionario
			aTotVdas[nPos,11] := cTabela																//11.Codigo da Tabela de Comissao Manual
			aTotVdas[nPos,12] := 0																		//12.Percentual de Comissao
			aTotVdas[nPos,13] := (cQrySin)->AGLUTINA_VDA												//13.Aglutina Vendas S/N


		Else

			cTabela := If( Alltrim((cQrySin)->FORMA)$cParam01,"F01","F02")
			nPos 	:= Ascan(aTotVdas ,{|x| x[2]+x[11] == (cQrySin)->CODVEN+cTabela } )

			If nPos==0
				AAdd(aTotVdas ,{ "","","",0,0,0,0,0,"","","",0,"" } )
				nPos := Len(aTotVdas)

				//Apaga as comissoes do periodo
				DeletaSE3( (cQrySin)->CODVEN )
			Endif
			aTotVdas[nPos,01] := (cQrySin)->LOJA  														//1.Filial
			aTotVdas[nPos,02] := (cQrySin)->CODVEN														//2.Codigo do Vendedor
			aTotVdas[nPos,03] := (cQrySin)->VEND														//3.Nome do Vendedor
			aTotVdas[nPos,04] += (cQrySin)->TOTDEVOL													//4.Total de Devolucoes
			aTotVdas[nPos,05] += (cQrySin)->TOTVEN														//5.Total de Vendas
			aTotVdas[nPos,06] += (cQrySin)->TOTCUS														//6.Total de Custos
			aTotVdas[nPos,07] += (cQrySin)->QTNFE														//7.Total de Notas
			aTotVdas[nPos,08] := ( (aTotVdas[nPos,05] / aTotVdas[nPos,06] ) -1 )*100 					//8.Markup
			aTotVdas[nPos,09] := (cQrySin)->TABELA														//9.Codigo da Tabela de Comissao
			aTotVdas[nPos,10] := (cQrySin)->NUMRH														//10.Codigo do funcionario
			aTotVdas[nPos,11] := cTabela																//11.Codigo da Tabela de Comissao Manual
			aTotVdas[nPos,12] := 0																		//12.Percentual de Comissao
			aTotVdas[nPos,13] := (cQrySin)->AGLUTINA_VDA												//13.Aglutina Vendas S/N

		Endif

		(cQrySin)->(DbSkip())
	EndDo
	(cQrySin)->(DbCloseArea())

	//--Busca o percentual da comissao e preenche a posicao 12 do array aTotVdas para cada vendedor
	If Len(aTotVdas) > 0

		For nX := 1 To Len(aTotVdas)

			aTotVdas[nX,12]	:= FilMarkup(aTotVdas[nX,08],aTotVdas[nX,09],aTotVdas[nX,13],aTotVdas[nX,11])

		Next

	Endif

Return

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矲ilVdaAna 篈utor  ?SYMM Consultoria	 ?Data ? 18/05/15   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矲iltra todas as notas fiscais e cupons fiscais para calculo.罕?
北?         砫a comissao.                                                罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function FilVdaAna()

	Local cQuery  :=""
	Local cQryAna :=GetNextAlias()
	Local aVend	  :={}

	//------------------------DEVOLUCAO
	cQuery += "SELECT F2_FILIAL FILIAL,D1_NFORI NOTA ,F2_SERIE SERIE,F2_EMISSAO EMISSAO,F2_VEND1 VENDEDOR, "+CRLF
	cQuery += "ROUND(SUM(D2_PRUNIT*D2_QUANT),2) VENDA, "+CRLF
	cQuery += "ROUND(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0),2) CUSTO, "+CRLF
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0),2) VLRDEV, "+CRLF
	cQuery += "ROUND(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0),2) CUSDEV, "+CRLF
	//--ARQUITETO
	cQuery += "ISNULL(UA_XPCAQT,0) ARQUITETO, "+CRLF
	cQuery += "ROUND(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100),2) VLRAQT, "+CRLF
	//--KIT
	cQuery += "ISNULL(UA_XPERC,0) KIT, "+CRLF
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2) VLRKIT, "+CRLF

	//cQuery += "CASE WHEN((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)))=0 THEN'0' "+CRLF
	//cQuery += "ELSE "+CRLF
	//cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2)END AS VENDALIQ, "+CRLF
	cQuery += "IIF(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)-ISNULL(SUM(D1_VUNIT*D1_QUANT),0)=0, ISNULL(SUM(D1_VUNIT*D1_QUANT),0),ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)-ISNULL(SUM(D1_VUNIT*D1_QUANT),0)-IIF(UA_XPCAQT=0,0,((ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)) - (ISNULL(SUM(D1_VUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100))) VENDALIQ,"+CRLF

	//cQuery += "CASE WHEN((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) = 0 THEN '0' "+CRLF
	//cQuery += "ELSE "+CRLF
	//cQuery += "ROUND(((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "+CRLF
	//cQuery += "+((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0)-(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2)END AS CUSTOLIQ, "+CRLF
	cQuery += "IIF(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO)-ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO) = 0, ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO), ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO)-ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO) + IIF(UA_XPERC=0,0,((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO) - (ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),L1_XCUSTO))) * (ISNULL(UA_XPERC,0)/100)))) CUSTOLIQ,"+CRLF

	cQuery += "ROUND(((ISNULL(ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2) "+CRLF
	cQuery += "/NULLIF(((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "+CRLF
	cQuery += "+((ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(ISNULL(SUB.UB_XCUSTO,SUBF.UB_XCUSTO)*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),0),0)-1)*100),2) MARKUP, "+CRLF

	cQuery += "ISNULL(L1_FORMPG,SE4F.E4_FORMA) FORMA,A3_UNIDAD LOJA,A3_NOME VEND,A3_COD CODVEN, "+CRLF
	cQuery += "A3_XTABCOM TABELA,A3_XAGLVDA AGLUTINA_VDA,A3_CARGO CARGO,A3_NUMRA NUMRH,F2_CLIENTE CODCLIENTE,F2_LOJA LJCLIENTE,ISNULL(L1_NUM,SD2.D2_PEDIDO) PEDIDO,ISNULL(UA_XARQT,'') CODARQT"+CRLF
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 (NOLOCK) "+CRLF

	cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) ON SD2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND D2_FILIAL=F2_FILIAL "+CRLF
	cQuery += "AND D2_DOC=F2_DOC "+CRLF
	cQuery += "AND D2_SERIE=F2_SERIE "+CRLF
	cQuery += "AND D2_CLIENTE=F2_CLIENTE "+CRLF
	cQuery += "AND D2_LOJA=F2_LOJA "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) ON SB1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND B1_FILIAL='"+xFilial("SB1")+"' "+CRLF
	cQuery += "AND B1_COD=D2_COD "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK) ON SD1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND D1_FILIAL=D2_FILIAL "+CRLF
	cQuery += "AND D1_NFORI=D2_DOC "+CRLF
	cQuery += "AND D1_SERIORI=D2_SERIE "+CRLF
	cQuery += "AND D1_ITEMORI=D2_ITEM "+CRLF
	cQuery += "AND D1_COD=D2_COD "+CRLF
	cQuery += "AND D1_TIPO='D' "+CRLF
	cQuery += "AND D1_DTDIGIT BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SL1")+" SL1 (NOLOCK) ON SL1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND L1_FILIAL=F2_FILIAL "+CRLF
	cQuery += "AND L1_DOC=F2_DOC "+CRLF
	cQuery += "AND L1_SERIE=F2_SERIE "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SL2")+" SL2 (NOLOCK) ON SL2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND L2_FILIAL=L1_FILIAL "+CRLF
	cQuery += "AND L2_NUM=L1_NUM "+CRLF
	cQuery += "AND L2_ITEM=D1_ITEM "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SUB")+" SUB (NOLOCK) ON SUB.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND SUB.UB_FILIAL=L2_FILIAL "+CRLF
	cQuery += "AND SUB.UB_NUM=L2_NUM "+CRLF
	//cQuery += "AND SUB.UB_ITEM=L2_ITEM "+CRLF
	cQuery += "AND SUB.UB_PRODUTO=L2_PRODUTO "+CRLF
	cQuery += "AND F2_ESPECIE = 'CF'"+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SUA")+" SUA (NOLOCK) ON SUA.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND UA_FILIAL=SUB.UB_FILIAL "+CRLF
	cQuery += "AND UA_NUM=SUB.UB_NUM "+CRLF

	cQuery += "LEFT JOIN SUB010 SUBF (NOLOCK) ON SUBF.D_E_L_E_T_ = '' 		"+CRLF
	cQuery += "AND SUBF.UB_XLOCSAI = SF2.F2_FILIAL							"+CRLF
	cQuery += "AND SUBF.UB_NUMPVE = SD2.D2_PEDIDO							"+CRLF
	cQuery += "AND SUBF.UB_ITEMPV = SD2.D2_ITEMPV							"+CRLF
	cQuery += "AND F2_ESPECIE = 'SPED'										"+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) ON SE4.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND SE4.E4_FILIAL='"+xFilial("SE4")+"' "+CRLF
	cQuery += "AND SE4.E4_CODIGO=L1_COND "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4F (NOLOCK) ON SE4F.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND SE4F.E4_FILIAL='"+xFilial("SE4")+"' "+CRLF
	cQuery += "AND SE4F.E4_CODIGO=F2_COND "+CRLF

	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 (NOLOCK) ON SF4.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND F4_FILIAL='"+xFilial("SF4")+"' "+CRLF
	cQuery += "AND D2_TES=F4_CODIGO "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON SA3.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND A3_COD=F2_VEND1 "+CRLF

	cQuery += "WHERE F2_EMISSAO<'"+DTOS(Mv_Par01)+"' "+CRLF
	cQuery += "AND D1_NFORI<>'' "+CRLF

	If Mv_Par05==1
		cQuery += "AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	Else
		cQuery += "AND UA_XARQT BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	Endif
	cQuery += "AND SF2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND F2_ESPECIE IN('CF','SPED') "+CRLF
	cQuery += "AND D2_CF IN("+cTesVenda+") " + CRLF
	If Mv_Par05==2
		cQuery += "AND UA_XPCAQT>0 " + CRLF
	Endif
	cQuery += "AND A3_MSBLQL<>'1' "
	//cQuery += "AND F2_DOC = '069581'"

	cQuery += "GROUP BY SD2.D2_PEDIDO, F2_FILIAL,F2_DOC ,F2_SERIE ,F2_EMISSAO,F2_VEND1 ,UA_XPCAQT ,UA_XPERC,L1_FORMPG,L1_XCUSTO,SE4F.E4_FORMA, SE4.E4_FORMA,A3_NOME,A3_COD,A3_UNIDAD,A3_XTABCOM,A3_XAGLVDA,A3_CARGO,A3_NUMRA,F2_CLIENTE,F2_LOJA,L1_NUM,D1_NFORI,UA_XARQT"+CRLF

	cQuery += "UNION ALL "+CRLF

	//-----------------------------VENDAS
	//--QUERY DOS CUPONS ANALITICA
	cQuery += "SELECT F2_FILIAL FILIAL,F2_DOC NOTA ,F2_SERIE SERIE,F2_EMISSAO EMISSAO,F2_VEND1 VENDEDOR, "+CRLF
	cQuery += "ROUND(SUM(D2_PRUNIT*D2_QUANT),2) VENDA, "+CRLF
	cQuery += "ROUND(ISNULL(SUM(UB_XCUSTO*D2_QUANT),L1_XCUSTO),2) CUSTO, "+CRLF
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0),2) VLRDEV, "+CRLF
	cQuery += "ROUND(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0),2) CUSDEV, "+CRLF
	//--ARQUITETO
	cQuery += "ISNULL(UA_XPCAQT,0) ARQUITETO, "+CRLF
	cQuery += "ROUND(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100),2) VLRAQT, "+CRLF
	//--KIT
	cQuery += "ISNULL(UA_XPERC,0) KIT, "+CRLF
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2) VLRKIT, "+CRLF

	cQuery += "CASE WHEN((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)))=0 THEN'0' "+CRLF
	cQuery += "ELSE "+CRLF
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2)END AS VENDALIQ, "+CRLF

	cQuery += "CASE WHEN((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) = 0 THEN '0' "+CRLF
	cQuery += "ELSE "+CRLF
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "+CRLF
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0)-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2)END AS CUSTOLIQ, "+CRLF

	cQuery += "ROUND(((ISNULL(ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2) "+CRLF
	cQuery += "/NULLIF(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "+CRLF
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),0),0)-1)*100),2) MARKUP, "+CRLF

	cQuery += "L1_FORMPG FORMA,A3_UNIDAD LOJA,A3_NOME VEND,A3_COD CODVEN, "+CRLF
	cQuery += "A3_XTABCOM TABELA,A3_XAGLVDA AGLUTINA_VDA,A3_CARGO CARGO,A3_NUMRA NUMRH,F2_CLIENTE CODCLIENTE,F2_LOJA LJCLIENTE,CASE WHEN L1_ORCRES = '' THEN L1_NUM ELSE L1_ORCRES END PEDIDO,ISNULL(UA_XARQT,'') CODARQT "+CRLF
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 (NOLOCK) "+CRLF

	cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) ON SD2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND D2_FILIAL=F2_FILIAL "+CRLF
	cQuery += "AND D2_DOC =F2_DOC "+CRLF
	cQuery += "AND D2_SERIE=F2_SERIE "+CRLF
	cQuery += "AND D2_CLIENTE=F2_CLIENTE "+CRLF
	cQuery += "AND D2_LOJA=F2_LOJA "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) ON SB1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND B1_FILIAL='"+xFilial("SB1")+"' "+CRLF
	cQuery += "AND B1_COD=D2_COD "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK) ON SD1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND D1_FILIAL=D2_FILIAL "+CRLF
	cQuery += "AND D1_NFORI=D2_DOC "+CRLF
	cQuery += "AND D1_SERIORI=D2_SERIE "+CRLF
	cQuery += "AND D1_ITEMORI=D2_ITEM "+CRLF
	cQuery += "AND D1_COD=D2_COD "+CRLF
	cQuery += "AND D1_TIPO='D' "+CRLF
	cQuery += "AND D1_DTDIGIT BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SL1")+" SL1 (NOLOCK) ON SL1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND L1_FILIAL=F2_FILIAL "+CRLF
	cQuery += "AND L1_DOC=F2_DOC "+CRLF
	cQuery += "AND L1_SERIE=F2_SERIE "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SL2")+" SL2 (NOLOCK) ON SL2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND L2_FILIAL=L1_FILIAL "+CRLF
	cQuery += "AND L2_NUM=L1_NUM "+CRLF
	cQuery += "AND L2_ITEM=D2_ITEM "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SUB")+" SUB (NOLOCK) ON SUB.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND UB_FILIAL=L2_FILIAL "+CRLF
	cQuery += "AND UB_NUM = CASE WHEN L1_ORCRES = '' THEN L1_NUM ELSE L1_ORCRES END  "+CRLF
	//cQuery += "AND UB_ITEM=L2_ITEM "+CRLF
	cQuery += "AND UB_PRODUTO=L2_PRODUTO "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SUA")+" SUA (NOLOCK) ON SUA.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND UA_FILIAL=UB_FILIAL "+CRLF
	cQuery += "AND UA_NUM = CASE WHEN L1_ORCRES = '' THEN L1_NUM ELSE L1_ORCRES END "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) ON SE4.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND E4_FILIAL='"+xFilial("SE4")+"' "+CRLF
	cQuery += "AND E4_CODIGO=L1_COND "+CRLF

	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 (NOLOCK) ON SF4.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND F4_FILIAL='"+xFilial("SF4")+"' "+CRLF
	cQuery += "AND D2_TES=F4_CODIGO "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON SA3.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND A3_COD=F2_VEND1 "+CRLF

	cQuery += "WHERE F2_EMISSAO BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF

	If Mv_Par05==1
		cQuery += "AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	Else
		cQuery += "AND UA_XARQT BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	Endif

	cQuery += "AND SF2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND F2_ESPECIE='CF' "+CRLF
	cQuery += "AND F2_TIPO='N' "+CRLF
	cQuery += "AND D2_CF IN("+cTesVenda+") " + CRLF
	cQuery += "AND L1_SITUA='OK' "+CRLF
	If Mv_Par05==2
		cQuery += "AND UA_XPCAQT>0 " + CRLF
	Endif
	cQuery += "AND A3_MSBLQL<>'1' "
	//cQuery += "AND F2_DOC = '069581'"

	cQuery += "GROUP BY L1_ORCRES, F2_FILIAL,F2_DOC ,F2_SERIE ,F2_EMISSAO,F2_VEND1 ,UA_XPCAQT ,UA_XPERC,L1_FORMPG,L1_XCUSTO,E4_FORMA,A3_NOME,A3_COD,A3_UNIDAD,A3_XTABCOM,A3_XAGLVDA,A3_CARGO,A3_NUMRA,F2_CLIENTE,F2_LOJA,L1_NUM,UA_XARQT "+CRLF

	cQuery += "UNION ALL "+CRLF

	//-- QUERY DAS NOTAS ANALITICAS
	cQuery += "SELECT F2_FILIAL FILIAL,F2_DOC NOTA ,F2_SERIE SERIE,F2_EMISSAO EMISSAO,F2_VEND1 VENDEDOR,SUM(D2_TOTAL) VENDA, "+CRLF
	cQuery += "ROUND(ISNULL(SUM(UB_XCUSTO*D2_QUANT),0),2) CUSTO, "+CRLF
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0),2) VLRDEV, "+CRLF
	cQuery += "ROUND(ISNULL(SUM(UB_XCUSTO*D1_QUANT),0),2) CUSDEV, "+CRLF
	//--ARQUITETO
	cQuery += "ISNULL(UA_XPCAQT,0) ARQUITETO, "+CRLF
	cQuery += "ROUND(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100),2) VLRAQT, "+CRLF
	//--KIT
	cQuery += "ISNULL(UA_XPERC,0) KIT, "+CRLF
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2) VLRKIT, "+CRLF

	cQuery += "CASE WHEN((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0)))=0 THEN'0' "+CRLF
	cQuery += "ELSE "+CRLF
	cQuery += "ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0)) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2)END AS VENDALIQ, "+CRLF

	cQuery += "CASE WHEN((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) = 0 THEN '0' "+CRLF
	cQuery += "ELSE "+CRLF
	cQuery += "ROUND(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "+CRLF
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0)-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),2)END AS CUSTOLIQ, "+CRLF

	cQuery += "ROUND(((ISNULL(ROUND(ISNULL(SUM(D2_PRUNIT*D2_QUANT),0) - (ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))-(((ISNULL(SUM(D2_PRUNIT*D2_QUANT),0))-(ISNULL(SUM(D2_PRUNIT*D1_QUANT),0))) * (ISNULL(UA_XPCAQT,0)/100)),2) "+CRLF
	cQuery += "/NULLIF(((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0))-(ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) "+CRLF
	cQuery += "+((ISNULL(ISNULL(SUM(UB_XCUSTO*D2_QUANT),SUM(B1_XCUSTO*D2_QUANT)),0) - (ISNULL(ISNULL(SUM(UB_XCUSTO*D1_QUANT),SUM(B1_XCUSTO*D1_QUANT)),0))) * (ISNULL(UA_XPERC,0)/100)),0),0)-1)*100),2) MARKUP, "+CRLF

	cQuery += "E4_FORMA FORMA,A3_UNIDAD LOJA,A3_NOME VEND,A3_COD CODVEN, "+CRLF
	cQuery += "A3_XTABCOM TABELA,A3_XAGLVDA AGLUTINA_VDA,A3_CARGO CARGO,A3_NUMRA NUMRH,F2_CLIENTE CODCLIENTE,F2_LOJA LJCLIENTE,C5_NUM PEDIDO,ISNULL(UA_XARQT,'') CODARQT "+CRLF
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 (NOLOCK) "+CRLF

	cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 (NOLOCK) ON SD2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND D2_FILIAL=F2_FILIAL "+CRLF
	cQuery += "AND D2_DOC=F2_DOC "+CRLF
	cQuery += "AND D2_SERIE=F2_SERIE "+CRLF
	cQuery += "AND D2_CLIENTE=F2_CLIENT "+CRLF
	cQuery += "AND D2_LOJA=F2_LOJA "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND B1_FILIAL='"+xFilial("SB1")+"' "+CRLF
	cQuery += "AND B1_COD=D2_COD "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SD1")+" SD1 (NOLOCK) ON SD1.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND D1_FILIAL=D2_FILIAL "+CRLF
	cQuery += "AND D1_NFORI=D2_DOC "+CRLF
	cQuery += "AND D1_SERIORI=D2_SERIE "+CRLF
	cQuery += "AND D1_ITEMORI=D2_ITEM "+CRLF
	cQuery += "AND D1_COD=D2_COD "+CRLF
	cQuery += "AND D1_TIPO='D' "+CRLF
	cQuery += "AND D1_DTDIGIT BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SUB")+" SUB (NOLOCK) ON SUB.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND D2_FILIAL=UB_XLOCSAI "+CRLF
	cQuery += "AND D2_PEDIDO=UB_NUMPVE "+CRLF
	cQuery += "AND D2_ITEMPV=UB_ITEMPV "+CRLF
	cQuery += "AND D2_COD=UB_PRODUTO "+CRLF

	cQuery += "INNER JOIN "+RetSqlName("SUA")+" SUA (NOLOCK) ON SUA.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND UA_FILIAL=UB_FILIAL "+CRLF
	cQuery += "AND UA_NUM=UB_NUM "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) ON SC5.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND C5_FILIAL=D2_FILIAL "+CRLF
	cQuery += "AND C5_NUM=D2_PEDIDO "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 (NOLOCK) ON SE4.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND E4_FILIAL='"+xFilial("SE4")+"' "+CRLF
	cQuery += "AND E4_CODIGO=F2_COND "+CRLF

	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 (NOLOCK) ON SF4.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND F4_FILIAL='"+xFilial("SF4")+"' "+CRLF
	cQuery += "AND D2_TES=F4_CODIGO "+CRLF

	cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON SA3.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND A3_COD=F2_VEND1 "+CRLF

	cQuery += "WHERE F2_EMISSAO BETWEEN '"+DTOS(Mv_Par01)+"' AND '"+DTOS(Mv_Par02)+"' " + CRLF

	If Mv_Par05==1
		cQuery += "AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	Else
		cQuery += "AND UA_XARQT BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF
	Endif

	cQuery += "AND SF2.D_E_L_E_T_ =' ' "+CRLF
	cQuery += "AND F2_ESPECIE='SPED' "+CRLF
	//cQuery += "AND F2_NFCUPOM='' "+CRLF
	cQuery += "AND F2_TIPO NOT IN('D','B') "+CRLF
	cQuery += "AND D2_CF IN("+cTesVenda+") " + CRLF
	If Mv_Par05==2
		cQuery += "AND UA_XPCAQT>0 " + CRLF
	Endif
	cQuery += "AND A3_MSBLQL<>'1' "
	//cQuery += "AND F2_DOC = '000278727' "

	cQuery += "GROUP BY F2_FILIAL,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VEND1 ,UA_XPCAQT ,UA_XPERC,F2_COND,E4_FORMA,A3_NOME,A3_COD,A3_UNIDAD,A3_XTABCOM,A3_XAGLVDA,A3_CARGO,A3_NUMRA,F2_CLIENTE,F2_LOJA,C5_NUM,UA_XARQT "+CRLF

	MemoWrite("C:\TEMP\QRY2_ANALITICA.SQL",cQuery)

	TCQUERY cQuery NEW ALIAS (cQryAna)

	(cQryAna)->(DbGotop())
	While (cQryAna)->(!EOF())

		If Mv_Par05==1

			If (cQryAna)->AGLUTINA_VDA=='1'
				nPos 	:= Ascan(aTotVdas ,{|x| x[2]+x[11] == (cQryAna)->CODVEN } )
			Else
				cTabela := If( Alltrim((cQryAna)->FORMA)$cParam01,"F01","F02")
				nPos 	:= Ascan(aTotVdas ,{|x| x[2]+x[11] == (cQryAna)->CODVEN+cTabela } )
			Endif

		Else

			If !Empty((cQryAna)->CODARQT)
				//Apaga as comissoes do periodo
				nPos1 := Ascan(aVend ,(cQryAna)->CODARQT )
				If nPos1==0
					AAdd( aVend ,(cQryAna)->CODARQT )
					DeletaSE3( (cQryAna)->CODARQT )
				Endif

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//砄 valor da variavel (nPos) esta "chumbada" porque para vendedores 	 ?
				//砮xternos,nao e executada a query sintetica e portanto nao e			 ?
				//砤dicionados elementos no array [aTotVdas]                             ?
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				SA3->(DbSetOrder(1))
				If SA3->(DbSeek(xFilial("SA3") + AvKey((cQryAna)->CODARQT,"A3_COD") ))
					nPos := 1
				Else
					nPos := 0
				Endif

			Else
				nPos := 0
			Endif

		Endif

		If nPos > 0

			cCodVend := If(Mv_Par05==1,(cQryAna)->CODVEN,(cQryAna)->CODARQT)
			cNota	 := (cQryAna)->NOTA
			cSerie	 := (cQryAna)->SERIE
			dData	 := (cQryAna)->EMISSAO
			cCliente := (cQryAna)->CODCLIENTE
			cLojaCli := (cQryAna)->LJCLIENTE
			nVlrBase := If(Mv_Par05==1,(cQryAna)->VENDALIQ, If( (cQryAna)->VLRDEV==0,(cQryAna)->VENDA,((cQryAna)->VENDA - (cQryAna)->VLRDEV) ))
			nPorcCom := If(Mv_Par05==1,Round(aTotVdas[nPos,12],2),Round((cQryAna)->ARQUITETO,2))
			nComissao:= (nVlrBase*nPorcCom) / 100 //((cQryAna)->VENDALIQ*aTotVdas[nPos,12]) / 100
			nMarkup	 := If(Mv_Par05==1,Round(aTotVdas[nPos,08],2),(cQryAna)->MARKUP)
			dDtVenc	 := Mv_Par06
			cFormaPg := (cQryAna)->FORMA
			cPedido	 := (cQryAna)->PEDIDO
			cComGer	 := If(Mv_Par07==1,"E","B")
			nVlrDev	 := (cQryAna)->VLRDEV
			dEmissao := (cQryAna)->EMISSAO
			cCustoLiq:= (cQryAna)->CUSTOLIQ
			nCusDev	 := (cQryAna)->CUSDEV

			If !Empty(cCodVend)
				CalculaSE3(cCodVend,cNota,cSerie,dData,cCliente,cLojaCli,nVlrBase,nPorcCom,nComissao,nMarkup,dDtVenc,cFormaPg,cPedido,cComGer,nVlrDev,dEmissao,cCustoLiq,nCusDev)
			Endif

		Endif

		(cQryAna)->(DbSkip())
	EndDo
	(cQryAna)->(DbCloseArea())

Return


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Programa: FilMarkup     ||Data: 13/06/2013 ||Empresa: SANTIL       //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Autor: PATRICIA FONTANEZI ||Empresa: TOTVS                          //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//M骴ulo: CALL CENTER                                                 //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Descri玢o: PROCURA NA TABELA MARKUP X COMISSAO         	          //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

Static Function FilMarkup(nMarkup,cTabela,cAglutina,cForma)

	Local cQuery		:= ""
	Local nDecimal		:= 0
	Local nResMKPS		:= 0
	Local nMenorPorc	:= 0
	Local nPorc			:= 0
	Local aMKP050		:= {}

	//**********************************************************************
	// Se n鉶 achou calcula a m閐ia ponderada entre os dois mais pr髕imos
	//**********************************************************************
	//Para achar o custo use o exemplo abaixo:
	//Valor total do Produto 3.190,07
	//R$ 3.190,07 / (1+(39,39/100)) =
	//R$ 3.190,07 / 1,3939 =
	//Resultado = R$ 2.228,59
	//E assim por diante!
	//Agora some os totais de venda e do custo e em seguida fa鏰 a divis鉶;
		//R$ 14.503,17 / 10.747,04 =  1,38725
	//(1,38725 -1)*100 =
	//Resultado = 38,73
	//Se valor nao for inteiro ?preciso fazer o calculo pelo decimal para saber a media do markup

	//Nova validacao,assim nao precisaremos alterar a query,deixa fazer o processo normal,e ele sempre buscara pelo 50,e retornara para o processo normal
	nMarkup := If(nMarkup < 0 , 0 , nMarkup)
	nMarkup := RetQuery(nDecimal,nMarkup,cTabela)

	nDecimal := Round(nMarkup,4)-INT(nMarkup)
	nInteiro := INT(nMarkup)

	cQuery := "SELECT * FROM "+RetSqlName("PA1")+" PA1 WHERE PA1_TABELA = '"+cTabela+"' "
	IF nDecimal == 0
		cQuery += "AND PA1_MARKUP LIKE'"+cValToChar(nInteiro)+"%' "
	ELSE
		cQuery += "AND PA1_MARKUP BETWEEN '"+cValToChar(nInteiro)+"' AND '"+cValToChar(nInteiro+1)+"' "
	ENDIF
	cQuery += "AND PA1_FILIAL = '"+cFilAnt+"' "
	cQuery += "ORDER BY PA1_MARKUP "

	IF Select("QRY3") > 0
		DbSelectArea("QRY3")
		DbCloseArea()
	ENDIF

	TcQuery cQuery New Alias "QRY3"

	DbSelectArea("QRY3")
	While QRY3->( !Eof() )

		If cAglutina=='1'

			nPorc := QRY3->PA1_FATURA

		ElseIf cAglutina=='2'

			IF cForma == "F01"
				nPorc := QRY3->PA1_AVISTA
			ELSE
				nPorc := QRY3->PA1_FATURA
			ENDIF

		Endif

		AADD(aMKP050,{nPorc,QRY3->PA1_MARKUP})
		QRY3->(DbSkip())
	ENDDO

	//CASO HAJA DECIMAIS,O TAMANHO DO ARRAY SERA MAIOR QUE 1,POIS TEREMOS QUE FAZER A MEDIA DOS MARKUPS
	IF Len(aMKP050) > 1
		nMenorMKP	:= aMKP050[1,2]
		nMenorPorc	:= aMKP050[1,1]

		//SUBTRAI AS DUAS PORCENTAGENS DE MARKUP ENCONTRADA
		If aMKP050[1][1] > aMKP050[2,1]
			nResMKPS := aMKP050[1,1]-aMKP050[2,1]
		Else
			nResMKPS := aMKP050[2,1]-aMKP050[1,1]
		Endif

		//Multiplicar o Menor MKP achado,pelo resultado da Subtracao e dividir por 100,pois eh porcentagem
		nResMKPS	:= (nResMKPS*nDecimal)///100

		//somar o valor da Menor porcentagem resultada da query e o resultado da multiplicacao acima,ele resultara no markup medio
		nResMKPS	:= Round(nMenorPorc + Round(nResMKPS,3),4)
	Else
		nResMKPS	:= nPorc
	Endif

Return(nResMKPS)

//------------------------------------------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------------------------------------------
Static Function RetQuery(nDec,nMarkup,cTabela)
	Local cAlias    := GetNextAlias()
	Local cQry		:= ""

	nDec  		:= Round(nMarkup,4)-INT(nMarkup)
	nInteiro	:= INT(nMarkup)

	//VERIFICA SE NAO TEM DECIMAL E O MARKUP INTEIRO NA TABELA DE MARKUP
	cQry := "SELECT * FROM "+RetSqlName("PA1") + " WHERE PA1_TABELA = '"+cTabela+"' "
	IF nDec == 0
		cQry += " AND PA1_MARKUP LIKE '"+cValToChar(nInteiro)+"%' "
	ELSE
		cQry += " AND PA1_MARKUP BETWEEN '"+cValToChar(nInteiro)+"' AND '"+cValToChar(nInteiro+1)+"' "
	ENDIF
	cQry += " AND PA1_FILIAL = '"+CFILANT+"' "
	cQry += " ORDER BY PA1_MARKUP "

	TcQuery cQry New Alias (cAlias)

	Count to nRec

	(cAlias)->(DbGotop())
	IF nRec == 0
		nMarkup :=	GetMv("SY_MARKUP",,50.00)
	EndIf

	(cAlias)->(dbCloseArea())

Return(nMarkup)

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矰eletaSE3 篈utor  ?SYMM Consultoria	 ?Data ? 18/08/15   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Deleta todos os registros de comissao do vendedor selecio- 罕?
北?         ?nado                                                       罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function DeletaSE3(cVendedor)

	Local cQuery := " UPDATE "+RetSqlName("SE3")+" SET D_E_L_E_T_ = '*' FROM "+RetSqlName("SE3")+" SE3 WHERE SE3.E3_FILIAL = '"+xFilial("SE3")+"' AND SE3.E3_VEND = '"+cVendedor+"' AND SE3.D_E_L_E_T_ = ' ' AND SE3.E3_DATA = '' AND SE3.E3_TIPO <> 'CR' AND SE3.E3_TIPO <> 'AB-' "

	If (TCSQLExec(cQuery) < 0)
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  砈yTrataPar篈utor  ?SYMM Consultoria   ?Data ?15/03/2011  罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     矱fetua formata玢o das parametro,substituindo os tra鏾s (-),罕?
北?         硃or v韗gulas (,) para que o parametro seja utilizada querys.罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/
User Function SyTrataPar(cParQry)

	Local aArea		:= GetArea()
	Local cRetorna 	:= ''
	Local nX

	For nX:= 1 To Len(cParQry)
		If (SubStr(cParQry,nX,1) == '|')
			cRetorna+= "','"
		Else
			cRetorna+= SubStr(cParQry,nX,1)
		EndIf
	Next nX

	cRetorna := "'" + cRetorna + "'"

	RestArea(aArea)

Return cRetorna

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矨justaSx1 篈utor  ?SYMM Consultoria	 ?Data ? 20/05/15   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Cria Perguntas na SX1 atraves da funcao PUTSX1().          罕?
北?         ?                                                           罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function AjustaSX1(cPerg)

	Local aHlpPor01 := {"Informar a data inicial para C醠culo da Comissao."	,""}
	Local aHlpPor02 := {"Informar a data final para C醠culo da Comissao."	,""}
	Local aHlpPor03 := {"Informar o codigo de Vendedor inicial.",""}
	Local aHlpPor04 := {"Informar o codigo de Vendedor final.",""}
	Local aHlpPor05 := {"Informar a tabela de comiss鉶.",""}
	Local aHlpPor06 := {"Tipo do Vendedor 1=Interno e","2=Externo"}
	Local aHlpPor07 := {"Informar o vencimento.",""}
	Local aHlpPor08 := {"Comissao gerada 1=Emissao","2=Baixa"}

	PutSx1(cPerg,"01","Da Data Emissao"			,"Da Data Emissao"		,"Da Data Emissao"		,"MV_CH1","D",TamSx3("D1_EMISSAO")[1]	,0,0,"G","",""		,"","","mv_par01","","","","","","","","","","","",""," ","","","",aHlpPor01)
	PutSx1(cPerg,"02","Ate Data Emissao"		,"Ate Data Emissao"		,"Ate Data Emissao"		,"MV_CH2","D",TamSx3("D1_EMISSAO")[1]	,0,0,"G","",""		,"","","mv_par02","","","","","","","","","","","",""," ","","","",aHlpPor02)
	PutSx1(cPerg,"03","Do Vendedor"				,"Do Vendedor"			,"Do Vendedor"			,"MV_CH3","C",TamSx3("A3_COD")[1]		,0,0,"G","","SA3"	,"","","mv_par03","","","","","","","","","","","",""," ","","","",aHlpPor03)
	PutSx1(cPerg,"04","Ate Vendedor"			,"Ate Vendedor"			,"Ate Vendedor"			,"MV_CH4","C",TamSx3("A3_COD")[1]		,0,0,"G","","SA3"	,"","","mv_par04","","","","","","","","","","","",""," ","","","",aHlpPor04)
	PutSx1(cPerg,"05","Tipo" 	    			,"Tipo"					,"Tipo"  				,"MV_CH6","N",1							,0,1,"C",""	,""		,"","","mv_par05","Interno","Interno","Interno"	,,"Externo","Externo","Externo"	,"","","","","","","","","",aHlpPor05)
	PutSx1(cPerg,"06","Vencimento"				,"Vencimento"			,"Vencimento"			,"MV_CH7","D",TamSx3("D1_EMISSAO")[1]	,0,0,"G","",""		,"","","mv_par06","","","","","","","","","","","",""," ","","","",aHlpPor06)
	PutSx1(cPerg,"07","Comiss鉶 Gerada" 	    ,"Comiss鉶 Gerada"		,"Comiss鉶 Gerada" 		,"MV_CH8","N",1							,0,1,"C",""	,""		,"","","mv_par07","Emissao","Emissao","Emissao"	,,"Baixa","Baixa","Baixa"	,"","","","","","","","","",aHlpPor07)
	//PutSx1(<cGrupo>		,<cOrdem>	,<cPergunt>				,<cPerSpa>				,<cPerEng>				,<cVar>		,<cTipo>	,<nTamanho>	,<nDecimal>,<nPresel>	,<cGSC>	,<cValid>	,<cF3>	,<cGrpSxg>	,<cPyme>	,<cVar01>	,<cDef01>		,<cDefSpa1>		,<cDefEng1>		,<cCnt01>	,<cDef02>	,<cDefSpa2>	,<cDefEng2>	,<cDef03>		,<cDefSpa3>		,<cDefEng3>		,<cDef04>				,<cDefSpa4>				,<cDefEng4>				,<cDef05>	,<cDefSpa5>	,<cDefEng5>	,<aHelpPor>	,<aHelpEng>	,<aHelpSpa>	,<cHelp>)

Return

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐?
北篜rograma  矯alculaSE3篈utor  ?SYMM Consultoria	 ?Data ? 24/08/15   罕?
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡?
北篋esc.     ?Atualiza o cadastro de manutencao de comissoes (SE3).      罕?
北?         ?                                                           罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function CalculaSE3(cCodVend,cNota,cSerie,dData,cCliente,cLojaCli,nVlrBase,nPorcCom,nComissao,nMarkup,dDtVenc,cFormaPg,cPedido,cComGer,nVlrDev,dEmissao,cCustoLiq,nCusDev)

	Local aArea  	:= GetArea()
	Local cSeq	 	:= "01"
	Local cPrefixo 	:= "MAN"
	Local lGrava 	:= .T.
	Local lNovo
	Local aAreaSE3

	DbSelectArea("SE3")
	DbSetOrder(3)
	If !DbSeek(xFilial("SE3") + AvKey(cCodVend,"E3_VEND") + AvKey(cCliente,"E3_CODCLI") + AvKey(cLojaCli,"E3_LOJA") + AvKey(cSerie,"E3_PREFIXO") + AvKey(cNota,"E3_NUM") )
		lNovo := .T.
	Else
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//砊ratamento para inclusao de um novo registro no SE3.  ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		aAreaSE3 := GetArea()
		cSeq 	 := UltmItem(cCodVend,cNota,cSerie)
		cSeq 	 := Soma1(cSeq)
		lNovo 	 := .T.

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//矰evolucao total da venda e comissao ainda nao foi paga	  ?
		//砃esta situacao sera deletado o registroistro posicionado   ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		If nVlrBase == 0 .And. Empty(SE3->E3_DATA)
			RecLock("SE3",.F.)
			DbDelete()
			Msunlock()
			lGrava := .F.
		Endif

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		//矰evolucao total da venda e comissao ja foi paga			 			?
		//砃esta siatuacao sera incluido um novo registro com valores negativos	?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
		If nVlrBase==0 .And. !Empty(SE3->E3_DATA)
			nVlrBase	:= SE3->E3_BASE  *(-1)
			nPorcCom	:= SE3->E3_PORC  *(-1)
			nComissao	:= SE3->E3_COMIS *(-1)
			lGrava 		:= PesqSE3(cCodVend,cNota,cSerie,nComissao) //.T.
			lNovo 		:= .T.
		Endif

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矰evolucao parcial da venda e comissao ainda nao foi paga 									   ?
		//砃esta siatuacao sera alterado os valores da comissao conforme recebido nos parametros da funcao ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		/*If nVlrDev > 0 .And. nVlrBase > 0 .And. Empty(SE3->E3_DATA)
		If SE3->E3_BASE	<> nVlrBase
			cSeq   := SE3->E3_SEQ
			lGrava := .T.
			lNovo  := .T.
		Endif
	Endif*/

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//矰evolucao parcial da venda e comissao ja foi paga ou nao paga		?
	//砃esta siatuacao sera incluido um novo registro com valores negativos	?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	If nVlrDev > 0 .And. nVlrBase > 0 .And.  ( !Empty(SE3->E3_DATA) .Or. Empty(SE3->E3_DATA) )

		//Verifica se a base de calculo sao diferente, caso seja igual calcular a diferenca dos percentuais
		If SE3->E3_BASE	<> nVlrBase .OR. SE3->E3_BASE == nVlrDev
			/*nVlrBase	:= nVlrBase *(-1)
			nPorcCom	:= nPorcCom *(-1)
			nComissao	:= nComissao*(-1)*/

			//Verifica se a devolucao e referente ao periodo anterior
			If dEmissao < Dtos(Mv_Par01)
				nVlrBase	:= nVlrDev  *(-1)
				nPorcCom	:= nPorcCom *(-1)
				nComissao	:= (nVlrDev * nPorcCom) / 100
				lGrava 		:= .T.
				lNovo 		:= .T.
			Else
				If !Empty(SE3->E3_DATA)
					//Armazeno os valores anteriores para calcular apos a inclusao do novo registro
					nBaseOld	:= nVlrBase
					nPorcAnt	:= nPorcCom

					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
					//矴rava um novo registro com o valor da devolucao e o        ?
					//硃ercetual da comissao anterior para abater da comissao 	  ?
					//硄ue ja foi paga.                                           ?
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
					nPorcNew	:= SE3->E3_PORC * (-1)
					nVlrBase	:= nVlrDev * (-1)
					nComissao	:= (nVlrDev * nPorcNew) / 100
					GeraSE3(.T.,.T.,cCodVend,cNota,cSerie,dData,cCliente,cLojaCli,nVlrBase,nPorcNew,nComissao,nMarkup,dDtVenc,cFormaPg,cPedido,cComGer,cSeq,cCustoLiq,nCusDev)

					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//矨 variavel (nVlrBase) sera zerado para nao duplicar o valor da venda  ?
					//?E3_BASE), especifico SANTIL e autorizado pelo Fernando	  			 ?
					//矱 do conhecimento que este campo e obrigatorio.            			 ?
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪 ?
					cSeq 	 	:= UltmItem(cCodVend,cNota,cSerie)
					cSeq 	 	:= Soma1(cSeq)
					nVlrBase	:= 0
					nPorcCom	:= nPorcAnt - (nPorcNew * -1)
					nComissao	:= Round( (nBaseOld*nPorcCom) / 100 ,2)
					lGrava 		:= .T.
					lNovo  		:= .T.
				Endif
			Endif
		Else
			//Calcula a diferenca dos percentuais.
			nPorcCom	:= nPorcCom - SE3->E3_PORC
			nComissao	:= Round( (nVlrBase*nPorcCom) / 100 ,2)
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//矨 variavel (nVlrBase) sera zerado para nao duplicar o valor da venda  ?
			//?E3_BASE), especifico SANTIL e autorizado pelo Fernando	  			 ?
			//矱 do conhecimento que este campo e obrigatorio.            			 ?
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪 ?
			nVlrBase	:= 0
			lGrava 		:= .T.
			lNovo 		:= .T.
		Endif
	Endif

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//砇ecalculo no fechamento mensal															?
	//砃esta situacao encontra a diferen鏰 entre os percentuais de comiss鉶 no periodo inteiro 	?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	If (nVlrBase > 0) .And. (nVlrDev = 0) .And. (!Empty(SE3->E3_DATA))
		nPorcCom	:= nPorcCom - SE3->E3_PORC
		nComissao	:= Round( (nVlrBase*nPorcCom) / 100 ,2)
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矨 variavel (nVlrBase) sera zerado para nao duplicar o valor da venda  ?
		//?E3_BASE), especifico SANTIL e autorizado pelo Fernando	  			 ?
		//矱 do conhecimento que este campo e obrigatorio.            			 ?
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪 ?
		nVlrBase	:= 0
		lGrava 		:= .T.
		lNovo 		:= .T.
	Endif

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	//砇ecalculo no fechamento mensal													?
	//砃esta situacao quando os markups forem identicos nao ser?incluido o registro 	?
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪?
	While !Eof() .And. SE3->E3_FILIAL + SE3->E3_VEND + SE3->E3_CODCLI + SE3->E3_LOJA + SE3->E3_PREFIXO + SE3->E3_NUM == xFilial("SE3") + AvKey(cCodVend,"E3_VEND") + AvKey(cCliente,"E3_CODCLI") + AvKey(cLojaCli,"E3_LOJA") + AvKey(cPrefixo,"E3_PREFIXO") + AvKey(cNota,"E3_NUM")
		
		If (SE3->E3_XMKMEDT == nMarkup) .OR. (nPorcCom == SE3->E3_PORC) //.And. (SE3->E3_PEDIDO ==  cPedido)
			lGrava 	:= .F.
			Exit
		Endif
		
		DbSelectArea("SE3")
		DbSkip()
	End

	RestArea(aAreaSE3)

Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矴rava os dados da comissao calculada?
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
GeraSE3(lGrava,lNovo,cCodVend,cNota,cSerie,dData,cCliente,cLojaCli,nVlrBase,nPorcCom,nComissao,nMarkup,dDtVenc,cFormaPg,cPedido,cComGer,cSeq,cCustoLiq,nCusDev)

RestArea(aArea)

Return

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯退屯屯屯脱屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯槐?
北篜rograma  砋ltmItem   篈utor  ?SYMM				  ?Data ?22/07/11   罕?
北掏屯屯屯屯拓屯屯屯屯屯褪屯屯屯拖屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯贡?
北篋esc.     ?Retorna o numero do ultimo item da sequencia da comissao	  罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?SYMM                                                       罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/
Static Function UltmItem(cVendedor,cNumero,cSerie)

	Local aAreaAtu 	:= GetArea()
	Local cQuery	:= ""
	Local cAlias	:= CriaTrab(,.F.)
	Local cRet		:= StrZero(0,TAMSX3("DA1_ITEM")[1])

	cQuery += "SELECT ISNULL(MAX(E3_SEQ),'00') ULTMITEM "
	cQuery += "FROM "+RetSqlName("SE3")+" SE3 "
	cQuery += "WHERE "
	cQuery += "SE3.E3_FILIAL 		= '"+xFilial("SE3")+"' "
	cQuery += "AND SE3.E3_VEND		= '"+cVendedor+"' "
	cQuery += "AND SE3.E3_NUM		= '"+cNumero+"' "
	cQuery += "AND SE3.E3_SERIE		= '"+cSerie+"' "
	cQuery += "AND SE3.D_E_L_E_T_ 	<> '*' "

	//谀哪哪哪哪哪哪哪哪哪哪??
	//矱xecuta Query gerada  ?
	//滥哪哪哪哪哪哪哪哪哪哪??
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAlias,.T.,.T.)

	While (cAlias)->(!EOF())
		cRet := (cAlias)->ULTMITEM
		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aAreaAtu)

Return cRet

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯退屯屯屯脱屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯槐?
北篜rograma  ?GeraSE3   篈utor  ?SYMM				  ?Data ?10/09/15   罕?
北掏屯屯屯屯拓屯屯屯屯屯褪屯屯屯拖屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯贡?
北篋esc.     ?Grava os dados da comissao calculada.                   	  罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?SYMM                                                       罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/

Static Function GeraSE3(lGrava,lNovo,cCodVend,cNota,cSerie,dData,cCliente,cLojaCli,nVlrBase,nPorcCom,nComissao,nMarkup,dDtVenc,cFormaPg,cPedido,cComGer,cSeq,cCustoLiq,nCusDev)

	If lGrava .And. nPorcCom <> 0
		
		RecLock("SE3",lNovo)
		
		SE3->E3_FILIAL	:= xFilial("SE3")
		SE3->E3_VEND	:= cCodVend
		SE3->E3_NUM		:= cNota
		SE3->E3_EMISSAO	:= Stod(dData)
		SE3->E3_SERIE	:= cSerie
		SE3->E3_CODCLI	:= cCliente
		SE3->E3_LOJA	:= cLojaCli
		SE3->E3_BASE	:= nVlrBase
		SE3->E3_PORC	:= nPorcCom//IIF( nVlrBase > 0 , nPorcCom, 0)
		SE3->E3_COMIS	:= nComissao//IIF( nVlrBase > 0 , nComissao, 0)
		SE3->E3_SEQ		:= cSeq
		SE3->E3_PREFIXO	:= cSerie //cPrefixo
		SE3->E3_TIPO	:= cFormaPg
		SE3->E3_PEDIDO	:= cPedido
		SE3->E3_BAIEMI	:= cComGer
		SE3->E3_VENCTO	:= dDtVenc
		SE3->E3_XMKMEDT	:= nMarkup
		SE3->E3_MOEDA	:= "01"
		If SE3->(FieldPos("E3_XCUSTO")) > 0
			If !(nVlrBase == 0)
				SE3->E3_XCUSTO	:= If(nVlrBase > 0 , cCustoLiq, nCusDev*(-1))
			EndIf
		Endif
		Msunlock()
		
	Endif

Return

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
北赏屯屯屯屯脱屯屯屯屯屯退屯屯屯脱屯屯屯屯屯屯屯屯屯屯送屯屯脱屯屯屯屯屯屯槐?
北篜rograma  砅esqSE3    篈utor  ?SYMM				  ?Data ?22/07/11   罕?
北掏屯屯屯屯拓屯屯屯屯屯褪屯屯屯拖屯屯屯屯屯屯屯屯屯屯释屯屯拖屯屯屯屯屯屯贡?
北篋esc.     ?Pesquisa registro existente na Base de Dados	  			  罕?
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡?
北篣so       ?SYMM                                                       罕?
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急?
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北?
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌?/
Static Function PesqSE3(cVendedor,cNumero,cSerie,nVlrCom)

	Local aAreaAtu 	:= GetArea()
	Local cQuery	:= ""
	Local cAlias	:= CriaTrab(,.F.)
	Local lOk		:= .T.

	cQuery += "SELECT E3_NUM FROM "+RetSqlName("SE3")+" SE3 "
	cQuery += "WHERE "
	cQuery += "SE3.E3_FILIAL 		= '"+xFilial("SE3")+"' "
	cQuery += "AND SE3.E3_VEND		= '"+cVendedor+"' "
	cQuery += "AND SE3.E3_NUM		= '"+cNumero+"' "
	cQuery += "AND SE3.E3_SERIE		= '"+cSerie+"' "
	cQuery += "AND SE3.E3_COMIS		= "+Alltrim(Str(nVlrCom))+" "
	cQuery += "AND SE3.D_E_L_E_T_ 	<> '*' "

	//谀哪哪哪哪哪哪哪哪哪哪??
	//矱xecuta Query gerada  ?
	//滥哪哪哪哪哪哪哪哪哪哪??
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cQuery)),cAlias,.T.,.T.)

	While (cAlias)->(!EOF())
		lOk := IF( !Empty((cAlias)->E3_NUM) , .F., .T.)
		(cAlias)->(dbSkip())
	EndDo

	(cAlias)->(dbCloseArea())

	RestArea(aAreaAtu)

Return lOk