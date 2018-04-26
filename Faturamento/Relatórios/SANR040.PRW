#INCLUDE "Protheus.ch"
#include 'parmtype.ch'
#INCLUDE "RWMAKE.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+@description:Relatório de Faturamento Por Vendedor    +
//+@Author	   :Leonardo Espinosa					     +
//+@version	   :1.0										 +
//+@since 	   :04/02/2016							     +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++

User Function SANR040()
	Private cPerg	:= PADR("SANR040",10)

	AjustaSX1(cPerg)
	If Pergunte(cPerg,.T.)
		oReport := ReportDef()
		oReport:PrintDialog()
	EndIf
Return Nil

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+@description:Relatório de Faturamento Por Vendedor	 +
//+@Author	   :Luiz Fernando O. Mendes					 +
//+@version	   :3.0										 +
//+@since 	   :17/02/2017								 +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Static Function ReportDef()

Local oBreak,oBreak1, oCell, oReport, oSection 
Local cPerg	  := PADR("SANR040",10)
Local cReport := "SANR040"
Local cTitulo := ""
Local cDescri := "Este programa irá emitir a relação de faturamento contábil."

cTitulo := "Relatório de faturamento contábil"+If(Mv_Par07==1," (Analitico)"," (Sintetico)")

oReport := TReport():New("SANR040","Relatório de faturamento contábil"+If(Mv_Par07==1," (Analitico)"," (Sintetico)"),,{|oReport| ReportPrint(oReport)},"Relatório de faturamento contábil"+If(Mv_Par07==1," (Analitico)"," (Sintetico)"))

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+Sessao 1 (oSection1)                                  +
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
                                                    
