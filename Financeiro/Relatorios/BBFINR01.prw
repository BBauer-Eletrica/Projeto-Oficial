#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc}  SANR080V2
Relatório de fluxo de caixa.

@Author	 		Leonardo Espinosa
@since 			19/05/2016
@version		2.0

/*/
	
user function SANR080V2()
	
	Local oReport 
	Local cPerg	  := PADR("SANR080V2",10)
	
/////////////////////////////////////////////////////////////////////////////////////////
////							Adiciona as Perguntas								/////
/////////////////////////////////////////////////////////////////////////////////////////

	AjustaSX1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return()
	Endif
	
	oReport := ReportDef()
	oReport:PrintDialog()
	
return Nil

/*/{Protheus.doc}  ReportDef
Definições da impressão do relatório.

@Author	 		Leonardo Espinosa
@since 			19/05/2016
@version		2.0

/*/
Static Function ReportDef()

Local oBreak,oBreak1, oCell, oReport, oSection1, oSection2, oSection3 
Local cPerg	  := PADR("SANR080V2",10)
Local cReport := "SANR080V2"
Local cTitulo := ""
Local cDescri := "Este programa irá emitir o Relatório de Fluxo de Caixa"
Local nX
Local nDifDias	:= 0

	cTitulo := "Relatório de Fluxo de Caixa"


oReport := TReport():New("SANR080V2","Relatório de Fluxo de Caixa",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá emitir o Relatório de Fluxo de Caixa")

oReport:SetTotalInline(.F.)
oReport:SetLandscape(.T.)
oReport:SetUseGC(.F.)
oReport:oPage:setPaperSize(9)


nDifDias	:= DateDiffDay( MV_PAR01 , MV_PAR02 )

/////////////////////////////////////////////////////////////////////////////////////////
/////								Contas a Receber	  							/////
/////////////////////////////////////////////////////////////////////////////////////////

		oSection1 := TRSection():New(oReport, "Contas a Receber", {"SE1"}, {"Por Tipo"} )

		TRCell():New(oSection1,"TIPO"				,,"Grupo"							,								,30							, .F.,)
		
		For nX := 1 to nDifDias
			TRCell():New(oSection1,"VAL"+AllTrim(STR(nX))			,,DtoC(MV_PAR01+(nX-1))				,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		Next nX
		
		TRCell():New(oSection1,"TOTAL"				,,"Total"							,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		
		For nX := 1 to nDifDias
			oSection1:Cell("VAL"+AllTrim(STR(nX)))		:SetHeaderAlign("RIGHT")	
		Next nX

		oSection1:Cell("TOTAL")				:SetHeaderAlign("RIGHT")

		oBreak := TRBreak():New( oSection1, {||.T.},"Totais a Receber")
		
		For nX := 1 to nDifDias
			TRFunction():New(oSection1:Cell("VAL"+AllTrim(STR(nX)))		,Nil,"SUM",oBreak,,,,.F.,.F.)
		Next nX
		
		TRFunction():New(oSection1:Cell("TOTAL")	,Nil,"SUM",oBreak,,,,.F.,.F.)

		
/////////////////////////////////////////////////////////////////////////////////////////
/////								Contas a Pagar		  							/////
/////////////////////////////////////////////////////////////////////////////////////////

 
		oSection2 := TRSection():New(oReport, "Contas a Pagar"	, {"SE2"}, {"Por Tipo"} )
		
		oReport:SkipLine()
		oReport:SkipLine()
		TRCell():New(oSection2,"TIPO2"			,,"Grupo"						,								,30							, .F.,)
		
		For nX := 1 to nDifDias					//+STR(nX))
			TRCell():New(oSection2,"VAL"+AllTrim(STR(nX))			,,DtoC(MV_PAR01+(nX-1))				,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		next nX

		TRCell():New(oSection2,"TOTAL2"								,,"Total"							,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		
		For nX := 1 to nDifDias
			oSection2:Cell("VAL"+AllTrim(STR(nX)))		:SetHeaderAlign("RIGHT")
		next nX
		
		oSection2:Cell("TOTAL2")	:SetHeaderAlign("RIGHT")

		oBreak := TRBreak():New( oSection2, {||.T.},"Totais a Pagar")
		
		For nX	:= 1 to nDifDias
			TRFunction():New(oSection2:Cell("VAL"+AllTrim(STR(nX)))		,Nil,"SUM",oBreak,,,,.F.,.F.)
		next nX
		
		TRFunction():New(oSection2:Cell("TOTAL2")	,Nil,"SUM",oBreak,,,,.F.,.F.)


/*/////////////////////////////////////////////////////////////////////////////////////////
/////									Saldos			  							/////
/////////////////////////////////////////////////////////////////////////////////////////

		oSection3 := TRSection():New(oReport, "Saldos"	, , {"Por Período"} )
	
		TRCell():New(oSection3,""				,,"Saldos"							,								,30							, .F.,)
		TRCell():New(oSection3,"TOT1"			,,"Período 1"						,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		TRCell():New(oSection3,"TOT2"			,,"Período 2"						,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		TRCell():New(oSection3,"TOT3"			,,"Período 3"						,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		TRCell():New(oSection3,"TOT4"			,,"Período 4"						,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		TRCell():New(oSection3,"TOT5"			,,"Período 5"						,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		TRCell():New(oSection3,"TOTP"			,,"Saldo Semanal"					,PesqPict("SD2","D2_TOTAL")		,TamSX3("D2_TOTAL")   	[1]	, .F.,)
		
		oSection3:Cell("TOT1")		:SetHeaderAlign("RIGHT")
		oSection3:Cell("TOT2")		:SetHeaderAlign("RIGHT")
		oSection3:Cell("TOT3")		:SetHeaderAlign("RIGHT")
		oSection3:Cell("TOT4")		:SetHeaderAlign("RIGHT")
		oSection3:Cell("TOT5")		:SetHeaderAlign("RIGHT")
		oSection3:Cell("TOTP")		:SetHeaderAlign("RIGHT")
		
*/		
		
Return( oReport )




/*/{Protheus.doc}  ReportPrint
Busca os dados a serem impressos no relatório

@Author	 		Leonardo Espinosa
@since 			19/05/2016
@version		2.0

/*/

Static Function ReportPrint( oReport )

Local cQuery       	:= ""
Local cQuery2		:= ""
Local cAlias       	:= GetNextAlias()
Local cAlias2		:= GetNextAlias()
Local oSection1 	:= oReport:Section(1)
Local oSection2		:= oReport:Section(2)
Local nOrdem 	   	:= oSection1:GetOrder()
Local nqtdDias		:= DateDiffDay( MV_PAR01 , MV_PAR02 )
Local cCol			:= ""

/////////////////////////////////////////////////////////////////////////////////////////
/////								Contas a Receber	  							/////
/////////////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////
	///////		 Bradesco		////////
	////////////////////////////////////
	cQuery	:= " select 'BRADESCO' TIPO," +CRLF
		
	for nX := 1 to nqtdDias
		cCol	:= "VAL"+AllTrim(STR(nX))
		cQuery	+= " SUM(CASE WHEN E1_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E1_SALDO ELSE 0 END) "+cCol+", " 	+CRLF	
	
	next nX
	
	cQuery	+= " SUM(CASE WHEN E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E1_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery	+= " from "+RetSQLName("SE1")+" " +CRLF
	cQuery	+= "       WHERE E1_PORTADO = '001'" +CRLF
	cQuery	+= "       AND E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'" +CRLF
	cQuery	+= "       AND E1_SALDO > 0" +CRLF
	cQuery	+= "       AND E1_TIPO IN ('NF', 'AB-', 'FT', 'BOL')" +CRLF
	cQuery	+= "       AND D_E_L_E_T_ = ''" +CRLF
	cQuery	+= " UNION ALL" +CRLF

	
	////////////////////////////////////
	///////		 	Itau		////////
	////////////////////////////////////
	cQuery	+= " select  'ITAU' TIPO ," +CRLF
	
	For nX := 1 to nqtdDias
		cCol	:= "VAL"+AllTrim(STR(nX))
		cQuery	+= " SUM(CASE WHEN E1_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E1_SALDO ELSE 0 END) "+cCol+", " 	+CRLF	
	next nX
	
	cQuery	+= " SUM(CASE WHEN E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E1_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery	+= " from "+RetSQLName("SE1")+" " +CRLF
	cQuery	+= "       WHERE E1_PORTADO = '002'" +CRLF
	cQuery	+= "       	AND E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'" +CRLF
	cQuery	+= "    	AND E1_SALDO > 0" +CRLF
	cQuery	+= "	    AND E1_TIPO IN ('NF', 'AB-', 'FT', 'BOL')" +CRLF
	cQuery	+= "	    AND D_E_L_E_T_ = ''" +CRLF     
	cQuery	+= " UNION ALL" +CRLF 
	
	
	////////////////////////////////////
	///////		  Cartões		////////
	////////////////////////////////////  
	cQuery	+= " select  'CARTOES CRED' TIPO ," +CRLF 
	
	For nX := 1 to nqtdDias
		cCol	:= "VAL"+AllTrim(STR(nX))
		cQuery	+= " SUM(CASE WHEN E1_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E1_SALDO ELSE 0 END) "+cCol+", " 	+CRLF	
	next nX
	
	cQuery	+= " SUM(CASE WHEN E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E1_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery	+= " from "+RetSQLName("SE1")+" " +CRLF
	cQuery	+= "       WHERE E1_TIPO = 'CC'" +CRLF
	cQuery	+= "       AND E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'" +CRLF
	cQuery	+= "       AND E1_SALDO > 0" +CRLF
	cQuery	+= "	    AND D_E_L_E_T_ = ''" +CRLF     
	cQuery	+= " UNION ALL" +CRLF     
	
	
	////////////////////////////////////
	///////		 	BNDES		////////
	////////////////////////////////////
	cQuery	+= " select  'BNDES' TIPO ," +CRLF
	For nX := 1 to nqtdDias
		cCol	:= "VAL"+AllTrim(STR(nX))
		cQuery	+= " SUM(CASE WHEN E1_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E1_SALDO ELSE 0 END) "+cCol+", " 	+CRLF	
	next nX
	cQuery	+= " SUM(CASE WHEN E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E1_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery	+= " from "+RetSQLName("SE1")+" " +CRLF
	cQuery	+= "      WHERE E1_TIPO = 'BND'" +CRLF
	cQuery	+= "       AND E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'" +CRLF
	cQuery	+= "       AND E1_SALDO > 0" +CRLF
	cQuery	+= "	   AND D_E_L_E_T_ = ''" +CRLF     
	cQuery	+= " UNION ALL" +CRLF  
	
	
	////////////////////////////////////
	///////		 Carteira		////////
	////////////////////////////////////   
	cQuery	+= " select  'CARTEIRA' TIPO , " +CRLF
	
	For nX := 1 to nqtdDias
		cCol	:= "VAL"+AllTrim(STR(nX))
		cQuery	+= " SUM(CASE WHEN E1_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E1_SALDO ELSE 0 END) "+cCol+", " 	+CRLF	
	next nX
	cQuery	+= " SUM(CASE WHEN E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E1_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery	+= " from "+RetSQLName("SE1")+" " +CRLF
	cQuery	+= "      WHERE E1_PORTADO = ''" +CRLF
	cQuery	+= "	  AND E1_TIPO NOT IN ('CC','CD','BND','NCC')" +CRLF
	cQuery	+= "      AND E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'" +CRLF
	cQuery	+= "      AND E1_SALDO > 0" +CRLF
	cQuery	+= "	  AND E1_SITUACA = '0'" +CRLF
	cQuery	+= "	  AND D_E_L_E_T_ = ''" +CRLF     
	cQuery	+= " UNION ALL" +CRLF 
	
	
	////////////////////////////////////
	///////		 Cheques		////////
	//////////////////////////////////// 
	cQuery	+= "select  'CH' TIPO ," +CRLF
	For nX := 1 to nqtdDias
		cCol	:= "VAL"+AllTrim(STR(nX))
		cQuery	+= " SUM(CASE WHEN E1_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E1_SALDO ELSE 0 END) "+cCol+", " 	+CRLF	
	next nX
	cQuery	+= " SUM(CASE WHEN E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E1_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery	+= " from "+RetSQLName("SE1")+" " +CRLF
	cQuery	+= "     WHERE E1_TIPO = 'CH'" +CRLF
	cQuery	+= "       AND E1_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'" +CRLF
	cQuery	+= "       AND E1_SALDO > 0" +CRLF
	cQuery	+= "	   AND D_E_L_E_T_ = ''" +CRLF          
	
	
	DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), cAlias, .F., .T.)

	

/////////////////////////////////////////////////////////////////////////////////////////
/////								Contas a Pagar		  							/////
/////////////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////
	///////		 Despesas		////////
	////////////////////////////////////

	cQuery2		:= " select 'DESPESAS' TIPO," +CRLF 
	
	For nX := 1 to nqtdDias
		cCol	:= "VAL"+AllTrim(STR(nX))
		cQuery2		+= " SUM(CASE WHEN E2_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E2_SALDO ELSE 0 END) "+cCol+"," 	+CRLF
	next nX
	
	cQuery2		+= " SUM(CASE WHEN E2_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E2_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery2		+= " from "+RetSQLName("SE2")+"" +CRLF

	cQuery2		+= "      WHERE E2_NATUREZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'" +CRLF
	cQuery2		+= "      AND E2_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' " +CRLF
	cQuery2		+= "      AND E2_SALDO > 0 " +CRLF
	cQuery2		+= "      AND D_E_L_E_T_ = ''" +CRLF
	
	cQuery2		+= " UNION ALL" +CRLF

	////////////////////////////////////
	///////		 Duplicatas		////////
	////////////////////////////////////

	cQuery2		+= " select  'DUPLICATA' TIPO ," +CRLF
	For nX := 1 to nqtdDias
		cCol		:= "VAL"+AllTrim(STR(nX))
		cQuery2		+= " SUM(CASE WHEN E2_VENCREA = '"+Dtos(MV_PAR01+(nX-1))+"' THEN E2_SALDO ELSE 0 END) "+cCol+"," 	+CRLF
	Next nX
	
	cQuery2		+= " SUM(CASE WHEN E2_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02 - 1)+"' THEN E2_SALDO ELSE 0 END) TOTAL" +CRLF
	cQuery2		+= " from "+RetSQLName("SE2")+"" +CRLF
	cQuery2		+= "  WHERE E2_NATUREZ = '"+MV_PAR05+"' " +CRLF
	cQuery2		+= "  AND E2_VENCREA BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"' " +CRLF
	cQuery2		+= "  AND E2_SALDO > 0" +CRLF 
    cQuery2		+= "  AND D_E_L_E_T_ = ''" +CRLF  


	DbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery2), cAlias2, .F., .T.)
	
	
	COUNT TO nRec
	oReport:SetMeter( nRec )

	(cAlias)->( dbGoTop() )
	(cAlias2)->(dbGoTop() )

While  (cAlias)->( !Eof() )
	
	// -- Verifica o cancelamento pelo usuario.
	If oReport:Cancel()
		Exit
	EndIf
	oReport:IncMeter()
	oSection1:Init()
	
	
	oSection1:Cell("TIPO"			):SetBlock( { || (cAlias)->TIPO			} )
	For nX := 1 to nqtdDias
		cCol		:= "VAL"+AllTrim(STR(nX))
			
		Do case 
		
			Case nX == 1				
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL1				} )
				
			Case nX == 2
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL2				} )
			
			Case nX == 3
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL3				} )
				
			Case nX == 4
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL4				} )
				
			Case nX == 5
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL5				} )
				
			Case nX == 6
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL6				} )	
				
			Case nX == 7
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL7				} )				
			
			Case nX == 8
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL8				} )

			Case nX == 9
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL9				} )
				
			Case nX == 10
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL10			} )				
									
			Case nX == 11
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL11			} )				

			Case nX == 12
				oSection1:Cell(cCol			):SetBlock( { || (cALias)->VAL12			} )				
		
		End Case	
			
	next nX
	
	oSection1:Cell("TOTAL"			):SetBlock( { || (cAlias)->TOTAL		} )		
	
								
	oSection1:PrintLine()
		
	(cAlias)->( dbSkip()  )
	
	
