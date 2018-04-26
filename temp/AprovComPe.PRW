#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AprovComPeº Autor ³ Gerson Belini      º Data ³ 25/09/2016  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para aprovacao comercial de pedido                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico BBauer                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AprovComPe()
Local cAlias := "Z04"
Local aCores := {}
Private cCadastro := "Aprovacao Comercial de pedido"
Private aRotina := {}
Private _cMotRej


_cQuery := ""
_cQuery += " SELECT C5_FILIAL C5_FILIAL, "
_cQuery += " C5_NUM C5_NUM, "
_cQuery += " C5_VEND1, "
_cQuery += " A1_NOME C5_NOME, "
_cQuery += " Z04_ORDAPR C5_ORDAPRO "
_cQuery += " FROM Z04010, "
_cQuery += " SA1010, "
_cQuery += " SC5010 "
_cQuery += " WHERE Z04010.D_E_L_E_T_ = ' '"
_cQuery += " AND SA1010.D_E_L_E_T_ = ' '"
_cQuery += " AND SC5010.D_E_L_E_T_ = ' '"
_cQuery += " AND Substring(Z04_DOCUME,1,2) = C5_FILIAL "
_cQuery += " AND Substring(Z04_DOCUME,3,6) = C5_NUM "
_cQuery += " AND C5_CLIENTE = A1_COD "
_cQuery += " AND C5_LOJACLI = A1_LOJA "
_cQuery += " AND Z04_APROVA = '"+__cUserId+"' "
_cQuery += " AND Z04_DTACAO = '        '  "
_cQuery += " AND Z04_STATUS = 'A' "
_cQuery += " AND Z04_ACAO = '1' "


_cQuery := ChangeQuery(_cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'SSC5', .F., .T.)

If SSC5->(eof())
	Alert("Nâo foram encontrados pedidos de venda de acordo com os especificacoes!")
	SSC5->(dbCloseArea())
	Return
Endif

aCampos:= {;
{"C5_FILIAL","C",2,0},;
{"C5_NUM"   ,"C",6,0},;
{"C5_VEND1" ,"C",6,0},;
{"C5_NOME"  ,"C",40,0},;
{"C5_ORDAPRO","C",3,0}}

cTC5 := CriaTrab(aCampos,.T.)
dbUseArea( .T.,"DBFCDX", cTC5, "TSC5", .F., .F. )
cChaveT := "C5_FILIAL+C5_NUM"
IndRegua("TSC5",cTC5,cChaveT,,,"")

lEnd   := .F.
bBloco := {|lEnd| OkProc()}
MsAguarde(bBloco,"Aguarde",OemtoAnsi("Gerando Arquivo Temporário..."),.T.)

/*
[n][1]  -->  Descrição do campo

[n][2]  -->  Nome do campo

[n][3]  -->  Tipo do dado: “C” (caracter), “N” (numérico), “D” (data), etc.

[n][4]  -->  Tamanho

[n][5]  -->  Número de casas decimais

[n][6]  -->  Picture (formatação dos dados)
*/

 
aFixe:=		{{ OemToAnsi("Filial"),"C5_FILIAL","C",2,0,"@!" },;
			{ OemToAnsi("Numero PV"),"C5_NUM","C",6,0,"@!" },;
			{ OemToAnsi("Cod.Vend") ,"C5_VEND1","C",6,0,"@!" },;
			{ OemToAnsi("Nome Cliente"),"C5_NOME","C",100,0,"@!" }}

aCores    := {}


cCadastro := "Aprovacao Comercial de pedido"
aRotina := {}
AADD(aRotina,{"Pesquisar" ,"PesqBrw" ,0,1})
AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
AADD(aRotina,{"Detalhes" ,"U_AprCPVis",0,3})
AADD(aRotina,{"Analisar" ,"U_Analisa",0,4})


dbSelectArea("TSC5")
dbSetOrder(1)		// 1-Filial+Pedido   2-Clie+LJ+PV    3-NUMVOP

mBrowse( 6, 1,22,75,"TSC5",aFixe,,,,,aCores)

