#include 'protheus.ch'
#include 'parmtype.ch'

// #########################################################################################
// Projeto: BBauer
// Modulo :
// Fonte  : BBConExc.prw
// ----------+-------------------+-----------------------------------------------------------
// Data      | Autor             | Descricao
// ----------+-------------------+-----------------------------------------------------------
// 22/10/16  | Gerson Belini     | Geração de consultas em Excel
// ----------+-------------------+-----------------------------------------------------------
// Comentario| Serão geradas as seguintes consultas:
//           | 1) Extração dos dados de vendas
//           | 2) Extração dos dados de estoque
//MRCONSULT  | 3) Extração dos dados de carteira

user function BBConExc()
/*
Local _lCheck1 := .F.
Local _lCheck2 := .F.
Local _lCheck3 := .F.


 DEFINE DIALOG oDlg TITLE "Resumos Para Gerar" FROM 180,180 TO 350,400 PIXEL
   oCheck1 := TCheckBox():New(01,01,'Faturamento',{||_lCheck1},oDlg,100,210,,,,,,,,.T.,,,)
   oCheck2 := TCheckBox():New(11,01,'Estoque    ',{||_lCheck2},oDlg,100,210,,,,,,,,.T.,,,)
   oCheck3 := TCheckBox():New(21,01,'Carteira   ',{||_lCheck3},oDlg,100,210,,,,,,,,.T.,,,)
 ACTIVATE DIALOG oDlg CENTERED
*/
//Local bExecute		:= {|| oDlg:End(),BBCon01Exe()}
Local bExecute		:= {|| BBCon01Exe()}
Local bCancel		:= {|| oDlg:End()}
Local bPergunte     := {|| Pergunte(cPerg,.T.)}
Local cPerg         := "BBCONEXC"
Private lCheck1
Private lCheck2
Private lCheck3

AjustaSX1(cPerg)

Pergunte(cPerg,.F.)

DEFINE MSDIALOG oDlg FROM 0,0 TO 140,300 PIXEL TITLE 'Escolher consultas para geração'
lCheck1 := .T.
lCheck2 := .T.
lCheck3 := .T. 
oCheck1 := TCheckBox():New(10,20,'Faturamento',,oDlg, 100,210,,,,,,,,.T.,,,) 
oCheck2 := TCheckBox():New(26,20,'Estoques   ',,oDlg, 100,210,,,,,,,,.T.,,,) 
oCheck3 := TCheckBox():New(41,20,'Carteira   ',,oDlg, 100,210,,,,,,,,.T.,,,)
// Seta Eventos do primeiro Check 
oCheck1:bSetGet   := {|| lCheck1 } 
oCheck1:bLClicked := {|| lCheck1:=!lCheck1 } 
oCheck1:bWhen := {|| .T. } 
//oCheck1:bValid := {|| Alert('bValid') }
// Seta Eventos do segundo Check 
oCheck2:bSetGet   := {|| lCheck2 } 
oCheck2:bLClicked := {|| lCheck2:=!lCheck2 } 
oCheck2:bWhen := {|| .T. } 
//oCheck1:bValid := {|| Alert('bValid') }
// Seta Eventos do terceiro Check 
oCheck3:bSetGet   := {|| lCheck3 } 
oCheck3:bLClicked := {|| lCheck3:=!lCheck3 } 
oCheck3:bWhen := {|| .T. } 
//oCheck1:bValid := {|| Alert('bValid') }

// Principais comandos 
/*
oBtn := TButton():New( 056, 010, 'Encerra o diálogo e executa o processo',; 
oDlg,{|| oDlg:End() }, 120, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
*/
oBtnOk  := tButton():New(056,020,"&Executa",oDlg,bExecute,35,12,,,,.T.)//"&Ok"
oBtnCan	:= tButton():New(056,060,"&Cancelar",oDlg,bCancel,35,12,,,,.T.)	//"&Cancelar"
oBtnPer	:= tButton():New(056,100,"&Parâmetros",oDlg,bPergunte,35,12,,,,.T.)	//"&Cancelar"


ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
Função: BBCon01Exe()
Autor: Gerson Belini
Data 22/10/2016
Descrição: Executa a geração das consultas
Sintaxe: BBCon01Exe()
*/
Static Function BBCon01Exe()

Private _cDirSave

	oDlg:End()
	
	// Indicar o diretorio para salvar o arquivo
	//_cDirSave := cGetFile ( [ cMascara], [ cTitulo], [ nMascpadrao], [ cDirinicial], [ lSalvar], [ nOpcoes], [ lArvore], [ lKeepCase] )
	_cDirSave := _cdir:=cGetFile(,'Diretorio para Salvar o arquivo',,,.T.,GETF_LOCALHARD+GETF_RETDIRECTORY+GETF_NETWORKDRIVE,.F.)
	
	if Empty(_cDirSave)
		MsgStop(OemToAnsi("Nenhum diretório escolhido para gravação, geração abortada!!!"))
		Return(NIL)
	endif

	
	if lCheck1
		// Gerar consulta de faturamento
		GeraFat()
		GeraDev()
	endif

	if lCheck2
		// Gerar consulta de estoque
		GeraEst()
	endif

	if lCheck3
		// Gerar consulta de carteira
		GeraCar()
	endif


return

/*
Função: GeraFat()
Autor: Gerson Belini
Data 22/10/2016
Descrição: Gerar consulta no banco para obtenção de dados de faturamento em determinado período
Sintaxe: GeraFat()
*/
Static Function GeraFat()
	Local _cQuery  := ""
	Local _dInicio := ""
	Local _dFinal  := ""
	Local _aCampos := {}
	Local _aHeader := {}
	Local _aCols   := {}

	// Criar um array com as colunas que serão exibidas, podendo ser adicionadas ou reduzidas colunas
	// Total de colunas limitadas a 256

// Por existirem consultas em tabelas que se repetem informar:
// Posicao 1
// Nome do campo para pesquisa no dicionario e montagem da consulta
// Posicao 2
// Alias do campo para impressão
// Posicao 3
// Alias da Tabela para complemento do campo