EndDo

	oSection1:Finish()
	(cAlias)->( dbCloseArea() )


While (cAlias2)-> ( !Eof() )
		
		// -- Verifica o cancelamento pelo usuario.
		If oReport:Cancel()
			Exit
		EndIf
		oSection2:Init()
		oReport:IncMeter()
		
		oSection2:Cell("TIPO2"				):SetBlock( { || (cAlias2)->TIPO				} )		
			
	For nX := 1 to nqtdDias
		cCol		:= "VAL"+AllTrim(STR(nX))
				
		Do case 
		
			Case nX == 1				
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL1				} )
				
			Case nX == 2
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL2				} )
			
			Case nX == 3
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL3				} )
				
			Case nX == 4
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL4				} )
				
			Case nX == 5
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL5				} )
				
			Case nX == 6
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL6				} )	
				
			Case nX == 7
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL7				} )
				
			Case nX == 8
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL8				} )
				
			Case nX == 9
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL9				} )

			Case nX == 10
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL10				} )				

			Case nX == 11
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL11				} )
								
			Case nX == 12
				oSection2:Cell(cCol			):SetBlock( { || (cALias2)->VAL12				} )				
										
		End Case	
			
	next nX		
		oSection2:Cell("TOTAL2"				):SetBlock( { || (cAlias2)->TOTAL				} )			
	
			
		oSection2:PrintLine()
		(cAlias2)->( dbSkip() )
	