dbSelectArea("TSC5")
DBCLOSEAREA("TSC5")

Return


User Function Analisa()
Local aArea          := GetArea()
Local oNoMarked      := LoaDBitmap( GetResources(), "LBNO" )
Local oMarked        := LoaDBitmap( GetResources(), "LBOK" )
Private oDlgMain
Private cPict        := PesqPict('SB2','B2_QATU')
Private cPict2UM     := PesqPict('SB2','B2_QTSEGUM')
Private cPictD5      := PesqPict('SD5','D5_QUANT')
Private cPictDB      := PesqPict('SDB','DB_QUANT')
Private cPictB1      := PesqPict('SB1','B1_CONV')
Private aDetSBJ      := {}
Private aAnaSBJ      := {}
Private aAnaZX6      := {}
//Private aDocto       := {}
Private aNumSeq      := {}
Private cLocal       := Space(TamSX3("B2_LOCAL")[1])
Private dDtProces    := dDataBase
Private dUltFech     := dDataI := dDataF := CTOD("  /  /  ")
Private nSB9         := 0
Private nSBJ         := 0
Private nSBK         := 0
Private nKAR         := 0
Private nSD5         := 0
Private nSDB         := 0
Private nSB2         := 0
Private nSB8         := 0
Private nSBF         := 0
Private nSDA         := 0
Private nDASB2       := 0
Private nDASB8       := 0
Private nSldKarLocal := nSldKarLote := nSldKarEnde := 0
Private cProduto     := Space(TamSX3("B1_COD")[1])
Private cDescr       := Space(40)
Private nOpSB8       := 1
Private nOpSBF       := 1
Private cMensagem    := ""
Private cMensOK      := ""
Private cMensErro    := ""
Private cMensSB8     := ""
Private cMensSBF     := ""
Private cCrlLot      := ""
Private cCrlEnd      := ""
Private c1UM         := ""
Private c2UM         := ""
Private nFatConv     := 0
Private cTipConv     := ""
Private cZona        := ""
Private aSx3Box      := RetSx3Box(Posicione('SX3',2,'BE_STATUS','X3CBox()'),,,1)
Private cMensB8BF    := ""
Private cMensBJBK    := ""
Private cMensDocto   := ""
Private cMensNumSeq  := ""
Private cMensDAB8    := ""
Private _lReturn     := .F.
Private oSB9
Private oSBJ
Private oSBK
Private oKAR
Private oSD5
Private oSDB
Private oSB2
Private oSB8
Private oSBF
Private oSDA
Private oDASB2
Private oDASB8
Private lNumLote     := SuperGetMV('MV_LOTEUNI', .F., .F.)
Private cNumPedQual  := " "
Private cNumPedvend  := " "
Private cVendedor    := " "
Private dDtEmissao   := " "
Private dDtEntrega   := " "
Private cTpFrete     := " "
Private cCanalVend   := " "
Private cCondPagam   := " "
Private cCliente     := " "
Private cEntrega     := " "
Private cSegClient   := " "
Private cUniFatura   := " "
Private cMotBloPed   := " "

Aadd(aDetSBJ   ,{Space(10),0    ,0       ,Space(08)})
//Lote     ,Nunlote  ,Validade        ,Quantidade
//Aadd(aAnaSBJ   ,{Space(6),Space(30), 0.000, Space(30), 0.00000, 0.00000,0.0000, 0.0000,0.0000,0.00 ,0.00, 0.00})
Aadd(aAnaSBJ   ,{Space(15),Space(30), 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000})
//Lote     ,Qtde.,Qtde.2UM,Status
Aadd(aAnaZX6   ,{Space(30), 0.000, 0.00000, 0.00000})
//Lote     ,Qtde.,Qtde.2UM,Status

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(TSC5->C5_FILIAL+TSC5->C5_NUM)
cNumPedvend  := ""
//cVendedor    :=
dDtEmissao   := DTOC(SC5->C5_EMISSAO)
dDtEntrega   := STOD("")
cTpFrete     := SC5->C5_TPFRETE
cCanalVend   := ""
cCondPagam   := ""
cEntrega     := ""
cSegClient   := ""
cUniFatura   := SM0->M0_CODFIL+SM0->M0_NOME
cMotBloPed   := ""
DbSelectArea("SE4")
DbSetOrder(1)
DbSeek(xFilial("SE4")+SC5->C5_CONDPAG)
cCondPagam   := SE4->E4_CODIGO+' - '+SE4->E4_DESCRI

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