oSection1 := TRSection():New(oReport, "Relatório de faturamento contábil", {"SF2","SD2"}, {"Por Filial"} )
	oReport:SetTotalInline(.F.)
	oReport:SetLandscape(.F.)
	oReport:SetUseGC(.F.)
	oReport:oPage:setPaperSize(9)
	oReport:nFontBody := 10
	oReport:nColspace := 2

                        
	If Mv_Par07 == 1
		TRCell():New(oSection1,"FILIAL" 		,,"Filial"		 	,PesqPict("SD2","D2_FILIAL")  ,TamSX3("D2_FILIAL")	[1], .F.,)
		TRCell():New(oSection1,"EMISSAO"		,,"Emissao"		 	,PesqPict("SD2","D2_EMISSAO") ,TamSX3("D2_EMISSAO")	[1], .F.,)
		TRCell():New(oSection1,"NOTA" 			,,"Nota"		 	,PesqPict("SD2","D2_DOC")     ,TamSX3("D2_DOC")		[1], .F.,)
		TRCell():New(oSection1,"SERIE" 			,,"Serie"		 	,PesqPict("SD2","D2_SERIE")   ,TamSX3("D2_SERIE")	[1], .F.,)
		TRCell():New(oSection1,"CFOP" 			,,"Cfop"		 	,PesqPict("SD2","D2_CF")      ,TamSX3("D2_CF")		[1], .F.,)
		TRCell():New(oSection1,"TOTAL_NOTA" 	,,"Total Nota"	 	,PesqPict("SD2","D2_TOTAL")   ,TamSX3("D2_TOTAL")	[1], .F.,)
		TRCell():New(oSection1,"TOTAL_PRODUTOS" ,,"Total Produtos" 	,PesqPict("SD2","D2_TOTAL")   ,TamSX3("D2_TOTAL")	[1], .F.,)
		TRCell():New(oSection1,"ICMS" 			,,"Icms"		 	,PesqPict("SD2","D2_VALICM")  ,TamSX3("D2_VALICM")	[1], .F.,)
		TRCell():New(oSection1,"ICMS_ST" 		,,"Icms ST"			,PesqPict("SD2","D2_ICMSRET") ,TamSX3("D2_ICMSRET")	[1], .F.,)
		TRCell():New(oSection1,"PIS" 			,,"Pis"		 		,PesqPict("SD2","D2_VALIMP6") ,TamSX3("D2_VALIMP6")	[1], .F.,)
		TRCell():New(oSection1,"COFINS" 		,,"Cofins"			,PesqPict("SD2","D2_VALIMP5") ,TamSX3("D2_VALIMP5")	[1], .F.,)
		TRCell():New(oSection1,"IPI" 			,,"Ipi"			 	,PesqPict("SD2","D2_VALIPI")  ,TamSX3("D2_VALIPI")	[1], .F.,)
		TRCell():New(oSection1,"FRETE"	 		,,"Frete"		 	,PesqPict("SD2","D2_VALFRE")  ,TamSX3("D2_VALFRE")	[1], .F.,)
		TRCell():New(oSection1,"CONDICAO" 		,,"Condição"	 	,PesqPict("SF2","F2_COND")    ,TamSX3("F2_COND")	[1], .F.,)
		TRCell():New(oSection1,"FORMA" 		    ,,"Forma"		 	,PesqPict("SE4","E4_FORMA")   ,TamSX3("E4_FORMA")	[1], .F.,)
		TRCell():New(oSection1,"DESCRICAO" 		,,"Nome Condição" 	,PesqPict("SE4","E4_DESCRI")  ,TamSX3("E4_DESCRI")	[1], .F.,)
	Else
		TRCell():New(oSection1,"FILIAL" 		,,"Filial"		 	,PesqPict("SD2","D2_FILIAL")  ,TamSX3("D2_FILIAL")	[1], .F.,)
		TRCell():New(oSection1,"TOTAL_NOTA" 	,,"Total Nota"	 	,PesqPict("SD2","D2_TOTAL")   ,TamSX3("D2_TOTAL")	[1], .F.,)
		TRCell():New(oSection1,"TOTAL_PRODUTOS"	,,"Total Produtos" 	,PesqPict("SD2","D2_TOTAL")   ,TamSX3("D2_TOTAL")	[1], .F.,)
		TRCell():New(oSection1,"ICMS" 			,,"Icms"		 	,PesqPict("SD2","D2_VALICM")  ,TamSX3("D2_VALICM")	[1], .F.,)
		TRCell():New(oSection1,"ICMS_ST"		,,"Icms ST"			,PesqPict("SD2","D2_ICMSRET") ,TamSX3("D2_ICMSRET")	[1], .F.,)
		TRCell():New(oSection1,"PIS"		 	,,"Pis"			 	,PesqPict("SD2","D2_VALIMP6") ,TamSX3("D2_VALIMP6")	[1], .F.,)
		TRCell():New(oSection1,"COFINS"		 	,,"Cofins"		 	,PesqPict("SD2","D2_VALIMP5") ,TamSX3("D2_VALIMP5")	[1], .F.,)
		TRCell():New(oSection1,"IPI"	 		,,"IPI"			 	,PesqPict("SD2","D2_VALIPI")  ,TamSX3("D2_VALIPI")	[1], .F.,)
		TRCell():New(oSection1,"FRETE"	 		,,"Frete"		 	,PesqPict("SD2","D2_VALFRE")  ,TamSX3("D2_VALFRE")	[1], .F.,)
		TRCell():New(oSection1,"QTD_NOTAS"		,,"Qtd. Notas"	 	,"@E 99,999,999"	  	      ,10                , .F.,)
	Endif

	If Mv_Par07 == 1
		oSection1:Cell("TOTAL_NOTA")	:SetHeaderAlign("RIGHT")
		oSection1:Cell("TOTAL_PRODUTOS"):SetHeaderAlign("RIGHT")
		oSection1:Cell("ICMS")			:SetHeaderAlign("RIGHT")
		oSection1:Cell("ICMS_ST")		:SetHeaderAlign("RIGHT")
		oSection1:Cell("PIS")			:SetHeaderAlign("RIGHT")
		oSection1:Cell("COFINS")		:SetHeaderAlign("RIGHT")
		oSection1:Cell("IPI")			:SetHeaderAlign("RIGHT")
		oSection1:Cell("FRETE")			:SetHeaderAlign("RIGHT")
	Else
		oSection1:Cell("TOTAL_NOTA")	:SetHeaderAlign("RIGHT")
		oSection1:Cell("TOTAL_PRODUTOS"):SetHeaderAlign("RIGHT")
		oSection1:Cell("ICMS")			:SetHeaderAlign("RIGHT")
		oSection1:Cell("ICMS_ST")		:SetHeaderAlign("RIGHT")
		oSection1:Cell("PIS")			:SetHeaderAlign("RIGHT")
		oSection1:Cell("COFINS")		:SetHeaderAlign("RIGHT")
		oSection1:Cell("IPI")			:SetHeaderAlign("RIGHT")
		oSection1:Cell("FRETE")			:SetHeaderAlign("RIGHT")
		oSection1:Cell("QTD_NOTAS")		:SetHeaderAlign("RIGHT")
	Endif
	
	If Mv_Par07 == 1
		oBreak := TRBreak():New( oSection1, {||.T.},"Totais")
		TRFunction():New(oSection1:Cell("TOTAL_NOTA")		,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("TOTAL_PRODUTOS") 	,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("ICMS") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("ICMS_ST") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("PIS") 				,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("COFINS") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("IPI") 				,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("FRETE") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
	else	
		oBreak := TRBreak():New( oSection1, {||.T.},"Totais")
		TRFunction():New(oSection1:Cell("TOTAL_NOTA")		,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("TOTAL_PRODUTOS") 	,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("ICMS") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("ICMS_ST") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("PIS") 				,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("COFINS") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("IPI") 				,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("FRETE") 			,Nil,"SUM",oBreak,,,,.F.,.F.)
		TRFunction():New(oSection1:Cell("QTD_NOTAS")		,Nil,"SUM",oBreak,,,,.F.,.F.)
	Endif

Return( oReport )

Static Function ReportPrint( oReport )

Local cQuery       	:= ""
Local cAlias       	:= GetNextAlias()
Local oSection1 	:= oReport:Section(1)
Local nOrdem 	   	:= oSection1:GetOrder()
Local cTesVenda		:= ""

cTesVenda := U_SyTrataPar( GetMv("MV_SCFOVD1",,"5101|5102|5103|5104|5105|5106|5109|5110|5111|5112|5113|5114|5115|5116|5117|5118|5119|5120|5122|5123|5251|5252|5253|5254|5255|5256|5257|5258|5401|5402|5403|5405|5501|5502|5551|5922") )
cTesVenda += ","
cTesVenda += U_SyTrataPar( GetMv("MV_SCFOVD2",,"6101|6102|6103|6104|6105|6106|6108|6109|6110|6111|6112|6113|6114|6115|6116|6117|6118|6119|6120|6122|6123|6251|6252|6253|6254|6255|6256|6257|6258|6401|6402|6403|6404|6405|6501|6502|6551|6922|6404") )
													
//Sintetico
	If Mv_Par07 == 2
		cQuery := " SELECT 	D2_FILIAL FILIAL, " + CRLF 
		cQuery += "	ROUND(SUM(D2_TOTAL+D2_ICMSRET+D2_VALFRE+D2_VALIPI),2) TOTAL_NOTA, " + CRLF 
		cQuery += " ROUND(SUM(D2_TOTAL),2) TOTAL_PRODUTOS, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALICM),2) ICMS, " + CRLF 
		cQuery += " ROUND(SUM(D2_ICMSRET),2) ICMS_ST, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALIMP6),2) PIS, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALIMP5),2) COFINS, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALIPI),2) IPI, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALFRE),2) FRETE, " + CRLF
		cQuery += " COUNT(DISTINCT(F2_DOC+F2_SERIE)) QTD_NOTAS " + CRLF
		cQuery += " FROM "+RetSqlName("SD2")+" SD2  " + CRLF 
		cQuery += " INNER JOIN "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) ON SF2.D_E_L_E_T_ = '' " + CRLF
		cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL  " + CRLF
		cQuery += " AND SF2.F2_DOC = SD2.D2_DOC  " + CRLF
		cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE " + CRLF 
		cQuery += " AND SF2.F2_CLIENTE = SD2.D2_CLIENTE " + CRLF
		cQuery += " AND SF2.F2_LOJA = SD2.D2_LOJA " + CRLF
		cQuery += " WHERE	SD2.D2_EMISSAO BETWEEN '"+DTOS(Mv_Par05)+"' AND '"+DTOS(Mv_Par06)+"' " + CRLF 
		cQuery += " AND SD2.D_E_L_E_T_ = '' " + CRLF 
		cQuery += " AND SD2.D2_TIPO = 'N' " + CRLF 
		cQuery += " AND SF2.F2_ESPECIE IN ('CF','SPED', 'NFCE', 'SATCE') " + CRLF 
		cQuery += " AND D2_CF IN ("+cTesVenda+") " + CRLF 
		cQuery += " AND D2_FILIAL BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"' " + CRLF 
		cQuery += " AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF 
		cQuery += " GROUP BY SD2.D2_FILIAL " + CRLF 
	Else
		//Analitico
		cQuery := " SELECT 	D2_FILIAL FILIAL, D2_EMISSAO EMISSAO, D2_DOC NOTA, D2_SERIE SERIE, D2_CF CFOP, " + CRLF 
		cQuery += "	ROUND(SUM(D2_TOTAL+D2_ICMSRET+D2_VALFRE+D2_VALIPI),2) TOTAL_NOTA, " + CRLF 
		cQuery += " ROUND(SUM(D2_TOTAL),2) TOTAL_PRODUTOS, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALICM),2) ICMS, " + CRLF 
		cQuery += " ROUND(SUM(D2_ICMSRET),2) ICMS_ST, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALIMP6),2) PIS, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALIMP5),2) COFINS, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALIPI),2) IPI, " + CRLF 
		cQuery += " ROUND(SUM(D2_VALFRE),2) FRETE, " + CRLF 
		cQuery += " F2_COND CONDICAO, " + CRLF 
		cQuery += " IIF(F2_COND = 'CN','CN',E4_FORMA) FORMA, " + CRLF 
		cQuery += " IIF(F2_COND = 'CN','FORMA ALTERADA',E4_DESCRI) DESCRICAO " + CRLF 
		cQuery += " FROM "+RetSqlName("SD2")+" SD2 " + CRLF 
		cQuery += " INNER JOIN "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) ON SF2.D_E_L_E_T_ = '' " + CRLF
		cQuery += " AND SF2.F2_FILIAL = SD2.D2_FILIAL " + CRLF
		cQuery += " AND SF2.F2_DOC = SD2.D2_DOC " + CRLF
		cQuery += " AND SF2.F2_SERIE = SD2.D2_SERIE " + CRLF
		cQuery += " AND SF2.F2_CLIENTE = SD2.D2_CLIENTE " + CRLF
		cQuery += " AND SF2.F2_LOJA = SD2.D2_LOJA " + CRLF
		cQuery += " LEFT JOIN "+RetSqlName("SE4")+" SE4 WITH (NOLOCK) ON SE4.D_E_L_E_T_ = '' " + CRLF
		cQuery += " AND SE4.E4_FILIAL = '' " + CRLF
		cQuery += " AND SE4.E4_CODIGO=SF2.F2_COND " + CRLF 
		cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '"+DTOS(Mv_Par05)+"' AND '"+DTOS(Mv_Par06)+"' " + CRLF 
		cQuery += " AND SD2.D_E_L_E_T_ = '' " + CRLF 
		cQuery += " AND SD2.D2_TIPO = 'N' " + CRLF 
		cQuery += " AND SF2.F2_ESPECIE IN ('CF','SPED','NFCE','SATCE') " + CRLF 
		cQuery += " AND D2_CF IN ("+cTesVenda+") " + CRLF 
		cQuery += " AND D2_FILIAL BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"' " + CRLF 
		cQuery += " AND F2_VEND1 BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' " + CRLF 
		cQuery += " GROUP BY SD2.D2_FILIAL, D2_EMISSAO, D2_DOC, D2_SERIE, D2_CF, E4_FORMA, E4_DESCRI, F2_COND " + CRLF 
	Endif

DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)

	TCSetField(cAlias,"TOTAL_NOTA"		,"N",TamSx3("D2_TOTAL")  [1]	,TamSx3("D2_VALBRUT")[2])
	TCSetField(cAlias,"TOTAL_PRODUTOS"	,"N",TamSx3("D2_TOTAL")  [1]	,TamSx3("D2_TOTAL")  [2])
	TCSetField(cAlias,"ICMS"			,"N",TamSx3("D2_VALICM") [1]	,TamSx3("D2_VALICM") [2])
	TCSetField(cAlias,"ICMS_ST"			,"N",TamSx3("D2_ICMSRET")[1]	,TamSx3("D2_ICMSRET")[2])
	TCSetField(cAlias,"PIS"				,"N",TamSx3("D2_VALIMP6")[1]	,TamSx3("D2_VALIMP6")[2])
	TCSetField(cAlias,"COFINS"			,"N",TamSx3("D2_VALIMP5")[1]	,TamSx3("D2_VALIMP5")[2])
	TCSetField(cAlias,"IPI"				,"N",TamSx3("D2_VALIPI") [1]	,TamSx3("D2_VALIPI") [2])
	TCSetField(cAlias,"FRETE"			,"N",TamSx3("D2_VALFRE") [1]	,TamSx3("D2_VALFRE") [2])
	TCSetField(cAlias,"QTD_NOTAS"		,"N",10							,				    	)