EndDo
	
	oSection2:Finish()
	(cAlias2)->( dbCloseArea() )


Return( oReport )

	

/*/{Protheus.doc}  AjustaSX1
Cria as perguntas para realização de filtros dos dados

@Author	 		Leonardo Espinosa
@since 			19/05/2016
@version		2.0

/*/
Static Function AjustaSX1(cPerg)

Local aHlpPor01 := {"Informar a Data inicial.",""}
Local aHlpPor02 := {"Informar a Data Final.",""}
Local aHlpPor03 := {"Informar a Natureza das despesas Inicial.",""}
Local aHlpPor04 := {"Informar a Natureza das despesas Final.",""}
LOcal aHlpPor05 := {"Informar a natureza das duplicatas.", ""}

putSx1(cPerg, '01', 'Data De:'       			, '', '',	'mv_ch1', 'D', 10, 0, 0, 'G', 				  '', 	 '', 	'', '', 	'MV_PAR01')
putSx1(cPerg, '02', 'Data Até:'       			, '', '',	'mv_ch2', 'D', 10, 0, 0, 'G', 	 'U_R080VALID()', 	 '', 	'', '', 	'MV_PAR02')
putSx1(cPerg, '03', 'Nat. Despesas De:'       	, '', '',	'mv_ch3', 'C', 10, 0, 0, 'G', 				  '', 'CT1', 	'', '', 	'MV_PAR03')
putSx1(cPerg, '04', 'Nat. Despesas Ate:'       	, '', '',	'mv_ch4', 'C', 10, 0, 0, 'G', 				  '', 'CT1', 	'', '', 	'MV_PAR04')
putSx1(cPerg, '05', 'Nat. Duplicatas'       	, '', '',	'mv_ch5', 'C', 10, 0, 0, 'G', 				  '', 'CT1', 	'', '', 	'MV_PAR05')