cCliente     := SA1->A1_COD+' - '+SA1->A1_LOJA+' - '+AllTrim(SA1->A1_NOME)

DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial("SA3")+SC5->C5_VEND1)
cVendedor := SA3->A3_COD+" - "+SA3->A3_NOME

DEFINE MSDIALOG oDlgMain TITLE "Aprovação de Pedido Comercial"  OF oMainWnd PIXEL FROM 040,040 TO 650,1017
DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oBold2  NAME "Arial" SIZE 0, -40 BOLD
DEFINE FONT oBold3  NAME "Arial" SIZE 0, -80 BOLD
DBSelectArea("SB1")

//@ 060,006 FOLDER oFolder OF oDlgMain PROMPT "SBJ" PIXEL SIZE 478,241
@ 120,006 FOLDER oFolder OF oDlgMain PROMPT "ITENS" PIXEL SIZE 478,241
//

/*                                           01       02         03          04           05          06    07    08                09                 10                11                   12
@ 014,010 SAY "Número do pedido do vendedor:" SIZE 120,10 PIXEL OF oDlgMain FONT oBold
@ 010,110 MSGET oVar   VAR cNumPedvend Picture "@!"        SIZE 050,10 PIXEL OF oDlgMain
//@ 014,182 SAY "Número do Pedido do Vendedor:" SIZE 100,10 PIXEL OF oDlgMain FONT oBold
//@ 010,275 MSGET oVar   VAR cNumPedvend   Picture "@!"        SIZE 050,10 PIXEL OF oDlgMain
@ 014,162 SAY "Vendedor:" SIZE 040,10 PIXEL OF oDlgMain FONT oBold
@ 010,196 MSGET oVar   VAR cVendedor   Picture "@!" SIZE 240,10 PIXEL OF oDlgMain
@ 032,010 SAY "Data emissão:"                       SIZE 042,10 PIXEL OF oDlgMain FONT oBold
@ 028,055 MSGET oVar   VAR dDtEmissao  Picture "@!" SIZE 040,10 PIXEL OF oDlgMain
@ 032,100 SAY "Data entrega:"                       SIZE 042,10 PIXEL OF oDlgMain FONT oBold
@ 028,145 MSGET oVar   VAR dDtEntrega  Picture "@!" SIZE 040,10 PIXEL OF oDlgMain
@ 032,190 SAY "Tipo de frete:"                      SIZE 042,10 PIXEL OF oDlgMain FONT oBold
@ 028,235 MSGET oVar   VAR cTpFrete  Picture "@!"   SIZE 040,10 PIXEL OF oDlgMain
@ 032,280 SAY "Canal de venda:"                     SIZE 045,10 PIXEL OF oDlgMain FONT oBold
@ 028,330 MSGET oVar   VAR cCanalVend  Picture "@!" SIZE 020,10 PIXEL OF oDlgMain
@ 049,010 SAY "Condição de pagamento:"              SIZE 090,10 PIXEL OF oDlgMain FONT oBold
@ 045,090 MSGET oVar   VAR cCondPagam  Picture "@!" SIZE 070,10 PIXEL OF oDlgMain
@ 049,165 SAY "Unidade de faturamento:"             SIZE 080,10 PIXEL OF oDlgMain FONT oBold
@ 045,240 MSGET oVar   VAR cUniFatura  Picture "@!" SIZE 080,10 PIXEL OF oDlgMain

@ 066,010 SAY "Cliente:"              			    SIZE 040,10 PIXEL OF oDlgMain FONT oBold
@ 061,042 MSGET oVar   VAR cCliente  Picture "@!"   SIZE 395,10 PIXEL OF oDlgMain
@ 083,010 SAY "Entrega:"            			    SIZE 040,10   PIXEL OF oDlgMain FONT oBold
@ 078,042 MSGET oVar   VAR cEntrega  Picture "@!"   SIZE 300,10 PIXEL OF oDlgMain
@ 083,350 SAY "Segmento do cliente:"                SIZE 060,10 PIXEL OF oDlgMain FONT oBold
@ 078,417 MSGET oVar   VAR cSegClient  Picture "@!" SIZE 020,10 PIXEL OF oDlgMain
@ 100,010 SAY "Motivo de bloqueio do pedido:"       SIZE 090,10 PIXEL OF oDlgMain FONT oBold
@ 095,100 MSGET oVar   VAR cMotBloPed  Picture "@!" SIZE 337,10 PIXEL OF oDlgMain
*/