oReport:SetMeter( 1 )
oSection1:Init()

(cAlias)->( dbGoTop() )
While (cAlias)->( !Eof() )
	oReport:IncMeter()
	
	// -- Verifica o cancelamento pelo usuario.
	If oReport:Cancel()
		Exit
	EndIf
	
	If Mv_Par07 == 2
		oSection1:Cell("FILIAL")		:SetBlock( { || (cAlias)->FILIAL		 } )
		oSection1:Cell("TOTAL_NOTA")	:SetBlock( { || (cAlias)->TOTAL_NOTA	 } )
		oSection1:Cell("TOTAL_PRODUTOS"):SetBlock( { || (cAlias)->TOTAL_PRODUTOS } )
		oSection1:Cell("ICMS")			:SetBlock( { || (cAlias)->ICMS			 } )
		oSection1:Cell("ICMS_ST")		:SetBlock( { || (cAlias)->ICMS_ST		 } )
		oSection1:Cell("PIS")			:SetBlock( { || (cAlias)->PIS			 } )
		oSection1:Cell("COFINS")		:SetBlock( { || (cAlias)->COFINS		 } )
		oSection1:Cell("IPI")		 	:SetBlock( { || (cAlias)->IPI			 } )
		oSection1:Cell("FRETE")		 	:SetBlock( { || (cAlias)->FRETE			 } )		
		oSection1:Cell("QTD_NOTAS")	 	:SetBlock( { || (cAlias)->QTD_NOTAS		 } )
	Else
		oSection1:Cell("FILIAL")		:SetBlock( { || (cAlias)->FILIAL		 } )
		oSection1:Cell("EMISSAO")		:SetBlock( { || stod((cAlias)->EMISSAO)	 } )
		oSection1:Cell("NOTA")			:SetBlock( { || (cAlias)->NOTA			 } )
		oSection1:Cell("SERIE")			:SetBlock( { || (cAlias)->SERIE			 } )
		oSection1:Cell("CFOP")			:SetBlock( { || (cAlias)->CFOP			 } )
		oSection1:Cell("TOTAL_NOTA"	)	:SetBlock( { || (cAlias)->TOTAL_NOTA	 } )
		oSection1:Cell("TOTAL_PRODUTOS"):SetBlock( { || (cAlias)->TOTAL_PRODUTOS } )
		oSection1:Cell("ICMS")			:SetBlock( { || (cAlias)->ICMS			 } )
		oSection1:Cell("ICMS_ST")		:SetBlock( { || (cAlias)->ICMS_ST		 } )
		oSection1:Cell("PIS")			:SetBlock( { || (cAlias)->COFINS		 } )
		oSection1:Cell("COFINS")		:SetBlock( { || (cAlias)->PIS			 } )
		oSection1:Cell("IPI")			:SetBlock( { || (cAlias)->IPI			 } )
		oSection1:Cell("FRETE")			:SetBlock( { || (cAlias)->FRETE			 } )
		oSection1:Cell("CONDICAO")		:SetBlock( { || (cAlias)->CONDICAO		 } )
		oSection1:Cell("FORMA")			:SetBlock( { || (cAlias)->FORMA			 } )
		oSection1:Cell("DESCRICAO")		:SetBlock( { || (cAlias)->DESCRICAO	  	 } )					
	Endif
								
	oSection1:PrintLine()

	(cAlias)->( dbSkip() )
	