//PutSx1(<cGrupo>,<cOrdem>,<cPergunt			,<cPerSpa>				,<cPerEng>				,<cVar>		,<cTipo>	,<nTamanho>	,<nDecimal>,<nPresel>	,<cGSC>	,<cValid>	,<cF3>	,<cGrpSxg>	,<cPyme>	,<cVar01>	,<cDef01>		,<cDefSpa1>		,<cDefEng1>		,<cCnt01>	,<cDef02>	,<cDefSpa2>	,<cDefEng2>	,<cDef03>		,<cDefSpa3>		,<cDefEng3>		,<cDef04>				,<cDefSpa4>				,<cDefEng4>				,<cDef05>	,<cDefSpa5>	,<cDefEng5>	,<aHelpPor>	,<aHelpEng>	,<aHelpSpa>	,<cHelp>)

Return

/*/{Protheus.doc}  R080VALID
Valida o período digitado pelo usuário

@Author	 		Leonardo Espinosa
@since 			19/05/2016
@version		2.0

/*/
User Function R080VALID()

Local lRet := .T.

	If DateDiffDay( MV_PAR01 , MV_PAR02 ) > 12
		MsgAlert("O período não pode ser superior a 12 dias.")
		lRet	:= .F.
	Else
		lRet	:= .T.
	EndIf

Return ( lRet )