@ 014,012 SAY "Vendedor:" SIZE 040,10 PIXEL OF oDlgMain FONT oBold
@ 010,046 MSGET oVar   VAR cVendedor   Picture "@!" SIZE 240,10 PIXEL OF oDlgMain
@ 032,010 SAY "Data emissão:"                       SIZE 042,10 PIXEL OF oDlgMain FONT oBold
@ 028,055 MSGET oVar   VAR dDtEmissao  Picture "@!" SIZE 040,10 PIXEL OF oDlgMain
@ 032,100 SAY "Tipo de frete:"                      SIZE 042,10 PIXEL OF oDlgMain FONT oBold
@ 028,145 MSGET oVar   VAR cTpFrete  Picture "@!"   SIZE 040,10 PIXEL OF oDlgMain
@ 032,190 SAY "Condição de pagamento:"              SIZE 090,10 PIXEL OF oDlgMain FONT oBold
@ 028,280 MSGET oVar   VAR cCondPagam  Picture "@!" SIZE 070,10 PIXEL OF oDlgMain

@ 049,010 SAY "Cliente:"              			    SIZE 040,10 PIXEL OF oDlgMain FONT oBold
@ 045,042 MSGET oVar   VAR cCliente  Picture "@!"   SIZE 395,10 PIXEL OF oDlgMain


@ 220,002 SAY "Sugestões e melhorias para Gerson Belini e-mail: gbelini@atinet.com.br"   SIZE 200,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HBLUE
@ 220,410 SAY "Versão: 24/10/2012"                                                    SIZE 200,10 PIXEL OF oFolder:aDialogs[1] FONT oBold  COLOR CLR_HBLUE

@ 010,440 BUTTON "&Aprovar"   SIZE 36,16 PIXEL ACTION Processa({||fProcessa("1")})
@ 040,440 BUTTON "&Reprovar"   SIZE 36,16 PIXEL ACTION Processa({||fProcessa("2")})
//@ 010,420 BUTTON "&Processar"   SIZE 36,16 PIXEL ACTION Processa({||fProcessa()})
@ 070,440 BUTTON "&Sair"        SIZE 36,16 PIXEL ACTION oDlgMain:End()


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FOLDER 01
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detalhe dos ITENS

@ 003,005 SAY "DETALHES DOS ITENS"                SIZE 200,50                                  PIXEL OF oFolder:aDialogs[1] FONT oBold
@ 010,005 LISTBOX oAnaSBJ Var cModelo FIELDS HEADER;
"Cod.Produto" ,;
"Descricao" ,;
"Quantidade" ,;
"Preço Venda" ,;
"Preço Tabela" ,;
"Desc.Calculado" ,;
"Redutor Comissão" ,;
"Comissão Produto" ,;
"% IPI" ,;
"% Comis.Item" ,;
"Total"  FIELDSIZES 40,30,30,40 SIZE 467,160 ON DBLCLICK () PIXEL OF oFolder:aDialogs[1] //	 "Total" FIELDSIZES 40,30,30,40 SIZE 467,215 ON DBLCLICK () PIXEL OF oFolder:aDialogs[1]
oAnaSBJ:SetArray(aAnaSBJ)
oAnaSBJ:bLine:={ ||{aAnaSBJ[oAnaSBJ:nAT,1],aAnaSBJ[oAnaSBJ:nAT,2],aAnaSBJ[oAnaSBJ:nAT,3],aAnaSBJ[oAnaSBJ:nAT,4],aAnaSBJ[oAnaSBJ:nAT,5],aAnaSBJ[oAnaSBJ:nAT,6],aAnaSBJ[oAnaSBJ:nAT,7],aAnaSBJ[oAnaSBJ:nAT,8],aAnaSBJ[oAnaSBJ:nAT,9],aAnaSBJ[oAnaSBJ:nAT,10],aAnaSBJ[oAnaSBJ:nAT,11]}}
oAnaSBJ:Refresh()