EndDo
oSection1:Finish()

(cAlias)->( dbCloseArea() )

Return( oReport )


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//+@description:Ajusta Sx1, Cria Perguntas na Função PUTSX1()	+
//+@Author	   :Luiz Fernando O. Mendes					 		+
//+@version	   :1.0										 		+
//+@since 	   :17/02/2017								 		+
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Static Function AjustaSX1(cPerg)

Local aHlpPor01 := {"Informar a filial inicial.",""}
Local aHlpPor02 := {"Informar a filial final.",""}
Local aHlpPor03 := {"Informar o Vendedor inicial.",""}
Local aHlpPor04 := {"Informar o Vendedor final.",""}
Local aHlpPor05 := {"Informar a data emissão inicial.",""}
Local aHlpPor06 := {"Informar a data emissão final.",""}
Local aHlpPor07 := {"Tipo Relatório 1=Analitico","2=Sintetico"}

PutSx1(cPerg, "01","Da Filial"			,"Da Filial"			,"Da Filial"			,"MV_CH1","C",Len(cFilAnt)				,0,0,"G","","SM0"	,"","","mv_par01","","","","","","","","","","","",""," ","","","",aHlpPor01)
PutSx1(cPerg, "02","Ate Filialr"		,"Ate Filial"			,"Ate Filial"			,"MV_CH2","C",Len(cFilAnt)				,0,0,"G","","SM0"	,"","","mv_par02","","","","","","","","","","","",""," ","","","",aHlpPor02)
PutSx1(cPerg, "03","Do Vendedor"		,"Do Vendedor"			,"Do Vendedor"			,"MV_CH3","C",TamSx3("A3_COD")[1]		,0,0,"G","","SA3"	,"","","mv_par03","","","","","","","","","","","",""," ","","","",aHlpPor03)
PutSx1(cPerg, "04","Ate Vendedor"		,"Ate Vendedor"			,"Ate Vendedor"			,"MV_CH4","C",TamSx3("A3_COD")[1]		,0,0,"G","","SA3"	,"","","mv_par04","","","","","","","","","","","",""," ","","","",aHlpPor04)
PutSx1(cPerg, "05","Da Data Emissao"	,"Da Data Emissao"		,"Da Data Emissao"		,"MV_CH5","D",TamSx3("D1_EMISSAO")[1]	,0,0,"G","",""		,"","","mv_par05","","","","","","","","","","","",""," ","","","",aHlpPor05)
PutSx1(cPerg, "06","Ate Data Emissao"	,"Ate Data Emissao"		,"Ate Data Emissao"		,"MV_CH6","D",TamSx3("D1_EMISSAO")[1]	,0,0,"G","",""		,"","","mv_par06","","","","","","","","","","","",""," ","","","",aHlpPor06)
PutSx1(cPerg, "07","Tipo Relatório"	    ,"Tipo Relatório"		,"Tipo Relatório" 		,"MV_CH7","N",1							,0,1,"C",""	,""		,"","","mv_par07","Analitico","Analitico","Analitico"	,,"Sintetico","Sintetico","Sintetico"	,"","","","","","","","","",aHlpPor07)										
//PutSx1(<cGrupo>		,<cOrdem>	,<cPergunt>				,<cPerSpa>				,<cPerEng>				,<cVar>		,<cTipo>	,<nTamanho>	,<nDecimal>,<nPresel>	,<cGSC>	,<cValid>	,<cF3>	,<cGrpSxg>	,<cPyme>	,<cVar01>	,<cDef01>		,<cDefSpa1>		,<cDefEng1>		,<cCnt01>	,<cDef02>	,<cDefSpa2>	,<cDefEng2>	,<cDef03>		,<cDefSpa3>		,<cDefEng3>		,<cDef04>				,<cDefSpa4>				,<cDefEng4>				,<cDef05>	,<cDefSpa5>	,<cDefEng5>	,<aHelpPor>	,<aHelpEng>	,<aHelpSpa>	,<cHelp>)

Return