// ====> Bloclo FAT
	aadd(_aCampos,{"D2_EMISSAO" ,"D2_EMISSAO" ,"SD2"})
	aadd(_aCampos,{"D2_LOCAL"   ,"D2_LOCAL"   ,"SD2"})
	aadd(_aCampos,{"NNR_DESCRI" ,"NNR_DESCRI" ,"NNR"})
	aadd(_aCampos,{"D2_CCUSTO"  ,"D2_CCUSTO"  ,"SD2"})
	aadd(_aCampos,{"D2_ESPECIE" ,"D2_ESPECIE" ,"SD2"})
	aadd(_aCampos,{"D2_FILIAL"  ,"D2_FILIAL"  ,"SD2"})
	aadd(_aCampos,{"D2_ITEM"    ,"D2_ITEM"    ,"SD2"})
	aadd(_aCampos,{"D2_ITEMCC"  ,"D2_ITECC"   ,"SD2"})
	aadd(_aCampos,{"D2_DOC"     ,"D2_DOC"     ,"SD2"})
	aadd(_aCampos,{"D2_SERIE"   ,"D2_SERIE"   ,"SD2"})
	aadd(_aCampos,{"D2_TIPO"    ,"D2_TIPO"    ,"SD2"})

// =====> Bloco TES
	aadd(_aCampos,{"F4_ESTOQUE" ,"F4_ESTOQUE" ,"SF4"})
	aadd(_aCampos,{"D2_CF"      ,"D2_CF"      ,"SD2"})
	aadd(_aCampos,{"F4_DUPLIC"  ,"F4_DUPLIC"  ,"SF4"})
	aadd(_aCampos,{"D2_TES"     ,"D2_TES"     ,"SD2"})
	aadd(_aCampos,{"F4_TEXTO"   ,"F4_TEXTO"   ,"SF4"})


// =====> Bloco condição de pagamento
	aadd(_aCampos,{"E4_CODIGO"  ,"E4_CODIGO"  ,"SE4"})
	aadd(_aCampos,{"E4_DESCRI"  ,"E4_DESCRI"  ,"SE4"})
	aadd(_aCampos,{"E4_ZNRDIAS" ,"E4_ZNRDIAS" ,"SE4"})


// =====> Bloco cliente
	aadd(_aCampos,{"A1_MUN"     ,"A1_MUN"     ,"SA1"})
	aadd(_aCampos,{"D2_CLIENTE" ,"D2_CLIENTE" ,"SD2"})
	aadd(_aCampos,{"D2_LOJA"    ,"D2_LOJA"    ,"SD2"})
	aadd(_aCampos,{"A1_NOME"    ,"A1_NOME"    ,"SA1"})
	aadd(_aCampos,{"A1_NREDUZ"  ,"A1_NREDUZ"  ,"SA1"})
	aadd(_aCampos,{"A1_REGIAO"  ,"A1_REGIAO"  ,"SA1"})
	aadd(_aCampos,{"A1_EST"     ,"A1_EST"     ,"SA1"})

// =====> Bloco Vendedor
	aadd(_aCampos,{"F2_VEND1"   ,"F2_VEND1"   ,"SF2"})
	aadd(_aCampos,{"A3_NOME"    ,"A3_NOME1"   ,"SA31"})
	aadd(_aCampos,{"A3_NREDUZ"  ,"A3_NREDUZ1" ,"SA31"})
	aadd(_aCampos,{"A3_REGIAO"  ,"A3_REGIAO1" ,"SA31"})
	aadd(_aCampos,{"A3_EST"     ,"A3_EST1"    ,"SA31"})

	aadd(_aCampos,{"F2_VEND2"   ,"F2_VEND2"   ,"SF2"})
	aadd(_aCampos,{"A3_NOME"    ,"A3_NOME2"   ,"SA32"})
	aadd(_aCampos,{"A3_NREDUZ"  ,"A3_NREDUZ2" ,"SA32"})
	aadd(_aCampos,{"A3_REGIAO"  ,"A3_REGIAO2" ,"SA32"})
	aadd(_aCampos,{"A3_EST"     ,"A3_EST2"    ,"SA32"})

	
// =====> Bloco produtos
	aadd(_aCampos,{"B1_DESC"    ,"B1_DESC"    ,"SB1"})
	aadd(_aCampos,{"D2_GRUPO"   ,"D2_GRUPO"   ,"SD2"})
	aadd(_aCampos,{"BM_DESC"    ,"BM_DESC"    ,"SBM"})
	aadd(_aCampos,{"D2_TP"      ,"D2_TP"      ,"SD2"})
	aadd(_aCampos,{"D2_COD"     ,"D2_COD"     ,"SD2"})
	aadd(_aCampos,{"D2_UM"      ,"D2_UM"      ,"SD2"})
	
	

// =====> Bloco Pedido de Vendas
	aadd(_aCampos,{"D2_ITEMPV"  ,"D2_ITEMPV"  ,"SD2"})
	aadd(_aCampos,{"D2_PEDIDO"  ,"D2_PEDIDO"  ,"SD2"})
	aadd(_aCampos,{"C5_EMISSAO" ,"C5_EMISSAO" ,"SC5"})
	aadd(_aCampos,{"C6_ENTREG"  ,"C6_ENTREG"  ,"SC6"})


// =====> Bloco Indicador
	aadd(_aCampos,{"D2_DESC"    ,"D2_DESC"    ,"SD2"})
	aadd(_aCampos,{"D2_DESCZFR" ,"D2_DESCZFR" ,"SD2"})
	aadd(_aCampos,{"D2_DESCON"  ,"D2_DESCON"  ,"SD2"})
	aadd(_aCampos,{"D2_PRUNIT"  ,"D2_PRUNIT"  ,"SD2"})
	aadd(_aCampos,{"D2_QUANT"   ,"D2_QUANT"   ,"SD2"})
	aadd(_aCampos,{"D2_VARPRUN" ,"D2_VARPRUN" ,"SD2"})
	aadd(_aCampos,{"D2_VLIMPOR" ,"D2_VLIMPOR" ,"SD2"})
	aadd(_aCampos,{"D2_DESPESA" ,"D2_DESPESA" ,"SD2"})
	aadd(_aCampos,{"D2_SEGURO"  ,"D2_SEGURO"  ,"SD2"})
	aadd(_aCampos,{"D2_VALFRE"  ,"D2_VALFRE"  ,"SD2"})
	aadd(_aCampos,{"D2_VALACRS" ,"D2_VALACRS" ,"SD2"})
	aadd(_aCampos,{"D2_VALBRUT" ,"D2_VALBRUT" ,"SD2"})
	aadd(_aCampos,{"D2_TOTAL"   ,"D2_TOTAL"   ,"SD2"})
	aadd(_aCampos,{"D2_PRCVEN"  ,"D2_PRCVEN"  ,"SD2"})