fDetaSBJ(1)    // Detalhe do SBJ

ACTIVATE MSDIALOG oDlgMain  CENTERED

RestArea(aArea)

Return(.T.)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function TrocaTip()
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
aFolder[oBox:nAt,1] := IIF(aFolder[oBox:nAt,1],.F.,.T. )
oBox:Refresh()
Return


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function MarcaTodos(lMark)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
For nI:= 1 To Len(aFolder)
	aFolder[nI,1] := IIF(lMark,.T.,.F.)
Next
oBox:Refresh()
Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fProcessa(_cAcao)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Local _cProcApr := SuperGetMV("CL_APRPV",.T.,"PEDVENDA")+Space(TamSX3("Z04_PROCES")[1]-Len(AllTrim(SuperGetMV("CL_APRPV",.T.,"PEDVENDA")))) // Deixar o processo com 10 posições para pesquisa
Local _cDocApr  := TSC5->C5_FILIAL+TSC5->C5_NUM+Space(TamSX3("Z04_DOCUME")[1]-Len(TSC5->C5_FILIAL+TSC5->C5_NUM)) // Deixar o documento com os espaços do tamanho do campo para pesquisa
	
if _cAcao == "1"
	
	_lAcabou := .F.
	_aAreaZ04 := GetArea()
	// Guarda os dados do registro anterior e gerar um novo registro
	
	DbSelectArea("Z04")
	DbSetOrder(1)
	if !DbSeek(xFilial("Z04")+_cProcApr+_cDocApr+TSC5->C5_ORDAPRO)
		MsgAlert("Houve Problema com os registros de aprovacao. Contactar o Departamento de TI!!!")
		RestArea(_aAreaZ04)
		Return
	Endif
	While !Eof() .and. Z04->Z04_FILIAL == xFilial("Z04") .and. AllTrim(Z04->Z04_PROCES) == AllTrim(_cProcApr) .and. AllTrim(Z04->Z04_DOCUME) == AllTrim(_cDocApr) .and. TSC5->C5_ORDAPRO == Z04->Z04_ORDAPR
		if Z04->Z04_ACAO == "1"
			exit
		endif
		DbSelectArea("Z04")
		DbSkip()
	end

	RecLock("Z04",.F.)
	Z04->Z04_STATUS := "F"
	Z04->Z04_DTACAO := date()
	Z04->Z04_HORACA := Time()
	MsUnLock("Z04")
	
	RegToMemory("Z04",.F.,.F.)
	
	RecLock("Z04",.T.)
	Z04->Z04_FILIAL := m->Z04_FILIAL
	Z04->Z04_PROCES := m->Z04_PROCES
	Z04->Z04_DOCUME := m->Z04_DOCUME
	Z04->Z04_ORDAPR := m->Z04_ORDAPR
	Z04->Z04_APROVA := m->Z04_APROVA
	Z04->Z04_DTACAO := Date()
	Z04->Z04_HORACA := Time()
	Z04->Z04_RESULT := "S"
	Z04->Z04_OBSC   := m->Z04_OBSC
	Z04->Z04_MSFIL  := m->Z04_MSFIL
	Z04->Z04_MAILAP := m->Z04_MAILAP
	Z04->Z04_ACAO   := "2"
	Z04->Z04_STATUS := "F"
	Z04->Z04_NOME   := m->Z04_NOME
	Z04->Z04_IPMAQ  := GetClientIP()
	Z04->Z04_NLOGIN := LogUserName()
	Z04->Z04_NMAQ   := ComputerName()

	
