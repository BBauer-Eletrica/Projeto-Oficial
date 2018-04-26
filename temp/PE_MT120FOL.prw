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

User Function MT120FOL( )
Local nOpc    := PARAMIXB[1]
Local aPosGet := PARAMIXB[2]
Local _nOcupa := 0
//Private _nOcupa := 0
If nOpc <> 1 
	U_ATUMT120FOL(@_nOcupa)
	@ 006,aPosGet[3,1] SAY OemToAnsi('Ocupação do container :') OF oFolder:aDialogs[7] PIXEL SIZE 070,009 
	@ 005,aPosGet[3,2] MSGET _nOcupa PICTURE '@E 999,999.9999' OF oFolder:aDialogs[7] PIXEL SIZE 083,009  WHEN .F. HASBUTTON
//	@ 042,aPosGet[3,3] BUTTON "Atualiza Ocupação" SIZE 050,010  FONT oDlg:oFont ACTION ATUMT120FOL()  OF oFolder:aDialogs[7] PIXEL
	@ 007,aPosGet[3,3] BUTTON "Atualiza Ocupação" SIZE 050,010  ACTION U_ATUMT120FOL(@_nOcupa)  OF oFolder:aDialogs[7] PIXEL
Endif 
Return Nil 

User Function ATUMT120FOL(_nOcupa)
Local _aAreaCub := GetArea()
_nPosProd := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C7_PRODUTO"})
_nPosQtd  := ascan(aHeader, {|aVal| alltrim(aVal[2]) == "C7_QUANT"  })
_nOcupa := 0
For _nCount := 1 to Len(aCols)
	_lDeletado := .F.
	If aCols[_nCount,Len(aHeader)+1] == .T. // Verifica se o item esta marcado para exclusao
		_lDeletado := .T.
	EndIf
	if !_lDeletado
    	if _nPosProd > 0
    		DbSelectArea("SB1")
    		DbSetOrder(1)
    		DbSeek(xfilial("SB1")+aCols[_nCount][_nPosProd])
    		_nOcupa += SB1->B1_ZCUBAGE * aCols[_nCount][_nPosQtd]
		endif
	endif
Next

//_nOcupa := 100

RestArea(_aAreaCub)

Return