// =====> Bloco Indicadores Impostos
	aadd(_aCampos,{"D2_ICMFRET" ,"D2_ICMFRET" ,"SD2"})
	aadd(_aCampos,{"D2_BRICMS"  ,"D2_BRICMS"  ,"SD2"})
	aadd(_aCampos,{"D2_ICMSRET" ,"D2_ICMSRET" ,"SD2"})
	aadd(_aCampos,{"D2_VALCSL"  ,"D2_VALCSL"  ,"SD2"})
	aadd(_aCampos,{"D2_VALIMP5" ,"D2_VALIMP5" ,"SD2"})
	aadd(_aCampos,{"D2_VALIMP6" ,"D2_VALIMP6" ,"SD2"})
	aadd(_aCampos,{"D2_VALICM"  ,"D2_VALICM"  ,"SD2"})
	aadd(_aCampos,{"D2_VALIPI"  ,"D2_VALIPI"  ,"SD2"})

// =====> Bloco Indicadores Custo
	aadd(_aCampos,{"D2_CUSTO1"  ,"D2_CUSTO1"  ,"SD2"})
	aadd(_aCampos,{"D2_CUSRP1"  ,"D2_CUSRP1"  ,"SD2"})
	aadd(_aCampos,{"B1_CUSTD"   ,"B1_CUSTD"   ,"SB1"})
	aadd(_aCampos,{"B1_MCUSTD"  ,"B1_MCUSTD"  ,"SB1"})
	aadd(_aCampos,{"B1_UPRC"    ,"B1_UPRC"    ,"SB1"})

// =====> Bloco Indicadores Comissoes
	aadd(_aCampos,{"D2_COMIS1"  ,"D2_COMIS1"  ,"SD2"})
	aadd(_aCampos,{"D2_COMIS2"  ,"D2_COMIS2"  ,"SD2"})
	


// =====> Bloco Indicadores Alíquotas
	aadd(_aCampos,{"D2_PICM"    ,"D2_PICM"    ,"SD2"})
	aadd(_aCampos,{"D2_ALQIMP5" ,"D2_ALQIMP5" ,"SD2"})
	aadd(_aCampos,{"D2_ALQIMP6" ,"D2_ALQIMP6" ,"SD2"})
	aadd(_aCampos,{"D2_IPI"     ,"D2_IPI"     ,"SD2"})


// =====> Bloco Indicadores Bases
	aadd(_aCampos,{"D2_BASEORI" ,"D2_BASEORI" ,"SD2"})
	aadd(_aCampos,{"D2_BASEICM" ,"D2_BASEICM" ,"SD2"})
	aadd(_aCampos,{"D2_BASIMP5" ,"D2_BASEIMP5","SD2"})
	aadd(_aCampos,{"D2_BASIMP6" ,"D2_BASEIMP6","SD2"})
	aadd(_aCampos,{"D2_BASEIPI" ,"D2_BASEIPI" ,"SD2"})


	// Adicionando propriedades do dicionario ao array

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aCampos)
		If SX3->(DbSeek(AllTrim(_aCampos[nX][1]))) .and. SX3->X3_CONTEXT != "V"
