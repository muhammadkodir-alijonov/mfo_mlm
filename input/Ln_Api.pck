result := '� ��������� "������� �����" ���������� : ' | | Vsucc_Loans | | Ut.Ccrlf | |
'�� ������� ��������� : ' | | Verr_Loans;
return result;


 Vmessage := '��������� ������ ( ' || Vcard.Client_Code ||
                ' ) ��������� � ��������� �� �������� ' ||
                  '��� �� �������� �������� ������ �������. (��. "������� � �����")!';
      raise Ex;


Raise_Application_Error(-20000,
                              '�� ���������� ������ � ��������� ID = ' || Iclaim_Id || '!');


Raise_Application_Error(-20000,
                              case Idoc_Type_Code when ' ' then '������� �� ������!' when 'LNCLAIM' then
                              '������ �� �������!' else '�������� �� ������!' end);


Vmessage := '��������� ������ ( ' || Vcard.Client_Code ||
                ' ) ��������� � ��������� �� �������� ' ||
                  '��� �� �������� �������� ������ �������. (��. "������� � �����")!';