/*	
	Z04->Z04_FILIAL := _cFilial
	Z04->Z04_PEDIDO := _cPedido
	Z04->Z04_ORDAPR := _cOrdApr
	Z04->Z04_APROVA := _cAprova
	Z04->Z04_DTACAO := date()
	Z04->Z04_HORACA := Time()
	Z04->Z04_RESULT := "S"
	Z04->Z04_OBSC   := _cObserv
	Z04->Z04_MSFIL  := _cMsFil
	Z04->Z04_MAILAP := _cMailApr
	Z04->Z04_NOME   := _cNomeApr
	Z04->Z04_ACAO   := "2"
	Z04->Z04_STATUS := "F"
	Z04->Z04_IPMAQ  := GetClientIP()
	Z04->Z04_NLOGIN := LogUserName()
	Z04->Z04_NMAQ   := ComputerName()
*/
	MsUnLock("Z04")
	
	// Verificar se existem mais aprovadores e mudar o Status do Registro do proximo aprovador
	_cOrdApr := Soma1(Z04->Z04_ORDAPR)
	
	DbSelectArea("Z04")
	DbSetOrder(1)
	DbSkip()
	if Eof() .or. !( Z04->Z04_FILIAL == xFilial("Z04") .and. AllTrim(Z04->Z04_PROCES) == AllTrim(_cProcApr) .and. AllTrim(Z04->Z04_DOCUME) == AllTrim(_cDocApr) )
		_lAcabou := .T.
	else
		While !Eof() .and. ( Z04->Z04_FILIAL == xFilial("Z04") .and. AllTrim(Z04->Z04_PROCES) == AllTrim(_cProcApr) .and. AllTrim(Z04->Z04_DOCUME) == AllTrim(_cDocApr) .and. Z04->Z04_ORDAPR == _cOrdApr)
			if Z04->Z04_ACAO == "1"
				RecLock("Z04",.F.)
				Z04->Z04_STATUS := "A"
				MsUnLock("Z04")
				Exit
			endif
			DbSelectArea("Z04")
			DbSkip()
		End
	endif
	
	if _lAcabou
		DbSelectArea("SC5")
		DbSetOrder(1)
		if DbSeek(TSC5->C5_FILIAL+TSC5->C5_NUM)
			if !RecLock("SC5",.F.)
			endif
			SC5->C5_DTAPCOM := dDataBase
			SC5->C5_HRAPRCO := Time()
			SC5->C5_BLQCOM := "A"
			MsUnLock("SC5")
			MsgBox("PEDIDO DESBLOQUEADO")
		endif
		
	endif
	
	RestArea(_aAreaZ04)
	RecLock("TSC5",.F.)
	DbDelete()
	MsUnLock()
	MsgBox("PEDIDO APROVADO")
	oDlgMain:End()
	// Enviar e-mail de aviso para os pedidos liberados
	Return(nil)
	