//			Aadd(_aHeader,{ SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
//			Aadd(_aHeader,{ AllTrim(_aCampos[nX][1]),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_CAMPO,AllTrim(_aCampos[nX][3])})
			Aadd(_aHeader,{ AllTrim(_aCampos[nX][1]),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,AllTrim(_aCampos[nX][2]),AllTrim(_aCampos[nX][3])})
		Endif
	Next nX

	_cQuery := ""
	_cQuery += " SELECT "
	// Adicionar os campos ao select
	For _nCount := 1 to Len(_aHeader)
		if _nCount == 1
			_cQuery += " "+AllTrim(_aHeader[_nCount][15])+"."+AllTrim(_aHeader[_nCount][1])+" AS "+AllTrim(_aHeader[_nCount][14])
		else
			_cQuery += ", "+AllTrim(_aHeader[_nCount][15])+"."+AllTrim(_aHeader[_nCount][1])+" AS "+AllTrim(_aHeader[_nCount][14])
		endif
	Next
	_cQuery += " FROM "+RetSqlName("SD2")+" AS SD2"
	_cQuery += " INNER JOIN "+RetSqlName("SF2")+" AS SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA ""
	_cQuery += " INNER JOIN "+RetSqlName("SF4")+" AS SF4 ON D2_TES = F4_CODIGO "
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON D2_FILIAL = B1_FILIAL AND D2_COD = B1_COD "
	_cQuery += " INNER JOIN "+RetSqlName("SC6")+" AS SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM "
	_cQuery += " INNER JOIN "+RetSqlName("SC5")+" AS SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SE4")+" AS SE4 ON F2_COND = E4_CODIGO "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" AS SA31 ON F2_VEND1 = SA31.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" AS SA32 ON F2_VEND2 = SA32.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("NNR")+" AS NNR ON D2_LOCAL = NNR_CODIGO "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SBM")+" AS SBM ON B1_GRUPO = BM_GRUPO "
	_cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SF2.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ( SA31.D_E_L_E_T_ = ' ' OR SA31.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SA32.D_E_L_E_T_ = ' ' OR SA32.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SE4.D_E_L_E_T_ = ' ' OR SE4.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( NNR.D_E_L_E_T_ = ' ' OR NNR.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SBM.D_E_L_E_T_ = ' ' OR SBM.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND SD2.D2_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRBVEN", .F., .T.)
	aEval(_aHeader, {|e| If(e[2] != "C", TCSetField("TRBVEN", e[14], e[2],e[3],e[4]),Nil)})

	// Montar o Acols
	DbSelectArea("TRBVEN")
	DbGoTop()
	While !Eof()
		_aAux := {}
		For _nCount := 1 to FCount()
			Aadd(_aAux,FieldGet(_nCount))
		Next
		Aadd(_aCols,_aAux)
		DbSelectArea("TRBVEN")
		DbSkip()
	End

GDToExcel(_aHeader,_aCols,"VENDAS","MOVIMENTOS")

	DbSelectArea("TRBVEN")
	DbCloseArea("TRBVEN")
Return(.T.)

/*
Função: GeraDev()
Autor: Gerson Belini
Data 22/10/2016
Descrição: Gerar consulta no banco para obtenção de dados de faturamento em determinado período
Sintaxe: GeraFat()
*/
Static Function GeraDev()
	Local _cQuery  := ""
	Local _dInicio := ""
	Local _dFinal  := ""
	Local _aCampos := {}
	Local _aHeader := {}
	Local _aCols   := {}

	// Criar um array com as colunas que serão exibidas, podendo ser adicionadas ou reduzidas colunas
	// Total de colunas limitadas a 256



// ====> Bloclo DEV
	aadd(_aCampos,{"D1_DTDIGIT","D1_DTDIGIT","SD1"})
	aadd(_aCampos,{"D1_LOCAL","D1_LOCAL","SD1"})
	aadd(_aCampos,{"NNR_DESCRI","NNR_DESCRI","NNR"})
	aadd(_aCampos,{"D1_CCUSTO","D1_CCUSTO","SD1"})
	aadd(_aCampos,{"D1_ESPECIE","D1_ESPECIE","SD1"})
	aadd(_aCampos,{"D1_FILIAL","D1_FILIAL","SD1"})
	aadd(_aCampos,{"D1_ITEM","D1_ITEM","SD1"})
	aadd(_aCampos,{"D1_ITEMCC","D1_ITEMCC","SD1"})
	aadd(_aCampos,{"D1_DOC","D1_DOC","SD1"})
	aadd(_aCampos,{"D1_SERIE","D1_SERIE","SD1"})
	aadd(_aCampos,{"D1_TIPO","D1_TIPO","SD1"})

// =====> Bloco TES
	aadd(_aCampos,{"F4_ESTOQUE","F4_ESTOQUE","SF4"})
	aadd(_aCampos,{"D1_CF","D1_CF","SD1"})
	aadd(_aCampos,{"F4_DUPLIC","F4_DUPLIC","SF4"})
	aadd(_aCampos,{"D1_TES","D1_TES","SD1"})
	aadd(_aCampos,{"F4_TEXTO","F4_TEXTO","SF4"})


// =====> Bloco condição de pagamento
	aadd(_aCampos,{"E4_CODIGO","E4_CODIGO","SE4"})
	aadd(_aCampos,{"E4_DESCRI","E4_DESCRI","SE4"})
	aadd(_aCampos,{"E4_ZNRDIAS","E4_ZNRDIAS","SE4"})


// =====> Bloco cliente
	aadd(_aCampos,{"A1_MUN","A1_MUN","SA1"})
	aadd(_aCampos,{"D1_FORNECE","D1_FORNECE","SD1"})
	aadd(_aCampos,{"D1_LOJA","D1_LOJA","SD1"})
	aadd(_aCampos,{"A1_NOME","A1_NOME","SA1"})
	aadd(_aCampos,{"A1_NREDUZ","A1_NREDUZ","SA1"})
	aadd(_aCampos,{"A1_REGIAO","A1_REGIAO","SA1"})
	aadd(_aCampos,{"A1_EST","A1_EST","SA1"})

// =====> Bloco Vendedor
	aadd(_aCampos,{"F2_VEND1","F2_VEND1","SF2"})
	aadd(_aCampos,{"A3_NOME","A3_NOME1","SA31"})
	aadd(_aCampos,{"A3_NREDUZ","A3_NREDUZ1","SA31"})
	aadd(_aCampos,{"A3_REGIAO","A3_REGIAO1","SA31"})
	aadd(_aCampos,{"A3_EST","A3_EST1","SA31"})

	aadd(_aCampos,{"F2_VEND2","F2_VEND2","SF2"})
	aadd(_aCampos,{"A3_NOME","A3_NOME2","SA32"})
	aadd(_aCampos,{"A3_NREDUZ","A3_NREDUZ2","SA32"})
	aadd(_aCampos,{"A3_REGIAO","A3_REGIAO2","SA32"})
	aadd(_aCampos,{"A3_EST","A3_EST2","SA32"})
	
// =====> Bloco produtos
	aadd(_aCampos,{"B1_DESC","B1_DESC","SB1"})
	aadd(_aCampos,{"D1_GRUPO","D1_GRUPO","SD1"})
	aadd(_aCampos,{"BM_DESC","BM_DESC","SBM"})
	aadd(_aCampos,{"D1_TP","D1_TP","SD1"})
	aadd(_aCampos,{"D1_COD","D1_COD","SD1"})
	aadd(_aCampos,{"D1_UM","D1_UM","SD1"})
	
	

// =====> Bloco Pedido de Vendas
	aadd(_aCampos,{"D2_ITEMPV","D2_ITEMPV","SD2"})
	aadd(_aCampos,{"D2_PEDIDO","D2_EMISSAO","SD2"})
	aadd(_aCampos,{"C5_EMISSAO","C5_EMISSAO","SC5"})
	aadd(_aCampos,{"C6_ENTREG","C6_ENTREG","SC6"})


// =====> Bloco Indicador
	aadd(_aCampos,{"D1_DESC","D1_DESC","SD1"})
	aadd(_aCampos,{"D1_DESCZFR","D1_DESCZFR","SD1"})
	aadd(_aCampos,{"D1_DESCON","D1_DESCON","SD1"})
	aadd(_aCampos,{"D1_PRUNIT","D1_PRUNIT","SD1"})
	aadd(_aCampos,{"D1_QUANT","D1_QUANT","SD1"})
	aadd(_aCampos,{"D1_VARPRUN","D1_VARPRUN","SD1"})
	aadd(_aCampos,{"D1_VLIMPOR","D1_VLIMPOR","SD1"})
	aadd(_aCampos,{"D1_DESPESA","D1_DESPESA","SD1"})
	aadd(_aCampos,{"D1_SEGURO","D1_SEGURO","SD1"})
	aadd(_aCampos,{"D1_VALFRE","D1_VALFRE","SD1"})
	aadd(_aCampos,{"D1_VALACRS","D1_VALACRS","SD1"})
	aadd(_aCampos,{"D1_VALBRUT","D1_VALBRUT","SD1"})
	aadd(_aCampos,{"D1_TOTAL","D1_TOTAL","SD1"})
	aadd(_aCampos,{"D1_VUNIT","D1_VUNIT","SD1"})





// =====> Bloco Indicadores Impostos
	aadd(_aCampos,{"D1_ICMFRET","D1_ICMFRET","SD1"})
	aadd(_aCampos,{"D1_BRICMS","D1_BRICMS","SD1"})
	aadd(_aCampos,{"D1_ICMSRET","D1_ICMSRET","SD1"})
	aadd(_aCampos,{"D1_VALCSL","D1_VALCSL","SD1"})
	aadd(_aCampos,{"D1_VALIMP5","D1_VALIMP5","SD1"})
	aadd(_aCampos,{"D1_VALIMP6","D1_VALIMP6","SD1"})
	aadd(_aCampos,{"D1_VALICM","D1_VALICM","SD1"})
	aadd(_aCampos,{"D1_VALIPI","D1_VALIPI","SD1"})

// =====> Bloco Indicadores Custo
	aadd(_aCampos,{"D1_CUSTO","D1_CUSTO","SD1"})
	aadd(_aCampos,{"D1_CUSRP1","D1_CUSRP1","SD1"})

// =====> Bloco Indicadores Comissoes
	aadd(_aCampos,{"D2_COMIS1","D2_COMIS1","SD2"})
	aadd(_aCampos,{"D2_COMIS2","D2_COMIS2","SD2"})


// =====> Bloco Indicadores Alíquotas
	aadd(_aCampos,{"D1_PICM","D1_PICM","SD1"})
	aadd(_aCampos,{"D1_ALQIMP5","D1_ALQIMP5","SD1"})
	aadd(_aCampos,{"D1_ALQIMP6","D1_ALQIMP6","SD1"})
	aadd(_aCampos,{"D1_IPI","D1_IPI","SD1"})


// =====> Bloco Indicadores Bases
	aadd(_aCampos,{"D1_BASEORI","D1_BASEORI","SD1"})
	aadd(_aCampos,{"D1_BASEICM","D1_BASEICM","SD1"})
	aadd(_aCampos,{"D1_BASIMP5","D1_BASEIMP5","SD1"})
	aadd(_aCampos,{"D1_BASIMP6","D1_BASEIMP6","SD1"})
	aadd(_aCampos,{"D1_BASEIPI","D1_BASEIPI","SD1"})


	// Adicionando propriedades do dicionario ao array
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aCampos)
		If SX3->(DbSeek(AllTrim(_aCampos[nX][1]))) .and. SX3->X3_CONTEXT != "V"
//			Aadd(_aHeader,{ SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
//			Aadd(_aHeader,{ AllTrim(_aCampos[nX][1]),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_CAMPO,AllTrim(_aCampos[nX][3])})
			Aadd(_aHeader,{ AllTrim(_aCampos[nX][1]),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,AllTrim(_aCampos[nX][2]),AllTrim(_aCampos[nX][3])})

		Endif
	Next nX

	_cQuery := ""
	_cQuery += " SELECT "
	// Adicionar os campos ao select
	For _nCount := 1 to Len(_aHeader)
		if _nCount == 1
//			_cQuery += " "+AllTrim(_aHeader[_nCount][1])
			_cQuery += " "+AllTrim(_aHeader[_nCount][15])+"."+AllTrim(_aHeader[_nCount][1])+" AS "+AllTrim(_aHeader[_nCount][14])
		else
//			_cQuery += ", "+AllTrim(_aHeader[_nCount][1])
			_cQuery += ", "+AllTrim(_aHeader[_nCount][15])+"."+AllTrim(_aHeader[_nCount][1])+" AS "+AllTrim(_aHeader[_nCount][14])
		endif
	Next
	_cQuery += " FROM "+RetSqlName("SD1")+" AS SD1"
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SD2")+" AS SD2 ON D1_FILIAL = D2_FILIAL AND D1_NFORI = D2_DOC AND D1_SERIORI = D2_SERIE AND D1_ITEMORI = D2_ITEM AND D1_FORNECE = D2_CLIENTE AND D1_LOJA = D2_LOJA
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SF2")+" AS SF2 ON D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA ""
	_cQuery += " INNER JOIN "+RetSqlName("SF4")+" AS SF4 ON D1_TES = F4_CODIGO "
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 ON D1_FORNECE = A1_COD AND D1_LOJA = A1_LOJA "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON D1_FILIAL = B1_FILIAL AND D1_COD = B1_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SC6")+" AS SC6 ON D2_FILIAL = C6_FILIAL AND D2_PEDIDO = C6_NUM AND D2_ITEMPV = C6_ITEM "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SC5")+" AS SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SE4")+" AS SE4 ON F2_COND = E4_CODIGO "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" AS SA31 ON F2_VEND1 = SA31.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" AS SA32 ON F2_VEND2 = SA32.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("NNR")+" AS NNR ON D2_LOCAL = NNR_CODIGO "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SBM")+" AS SBM ON B1_GRUPO = BM_GRUPO "
	_cQuery += " WHERE SD1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ( SD2.D_E_L_E_T_ = ' ' OR SD2.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SF2.D_E_L_E_T_ = ' ' OR SF2.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SE4.D_E_L_E_T_ = ' ' OR SE4.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SC6.D_E_L_E_T_ = ' ' OR SC6.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SC5.D_E_L_E_T_ = ' ' OR SC5.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SA31.D_E_L_E_T_ = ' ' OR SA31.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SA32.D_E_L_E_T_ = ' ' OR SA32.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( NNR.D_E_L_E_T_ = ' ' OR NNR.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND SD1.D1_TIPO = 'D' "
	_cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRBDEV", .F., .T.)
	aEval(_aHeader, {|e| If(e[2] != "C", TCSetField("TRBDEV", e[14], e[2],e[3],e[4]),Nil)})

	// Montar o Acols
	DbSelectArea("TRBDEV")
	DbGoTop()
	While !Eof()
		_aAux := {}
		For _nCount := 1 to FCount()
			Aadd(_aAux,FieldGet(_nCount))
		Next
		Aadd(_aCols,_aAux)
		DbSelectArea("TRBDEV")
		DbSkip()
	End

