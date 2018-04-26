#Include "Totvs.ch"

/*==========================================================================
 Funcao...........:	MT103CWH
 Descricao........:	P.E. Para completar com zeros a esquerda os Numeros
 					de NF e Serie no documento de entrada.
 Autor............:	Amedeo D. Paoli Filho
 Data.............:	11/06/2014
 Parametros.......:	Nil
 Retorno..........:	Nil
==========================================================================*/
User Function MT103CWH()

	If !Empty(cNFiscal)
		cNFiscal := StrZero( Val(cNFiscal),TamSx3("F1_DOC")[1] )
	Endif
	
	If !Empty(cSerie)
		If !IsAlpha( cSerie )
			cSerie	:= StrZero( Val(cSerie),TamSx3("F1_SERIE")[1] )
		EndIf
	EndIf

Return .T.