else
	MsgBox("PEDIDO REPROVADO")
	_aAreaZ04 := GetArea()
	DbSelectArea("Z04")
	DbSetOrder(1)
	DbSelectArea("Z04")
	DbSetOrder(1)
	if !DbSeek(xFilial("Z04")+_cProcApr+_cDocApr+TSC5->C5_ORDAPRO)
		MsgAlert("Houve Problema com os registros de aprovacao. Contactar o Departamento de TI!!!")
		RestArea(_aAreaZ04)
		Return
	Endif
	While !Eof() .and. Z04->Z04_FILIAL == xFilial("Z04") .and. AllTrim(Z04->Z04_PROCES) == AllTrim(_cProcApr) .and. AllTrim(Z04->Z04_DOCUME) == AllTrim(_cDocApr) .and. TSC5->C5_ORDAPRO == Z04->Z04_ORDAPR
		if Z04->Z04_ACAO == "1"
			exit
		endif
		DbSelectArea("Z04")
		DbSkip()
	end

	_cMotRej  := Z04->Z04_MOTREJ
	
	@ 322,160 to 475,565 Dialog oDlgRai Title OemToAnsi("Motivo da Rejeição")
	@ 005,005 GET _cMotRej Size 190,050 Memo
	@ 060,170 BmpButton Type 01 Action Close(oDlgRai)
	Activate Dialog oDlgRai Centered
	
	RecLock("Z04",.F.)
	Z04->Z04_STATUS := "F"
	Z04->Z04_DTACAO := date()
	Z04->Z04_HORACA := Time()
	Z04->Z04_MOTREJ := _cMotRej
	MsUnLock("Z04")
	
	RegToMemory("Z04",.F.,.F.)
	
	RecLock("Z04",.T.)
	Z04->Z04_FILIAL := m->Z04_FILIAL
	Z04->Z04_PROCES := m->Z04_PROCES
	Z04->Z04_DOCUME := m->Z04_DOCUME
	Z04->Z04_ORDAPR := m->Z04_ORDAPR
	Z04->Z04_APROVA := m->Z04_APROVA
	Z04->Z04_DTACAO := Date()
	Z04->Z04_HORACA := Time()
	Z04->Z04_MOTREJ := _cMotRej
	Z04->Z04_RESULT := "N"
	Z04->Z04_OBSC   := m->Z04_OBSC
	Z04->Z04_MSFIL  := m->Z04_MSFIL
	Z04->Z04_MAILAP := m->Z04_MAILAP
	Z04->Z04_ACAO   := "2"
	Z04->Z04_STATUS := "F"
	Z04->Z04_NOME   := m->Z04_NOME
	Z04->Z04_IPMAQ  := GetClientIP()
	Z04->Z04_NLOGIN := LogUserName()
	Z04->Z04_NMAQ   := ComputerName()



	// Verificar se existem mais aprovadores e mudar o Status do Registro do proximo aprovador
	_cOrdApr := Soma1(Z04->Z04_ORDAPR)
	
	While !Eof() .and. Z04->Z04_FILIAL == xFilial("Z04") .and. AllTrim(Z04->Z04_PROCES) == AllTrim(_cProcApr) .and. AllTrim(Z04->Z04_DOCUME) == AllTrim(_cDocApr)
		if Z04->Z04_ACAO == "1"
			RecLock("Z04",.F.)
			Z04->Z04_STATUS := "F"
			MsUnLock("Z04")
			Exit
		endif
		DbSelectArea("Z04")
		DbSkip()
	End


	
	DbSelectArea("SC5")
	DbSetOrder(1)
	if DbSeek(TSC5->C5_FILIAL+TSC5->C5_NUM)
		RecLock("SC5",.F.)
		SC5->C5_BLQCOM := "R"
		SC5->C5_NOTA   := 'XXXXXXXXX'
		MsUnLock("SC5")
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek(SC5->C5_FILIAL+SC5->C5_NUM)
		While !Eof() .and. SC5->C5_FILIAL+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
			RecLock("SC6",.F.)
			SC6->C6_BLQ := "R"
			MsUnLock("SC6")
			DbSkip()
		End
	endif
	
	
	oDlgMain:End()
	
	oDlgMain:End()
	RestArea(_aAreaZ04)
	RecLock("TSC5",.F.)
	DbDelete()
	MsUnLock()
	
endif

Return


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fDetaSBJ(nPosAT)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IncProc("Processando Detalhe - SBJ")

aSize(aAnaSBJ, 0)

// Movimento do SBJ