GDToExcel(_aHeader,_aCols,"DEVOLUCAO","DEV_MOVIMENTOS")

	DbSelectArea("TRBDEV")
	DbCloseArea("TRBDEV")
Return(.T.)

/*
Função: GeraEst()
Autor: Gerson Belini
Data 22/10/2016
Descrição: Gerar consulta no banco para obtenção de dados de faturamento em determinado período
Sintaxe: GeraEst()
*/
Static Function GeraEst()
	Local _cQuery  := ""
	Local _dInicio := ""
	Local _dFinal  := ""
	Local _aCampos := {}
	Local _aHeader := {}
	Local _aCols   := {}

	// Criar um array com as colunas que serão exibidas, podendo ser adicionadas ou reduzidas colunas
	// Total de colunas limitadas a 256

	aadd(_aCampos,{"B1_FILIAL"})
	aadd(_aCampos,{"B1_COD"})
	aadd(_aCampos,{"B1_DESC"})
	aadd(_aCampos,{"B1_TIPO"})
	aadd(_aCampos,{"B1_UM"})
	aadd(_aCampos,{"B1_GRUPO"})
	aadd(_aCampos,{"B1_POSIPI"})
	aadd(_aCampos,{"B1_EMIN"})
	aadd(_aCampos,{"B1_EMAX"})
	aadd(_aCampos,{"B1_LE"})
	aadd(_aCampos,{"B1_LM"})
	aadd(_aCampos,{"B1_UPRC"})
	aadd(_aCampos,{"B1_CUSTD"})
	aadd(_aCampos,{"B1_UREV"})
	aadd(_aCampos,{"B1_DATREF"})
	aadd(_aCampos,{"B1_COMIS"})
	aadd(_aCampos,{"B1_ZCUBAGE"})
	aadd(_aCampos,{"B2_LOCAL"})
	aadd(_aCampos,{"B2_QATU"})
	aadd(_aCampos,{"B2_CM1"})
	aadd(_aCampos,{"B2_VATU1"})
	aadd(_aCampos,{"B2_QEMP"})
	aadd(_aCampos,{"B2_QEMPN"})
	aadd(_aCampos,{"B2_RESERVA"})
	aadd(_aCampos,{"B2_QPEDVEN"})
	aadd(_aCampos,{"B2_SALPEDI"})
	aadd(_aCampos,{"B2_CMRP1"})
	aadd(_aCampos,{"B2_LOCALIZ"})
	aadd(_aCampos,{"B3_CLASSE"})
	aadd(_aCampos,{"B3_MEDIA"})
	aadd(_aCampos,{"B3_MES"})


	// Adicionando propriedades do dicionario ao array

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aCampos)
		If SX3->(DbSeek(AllTrim(_aCampos[nX][1]))) .and. SX3->X3_CONTEXT != "V"
			Aadd(_aHeader,{ SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

	_cQuery := ""
	_cQuery += " SELECT "
	// Adicionar os campos ao select
	For _nCount := 1 to Len(_aHeader)
		if _nCount == 1
			_cQuery += " "+AllTrim(_aHeader[_nCount][1])
		else
			_cQuery += ", "+AllTrim(_aHeader[_nCount][1])
		endif
	Next
	
	_cQuery += " FROM "+RetSqlName("SB1")+" AS SB1"
	_cQuery += " INNER JOIN "+RetSqlName("SB2")+" AS SB2 ON B1_FILIAL = B1_FILIAL AND B1_COD = B2_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SB3")+" AS SB3 ON B1_FILIAL = B3_FILIAL AND B1_COD = B3_COD "
	_cQuery += " WHERE SB1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SB2.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ( SB3.D_E_L_E_T_ = ' '  OR SB3.D_E_L_E_T_ IS NULL ) "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRBEST", .F., .T.)
	aEval(_aHeader, {|e| If(e[2] != "C", TCSetField("TRBEST", e[1], e[2],e[3],e[4]),Nil)})

	// Montar o Acols
	DbSelectArea("TRBEST")
	DbGoTop()
	While !Eof()
		_aAux := {}
		For _nCount := 1 to FCount()
			Aadd(_aAux,FieldGet(_nCount))
		Next
		Aadd(_aCols,_aAux)
		DbSelectArea("TRBEST")
		DbSkip()
	End

GDToExcel(_aHeader,_aCols,"ESTOQUES","EST_MOVIMENTOS")

	DbSelectArea("TRBEST")
	DbCloseArea("TRBEST")

Return(.T.)


/*
Função: GeraEst()
Autor: Gerson Belini
Data 22/10/2016
Descrição: Gerar consulta no banco para obtenção de dados de faturamento em determinado período
Sintaxe: GeraEst()
*/
Static Function GeraCar()
	Local _cQuery  := ""
	Local _dInicio := ""
	Local _dFinal  := ""
	Local _aCampos := {}
	Local _aHeader := {}
	Local _aCols   := {}

	// Criar um array com as colunas que serão exibidas, podendo ser adicionadas ou reduzidas colunas
	// Total de colunas limitadas a 256

	aadd(_aCampos,{"C5_EMISSAO","C5_EMISSAO","SC5"})
	aadd(_aCampos,{"C5_FILIAL","C5_FILIAL","SC5"})
	aadd(_aCampos,{"C5_NUM","C5_NUM","SC5"})
	aadd(_aCampos,{"C5_CLIENTE","C5_CLIENTE","SC5"})
	aadd(_aCampos,{"C5_LOJACLI","C5_LOJACLI","SC5"})
	aadd(_aCampos,{"A1_NOME","A1_NOME","SA1"})
	aadd(_aCampos,{"A1_NREDUZ","A1_NREDUZ","SA1"})
	aadd(_aCampos,{"A1_MUN","A1_MUN","SA1"})
	aadd(_aCampos,{"A1_EST","A1_EST","SA1"})
	aadd(_aCampos,{"A1_REGIAO","A1_REGIAO","SA1"})
	aadd(_aCampos,{"C5_CONDPAG","C5_CONDPAG","SC5"})
	aadd(_aCampos,{"E4_DESCRI","E4_DESCI","SE4"})
	aadd(_aCampos,{"E4_ZNRDIAS","E4_ZNRDIAS","SE4"})	
	
	aadd(_aCampos,{"C5_VEND1","C5_VEND1","SC5"})
	aadd(_aCampos,{"A3_NOME","A3_NOME1","SA31"})
	aadd(_aCampos,{"A3_NREDUZ","A3_NREDUZ1","SA31"})
	aadd(_aCampos,{"A3_REGIAO","A3_REGIAO1","SA31"})
	aadd(_aCampos,{"A3_EST","A3_EST1","SA31"})
	aadd(_aCampos,{"C5_VEND2","C5_VEND2","SC5"})
	aadd(_aCampos,{"A3_NOME","A3_NOME2","SA32"})
	aadd(_aCampos,{"A3_NREDUZ","A3_NREDUZ2","SA32"})
	aadd(_aCampos,{"A3_REGIAO","A3_REGIAO2","SA32"})
	aadd(_aCampos,{"A3_EST","A3_EST2","SA32"})

	aadd(_aCampos,{"F4_CODIGO","F4_CODIGO","SF4"})
	aadd(_aCampos,{"F4_DUPLIC","F4_DUPLIC","SF4"})
	aadd(_aCampos,{"F4_ESTOQUE","F4_ESTOQUE","SF4"})
	aadd(_aCampos,{"F4_TEXTO","F4_TEXTO","SF4"})
	aadd(_aCampos,{"F4_CF","F4_CF","SF4"})
	aadd(_aCampos,{"B1_COD","B1_COD","SB1"})
	aadd(_aCampos,{"B1_DESC","B1_DESC","SB1"})
	aadd(_aCampos,{"B1_GRUPO","B1_GRUPO","SB1"})
	aadd(_aCampos,{"BM_DESC","BM_DESC","SBM"})
	aadd(_aCampos,{"B1_TIPO","B1_TIPO","SB1"})
	aadd(_aCampos,{"C6_UM","C6_UM","SC6"})
	aadd(_aCampos,{"C6_PRCVEN","C6_PRCVEN","SC6"})
	aadd(_aCampos,{"C6_VALOR","C6_VALOR","SC6"})
	aadd(_aCampos,{"C6_COMIS1","C6_COMIS1","SC6"})
	aadd(_aCampos,{"C5_COMIS2","C5_COMIS2","SC5"})
	aadd(_aCampos,{"C6_ENTREG","C6_ENTREG","SC6"})
	aadd(_aCampos,{"C6_ZPRTAB","C6_ZPRTAB","SC6"})
	aadd(_aCampos,{"C6_ZPERDES","C6_ZPERDES","SC6"})
	aadd(_aCampos,{"C6_ZREDCOM","C6_ZREDCOM","SC6"})
	aadd(_aCampos,{"C6_ZPERCOM","C6_ZPERCOM","SC6"})
	


	// Adicionando propriedades do dicionario ao array

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aCampos)
		If SX3->(DbSeek(AllTrim(_aCampos[nX][1]))) .and. SX3->X3_CONTEXT != "V"
