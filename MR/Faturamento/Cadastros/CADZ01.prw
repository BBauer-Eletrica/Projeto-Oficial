// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : CADZ01
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/09/16 | TOTVS | Developer Studio | Gerado pelo Assistente de C�digo
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a manuten��o de dados armazenados em Z01.

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     7/09/2016
/*/
//------------------------------------------------------------------------------------------
user function CADZ01()
	//--< vari�veis >---------------------------------------------------------------------------
	
	//Indica a permiss�o ou n�o para a opera��o (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO
	
	//trabalho/apoio
	local cAlias
	
	//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "Z01"
	chkFile(cAlias)
	dbSelectArea(cAlias)
	//indices
	dbSetOrder(1)
	//T�tulo a ser utilizado nas opera��es
	private cCadastro := "Cadastro de ..."
	//------------------------------------------------------------------------------------------
	// Array (tambem deve ser aRotina sempre) com as definicoes das opcoes
	//que apareceram disponiveis para o usuario. Segue o padrao:
	//aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;
		//              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;
		//              . . .
	//              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }
	// Onde: <DESCRICAO> - Descricao da opcao do menu
	//       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas
	//                     duplas e pode ser uma das funcoes pre-definidas
	//                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA
	//                     e AXDELETA) ou a chamada de um EXECBLOCK.
	//                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-
	//                     clarar uma variavel chamada CDELFUNC contendo
	//                     uma expressao logica que define se o usuario po-
	//                     dera ou nao excluir o registro, por exemplo:
	//                     cDelFunc := 'ExecBlock("TESTE")'  ou
	//                     cDelFunc := ".T."
	//                     Note que ao se utilizar chamada de EXECBLOCKs,
	//                     as aspas simples devem estar SEMPRE por fora da
	//                     sintaxe.
	//       <TIPO>      - Identifica o tipo de rotina que sera executada.
	//                     Por exemplo, 1 identifica que sera uma rotina de
	//                     pesquisa, portando alteracoes nao podem ser efe-
	//                     tuadas. 3 indica que a rotina e de inclusao, por
	//                     tanto, a rotina sera chamada continuamente ao
	//                     final do processamento, ate o pressionamento de
	//                     <ESC>. Geralmente ao se usar uma chamada de
	//                     EXECBLOCK, usa-se o tipo 4, de alteracao.
	//------------------------------------------------------------------------------------------
	// aRotina padrao. Utilizando a declaracao a seguir, a execucao da
	// MBROWSE sera identica a da AXCADASTRO:
	//
	// cDelFunc  := ".T."
	// aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;
		//                { "Visualizar"   ,"AxVisual" , 0, 2},;
		//                { "Incluir"      ,"AxInclui" , 0, 3},;
		//                { "Alterar"      ,"AxAltera" , 0, 4},;
		//                { "Excluir"      ,"AxDeleta" , 0, 5} }
	//
	//------------------------------------------------------------------------------------------
	
	//--<  monta 'arotina' proprio >------------------------------------------------------------
	
	aRotina := {;
		{ "Pesquisar" , "AxPesqui", 0, 1},;
		{ "Visualizar", "AxVisual", 0, 2},;
		{ "Incluir"   , "AxInclui", 0, 3},;
		{ "Alterar"   , "AxAltera", 0, 4},;
		{ "Exlcuir"   , "AxDeleta", 0, 5};
		}
	//------------------------------------------------------------------------------------------
	// Executa a funcao MBROWSE. Sintaxe:
	//
	// mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)
	// Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera
	//                        exibido. Para seguir o padrao da AXCADASTRO
	//                        use sempre 6,1,22,75 (o que nao impede de
	//                        criar o browse no lugar desejado da tela).
	//                        Obs.: Na versao Windows, o browse sera exibi-
	//                        do sempre na janela ativa. Caso nenhuma este-
	//                        ja ativa no momento, o browse sera exibido na
	//                        janela do proprio SIGAADV.
	//" Alias                - Alias do arquivo a ser ""Browseado""."
	// aCampos              - Array multidimensional com os campos a serem
	//                        exibidos no browse. Se nao informado, os cam-
	//                        pos serao obtidos do dicionario de dados.
	//                        E util para o uso com arquivos de trabalho.
	//                        Segue o padrao:
	//                        aCampos := { {<CAMPO>,<DESCRICAO>},;
		//                                     {<CAMPO>,<DESCRICAO>},;
		//                                     . . .
	//                                     {<CAMPO>,<DESCRICAO>} }
	//                        Como por exemplo:
	//                        aCampos := { {"TRB_DATA","Data  "},;
		//                                     {"TRB_COD" ,"Codigo"} }
	// cCampo               - Nome de um campo (entre aspas) que sera usado
	//"                        como ""flag"". Se o campo estiver vazio, o re-"
	//                        gistro ficara de uma cor no browse, senao fi-
	//                        cara de outra cor.
	//------------------------------------------------------------------------------------------
	//--< procedimentos >-----------------------------------------------------------------------
	dbSelectArea(cAlias)
	mBrowse( 6, 1, 22, 75, cAlias)
	
	
return
//--< fim de arquivo >----------------------------------------------------------------------
