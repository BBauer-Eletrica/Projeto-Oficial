#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BBGrpComi � Autor � Gerson Belini      � Data � 16/12/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para validar quem pode fazer manuten��o nos percentu-��
���          � ais de comissoes nos pedidos de vendas.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico BBauer                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BBGrpComi()
	//Local _aAllGrp := AllGroups()
	Local _aAllGrp := UsrRetGrp()
	Local _lRet    := .F.
	Local _cGrpComi := SuperGetMV("CL_GRPCOM",.T.,"")
	For nI := 1 to len(_aAllGrp)
//		if AllTrim(_aAllGrp[ni][1][1]) == AllTrim(_cGrpComi) // Se o grupo for o mesmo para comissoes libera para manuten��o
		if AllTrim(_aAllGrp[ni]) == AllTrim(_cGrpComi) // Se o grupo for o mesmo para comissoes libera para manuten��o
			_lRet := .T.
		endif
	Next
Return(_lRet)