//			Aadd(_aHeader,{ SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
//			Aadd(_aHeader,{ AllTrim(_aCampos[nX][1]),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_CAMPO,AllTrim(_aCampos[nX][3])})
			Aadd(_aHeader,{ AllTrim(_aCampos[nX][1]),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,AllTrim(X3Titulo()),SX3->X3_PICTURE,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,AllTrim(_aCampos[nX][2]),AllTrim(_aCampos[nX][3])})
		Endif
	Next nX

	_cQuery := ""
	_cQuery += " SELECT "
	// Adicionar os campos ao select
	For _nCount := 1 to Len(_aHeader)
		if _nCount == 1
//			_cQuery += " "+AllTrim(_aHeader[_nCount][1])
			_cQuery += " "+AllTrim(_aHeader[_nCount][15])+"."+AllTrim(_aHeader[_nCount][1])+" AS "+AllTrim(_aHeader[_nCount][14])
		else
//			_cQuery += ", "+AllTrim(_aHeader[_nCount][1])
			_cQuery += ", "+AllTrim(_aHeader[_nCount][15])+"."+AllTrim(_aHeader[_nCount][1])+" AS "+AllTrim(_aHeader[_nCount][14])
		endif
	Next



	
	_cQuery += " FROM "+RetSqlName("SC5")+" AS SC5"
	_cQuery += " INNER JOIN "+RetSqlName("SC6")+" AS SC6 ON C5_FILIAL = C5_FILIAL AND C5_NUM = C6_NUM "
	_cQuery += " INNER JOIN "+RetSqlName("SA1")+" AS SA1 ON C5_CLIENTE = A1_COD AND C5_LOJACLI = A1_LOJA "
	_cQuery += " INNER JOIN "+RetSqlName("SB1")+" AS SB1 ON C6_FILIAL = B1_FILIAL AND C6_PRODUTO = B1_COD "
	_cQuery += " INNER JOIN "+RetSqlName("SF4")+" AS SF4 ON C6_TES = F4_CODIGO "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" AS SA31 ON C5_VEND1 = SA31.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SA3")+" AS SA32 ON C5_VEND2 = SA32.A3_COD "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SE4")+" AS SE4 ON C5_CONDPAG = E4_CODIGO "
	_cQuery += " LEFT OUTER JOIN "+RetSqlName("SBM")+" AS SBM ON B1_GRUPO = BM_GRUPO "
	_cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SC6.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SF4.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ( SA31.D_E_L_E_T_ = ' '  OR SA31.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SA32.D_E_L_E_T_ = ' '  OR SA32.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SE4.D_E_L_E_T_ = ' '  OR SE4.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND ( SBM.D_E_L_E_T_ = ' '  OR SBM.D_E_L_E_T_ IS NULL ) "
	_cQuery += " AND SC5.C5_TIPO NOT IN('BD') "
	_cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRBCAR", .F., .T.)
	aEval(_aHeader, {|e| If(e[2] != "C", TCSetField("TRBCAR", e[14], e[2],e[3],e[4]),Nil)})

	// Montar o Acols
	DbSelectArea("TRBCAR")
	DbGoTop()
	While !Eof()
		_aAux := {}
		For _nCount := 1 to FCount()
			Aadd(_aAux,FieldGet(_nCount))
		Next
		Aadd(_aCols,_aAux)
		DbSelectArea("TRBCAR")
		DbSkip()
	End

	GDToExcel(_aHeader,_aCols,"CARTEIRA","CAR_MOVIMENTOS")

	DbSelectArea("TRBCAR")
	DbCloseArea("TRBCAR")

Return(.T.)


/*
Funcao: GDToExcel
Autor: Marinaldo de Jesus
Data: 01/06/2013
Descricao: Mostrar os Dados no Excel
Sintaxe: StaticCall(NDJLIB001,GDToExcel,aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture)
*/
Static Function GDToExcel(aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture)

	Local oFWMSExcel := FWMSExcel():New()

	Local oMsExcel

	Local aCells

	Local cType
	Local cColumn

	Local cFile
	Local cFileTMP

	Local cPicture

	Local lTotal

	Local nRow
	Local nRows
	Local nField
	Local nFields

	Local nAlign
	Local nFormat

	Local uCell

	DEFAULT cWorkSheet := "GETDADOS"
	DEFAULT cTable := cWorkSheet
	DEFAULT lTotalize := .T.
	DEFAULT lPicture := .F.

	BEGIN SEQUENCE

		oFWMSExcel:AddworkSheet(cWorkSheet)
		oFWMSExcel:AddTable(cWorkSheet,cTable)

		nFields := Len( aHeader )
		For nField := 1 To nFields
//			cType := aHeader[nField][__aHeader_TYPE__]
			cType := aHeader[nField][2]
			nAlign := IF(cType=="C",1,IF(cType=="N",3,2))
			nFormat := IF(cType=="D",4,IF(cType=="N",2,1))
//			cColumn := aHeader[nField][__aHeader_TITLE__]
			cColumn := aHeader[nField][5]
			lTotal := ( lTotalize .and. cType == "N" )
			oFWMSExcel:AddColumn(@cWorkSheet,@cTable,@cColumn,@nAlign,@nFormat,@lTotal)
		Next nField

		aCells := Array(nFields)

		nRows := Len( aCols )
		For nRow := 1 To nRows
			For nField := 1 To nFields
				uCell := aCols[nRow][nField]
				IF ( lPicture )
//					cPicture := aHeader[nField][__aHeader_PICTURE__]
					cPicture := aHeader[nField][6]
					IF .NOT.( Empty(cPicture) )
						uCell := Transform(uCell,cPicture)
					EndIF
				EndIF
				cType := aHeader[nField][2] // Verificar data vazia e deixar sem formato, gera erro no XML
				if cType == "D" .and. uCell == stod("")
					aCells[nField] := ""
				else
					aCells[nField] := uCell
				endif
			Next nField
			oFWMSExcel:AddRow(@cWorkSheet,@cTable,aClone(aCells))
		Next nRow

		oFWMSExcel:Activate()

		cFile := ( CriaTrab( NIL, .F. ) + ".xml" )

		While File( cFile )
			cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
		End While

		oFWMSExcel:GetXMLFile( cFile )
		oFWMSExcel:DeActivate()

		IF .NOT.( File( cFile ) )
			cFile := ""
			BREAK
		EndIF

		//cFileTMP := ( GetTempPath() + cFile )
		cFileTMP := ( AllTrim(_cDirSave) + cFile )
		IF .NOT.( __CopyFile( cFile , cFileTMP ) )
			fErase( cFile )
			cFile := ""
			BREAK
		EndIF

		fErase( cFile )

		cFile := cFileTMP

		IF .NOT.( File( cFile ) )
			cFile := ""
			BREAK
		EndIF

		IF .NOT.( ApOleClient("MsExcel") )
			BREAK
		EndIF

		oMsExcel := MsExcel():New()
		oMsExcel:WorkBooks:Open( cFile )
		oMsExcel:SetVisible( .T. )
		oMsExcel := oMsExcel:Destroy()

	END SEQUENCE

	oFWMSExcel := FreeObj( oFWMSExcel )

Return( cFile )



/*
/*
Funcao: AjustaSX1
Autor: Gerson Belini
Data: 22/10/2016
Descricao: Ajustar o Grupo de Perguntas
Sintaxe: StaticCall(AjustaSX1,cPerg)
*/
Static Function AjustaSx1(cPerg)

Local aHelpPor1 := {}
Local aHelpEsp1 := {}
Local aHelpEng1 := {}

Local aHelpPor2 := {}
Local aHelpEsp2 := {}
Local aHelpEng2 := {}


aHelpPor1 :=	{"Indica o período inicial para geração das informações."} 
aHelpEsp1 :=	{"Indica o período inicial para geração das informações."}
aHelpEng1 :=	{"Indicates the beginnig period to generate the information."}

aHelpPor2 :=	{"Indica o período final para geração das informações."} 
aHelpEsp2 :=	{"Indica o período final para geração das informações."}
aHelpEng2 :=	{"Indicates the final period to generate the information."}

PutSx1( cPerg, 	"01","Período Inicial ?","Período Inicial   ?","Beginning Period     ?","mv_ch1","D",8,0,0,"G","","","","",;
				"mv_par01",,,,,,,,;
				"","","","","","","","","",aHelpPor1,aHelpEng1,aHelpEsp1)
PutHelp( "P.BBCONEXC01.", aHelpPor1, aHelpEng1, aHelpEsp1, .T. )
PutSx1( cPerg, 	"02","Período Final ?","Período Final   ?","Final Period     ?","mv_ch2","D",8,0,0,"G","","","","",;
				"mv_par02",,,,,,,,;
				"","","","","","","","","",aHelpPor1,aHelpEng1,aHelpEsp1)
PutHelp( "P.BBCONEXC02.", aHelpPor2, aHelpEng2, aHelpEsp2, .T. )
Return