cQuery := " SELECT C6_FILIAL,C6_ITEM,C6_PRODUTO,C6_QTDVEN,C6_PRCVEN,C6_VALOR,C6_ZPRTAB ,C6_ZPERDES,C6_ZREDCOM,C6_ZPERCOM,C6_COMIS1,R_E_C_N_O_ AS RECNO FROM "+RETSQLNAME("SC6")
cQuery += " WHERE C6_FILIAL='"+SC5->C5_FILIAL+"' AND C6_NUM='"+SC5->C5_NUM+"' AND "+RETSQLNAME("SC6")+".D_E_L_E_T_ = ' '"
cQuery += " ORDER BY C6_ITEM"
cQuery := ChangeQuery(cQuery)
DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"QrySC6",.F.,.T.)
//TCSETFIELD( "QrySC6","BF_DTVALID","D")
TCSETFIELD( "QrySC6","C6_QTDVEN","N",TamSX3("C6_QTDVEN")[1],TamSX3("C6_QTDVEN")[2])
TCSETFIELD( "QrySC6","C6_PRCVEN","N",TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2])
TCSETFIELD( "QrySC6","C6_VALOR","N",TamSX3("C6_VALOR")[1],TamSX3("C6_VALOR")[2])
TCSETFIELD( "QrySC6","C6_ZPRTAB","N",TamSX3("C6_ZPRTAB")[1],TamSX3("C6_ZPRTAB")[2])
TCSETFIELD( "QrySC6","C6_ZPERDES","N",TamSX3("C6_ZPERDES")[1],TamSX3("C6_ZPERDES")[2])
TCSETFIELD( "QrySC6","C6_ZREDCOM","N",TamSX3("C6_ZREDCOM")[1],TamSX3("C6_ZREDCOM")[2])
TCSETFIELD( "QrySC6","C6_ZPERCOM","N",TamSX3("C6_ZPERCOM")[1],TamSX3("C6_ZPERCOM")[2])
TCSETFIELD( "QrySC6","C6_COMIS1","N",TamSX3("C6_COMIS1")[1],TamSX3("C6_COMIS1")[2])

While !Eof()
	DbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(QrySC6->C6_FILIAL+QrySC6->C6_PRODUTO)
	_nVlrTot := QrySC6->C6_VALOR+Round((QrySC6->C6_VALOR*(SB1->B1_IPI/100)),2)
//	_nVlrST := U_PxValST(SC5->C5_FILIAL,SC5->C5_NUM,QrySC6->C6_ITEM)
	_nVlrST := 0
	AAdd(aAnaSBJ,{QrySC6->C6_PRODUTO,SB1->B1_DESC,QrySC6->C6_QTDVEN,QrySC6->C6_PRCVEN,QrySC6->C6_ZPRTAB,QrySC6->C6_ZPERDES,QrySC6->C6_ZREDCOM,QrySC6->C6_ZPERCOM,SB1->B1_IPI,QrySC6->C6_COMIS1,_nVlrTot,QrySC6->RECNO})
	DbSelectArea("QrySC6")
	DBSkip()
Enddo
DBCloseArea()
IF Len(aAnaSBJ) == 0
	Aadd(aAnaSBJ   ,{Space(15),Space(30), 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000})
	oAnaSBJ:nAT := 1
Endif

IF nPosAT > 0
	oAnaSBJ:nAT := 1
Endif

oAnaSBJ:Refresh()

Return


User Function AprCPVis()

_aAreaZ04 := GetArea()

DbSelectArea("SC5")
DbsetOrder(1)
if DbSeek(TSC5->C5_FILIAL+TSC5->C5_NUM)
	
	A410Visual("SC5",SC5->(RECNO()),2)
	
endif

RestArea(_aAreaZ04)

Return(Nil)



///////////////////////////////////
Static Function OKPROC()

dbSelectArea("SSC5")
SSC5->(dbGoTop())

While SSC5->(!eof())
	
	RecLock("TSC5",.T.)
	TSC5->C5_FILIAL  := SSC5->C5_FILIAL
	TSC5->C5_NUM     := SSC5->C5_NUM
	TSC5->C5_VEND1   := SSC5->C5_VEND1
	TSC5->C5_NOME    := SSC5->C5_NOME
	TSC5->C5_ORDAPRO := SSC5->C5_ORDAPRO
	MsUnlock()
	SSC5->(dbSkip())
End
SSC5->(dbCloseArea())
Return


