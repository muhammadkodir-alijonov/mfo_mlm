create or replace package Ln_Contract is
  -------------------------------------------------------------------------------
  Function Version return varchar2;
  -------------------------------------------------------------------------------
  Function Get_Claim_Rowtype(Iclaim_Id in Ln_Claim.Claim_Id%type) return Ln_Claim%rowtype;
  -------------------------------------------------------------------------------
  Function Get_Claim_Appendix_Rowtype(Iclaim_Id in integer) return Ln_Claim_Appendix%rowtype;
  -------------------------------------------------------------------------------
  Function Get_Nk_Card_Rowtype(Iloan_Id in integer) return Ln_Nik_Card%rowtype;
  -------------------------------------------------------------------------------
  Function Get_Card_Rowtype(Iloan_Id in Ln_Card.Loan_Id%type) return Ln_Card%rowtype;
  -------------------------------------------------------------------------------
  Function Is_Loan_Open_End_Credit(Iloan_Type in Ln_Card.Loan_Type%type) return boolean;
  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *    Изменение кода состояния кредита при проведении документа
  *  @iLoan_ID - уникальный номер договора
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Set_Loan_State(Iloan_Id in Ln_Card.Loan_Id%type);
  -------------------------------------------------------------------------------
  Procedure Backup_Loan_Card(i_Loan_Id number);
  -------------------------------------------------------------------------------
  Procedure Backup_Loan(i_Loan_Id number);
  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Валидация данных заявки перед сохранение
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure On_Save_Claim(i_Event Dw_Event_t);

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Сохранение\изменение договора
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Save_Card(Ievent in Dw_Event_t);

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Утверждение договора
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Admit_Card(Ievent in Dw_Event_t);

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Проверяем, принята ли заявка ГО
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Check_Claim_Admission_By_Head(Ievent in Dw_Event_t);

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     удаление заявки
  *  @iClaim_ID - уникальный номер заявки
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Delete_Claim(Iclaim_Id in Ln_Claim.Claim_Id%type);

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Закрытие ссуды
  *  @iLoan_ID - уникальный номер договора
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Close_Loan
  (
    Iloan_Id         in Ln_Card.Loan_Id%type,
    i_Is_Backup_Loan boolean := true
  );
  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Переводим указанные ЗАКРЫТЫЕ кредиты в состояние Текущая ссуда
  *  @iLoans_Ids - массив уникальных номеров кредитов
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Function Set_Loans_Normal(Iloans_Ids in Array_Number) return varchar2;

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Выравнивание(корректировка) состояний кредитов
  *  @iLoans_Ids - массив уникальных номеров кредитов
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Function Adjust_Loans_States(Iloans_Ids in Array_Number) return varchar2;

  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     Обновление параметров контролей реквизитов договора
  *  @iCheck_New - новые значения
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Update_Card_Params_Checks(Icheck_New in Ln_Check_Card%rowtype);

  -------------------------------------------------------------------------------
  Function Get_Active_Claims_From_Date return varchar2;

  -------------------------------------------------------------------------------
  Function Is_Agricultural_Loans_Used return boolean;

  -------------------------------------------------------------------------------
  Procedure Send_Nk_Request_01
  (
    Iclaim_Id in integer,
    Oreport   out varchar2
  );
  -------------------------------------------------------------------------------
  Procedure Send_Nk_Request_02
  (
    Iclaim_Id in Ln_Claim.Claim_Id%type,
    Oreport   out varchar2
  );
  -------------------------------------------------------------------------------
  Procedure Send_Nk_Request_03_04_05
  (
    Iloan_Id       in Ln_Card.Loan_Id%type,
    Iadd_Edit_Sign in integer,
    Oreport        out varchar2
  );
  -------------------------------------------------------------------------------
  Procedure Send_Rci_Request_03_04_05
  (
    Iloan_Id           in Ln_Card.Loan_Id%type,
    Iadd_Edit_Sign     in integer,
    Isend_Request_Type in number,
    Oreport            out varchar2
  );
  -------------------------------------------------------------------------------
  Function Get_Accessible_Loans_4_Cur_Emp return Array_Number;

  -------------------------------------------------------------------------------
  Function Is_Header_Bank return boolean;
  -------------------------------------------------------------------------------
  Function Is_Limits_Control_Used return boolean;
  -------------------------------------------------------------------------------
  Procedure Request_Crediting_Limits(Iloan_Id in number);
  -------------------------------------------------------------------------------
  Procedure On_Create_Card(Iclaim_Id in Ln_Claim.Claim_Id%type);
  -----------------------------------------------------------------------------
  Function Data_Exists
  (
    Itable in varchar2,
    Iwhere in varchar2
  ) return boolean;
  -------------------------------------------------------------------------------
  Function Get_Loan_State(Iclaim_Id in integer) return integer;
  -------------------------------------------------------------------------------
  Function Get_Loan_Id(Iclaim_Id in integer) return integer;
  -------------------------------------------------------------------------------
  Function Get_Loan_State
  (
    Icard    in Ln_Card%rowtype,
    Ioperday in date := Setup.Get_Operday
  ) return Ln_Card.Condition%type;
  -------------------------------------------------------------------------------
  Function Is_Hamkor_Bank return boolean;
  -------------------------------------------------------------------------------
  Procedure Set_Sign_Ebrd(Iloans_Ids in Array_Number);
  -------------------------------------------------------------------------------
  Procedure Save_Loan_Conversion
  (
    i_Loan_Id         Ln_Card.Loan_Id%type,
    i_Conversion_Yn   varchar2,
    i_Conversion_Date Array_Date,
    i_Amount          Array_Number
  );
  -------------------------------------------------------------------------------
  Procedure Save_Graph_Revenue
  (
    i_Loan_Id       number,
    i_Date_Revenues Array_Date,
    i_Amounts       Array_Number
  );
  -------------------------------------------------------------------------------
  Procedure Nik_Card_Not_Sent(i_Loan_Id Ln_Card.Loan_Id%type);
  -------------------------------------------------------------------------------
  Procedure Check_Card_For_Admission(i_Loan_Id Ln_Card.Loan_Id%type);
  -------------------------------------------------------------------------------
  Procedure Check_Unapproved_Loans(i_Filial_Code varchar2);
  -------------------------------------------------------------------------------
  Procedure Closed_Acc_Before_Close_Loan(i_Loan_Id number);
  -------------------------------------------------------------------------------
  Procedure Edit_Class_Quality_Card
  (
    i_Loan_Id       Ln_Card.Loan_Id%type,
    i_Class_Quality Ln_Card.Class_Quality%type
  );
  -------------------------------------------------------------------------------
end Ln_Contract;
/
create or replace package body Ln_Contract is
----------------------------------------------------
  Function Version return varchar2 is
  begin
    return '08.11.2021';
  end Version;
-------------------------------------------------------------------------------
Function Get_Claim_Rowtype(iClaim_Id in Ln_Claim.Claim_Id%type) return Ln_Claim%rowtype is
  vClaim Ln_Claim%rowtype;
begin
  if iClaim_Id is null then
    Raise_Application_Error(-20000,
                            'Не передан уникальный номер кредитной заявки!');
  end if;
  --
  select t.*
    into vClaim
    from Ln_Claim t
   where t.Claim_Id = iClaim_Id;
  return vClaim;
exception
  when No_Data_Found then
    Raise_Application_Error(-20000,
                            'Не найдена кредитная заявка с указанным уникальным номером Claim Id = ' ||
                            iClaim_Id || '!');
end Get_Claim_Rowtype;
-------------------------------------------------------------------------------
Function Get_Claim_Appendix_Rowtype(iClaim_Id in integer) return Ln_Claim_Appendix%rowtype is
  vClaim_Appendix Ln_Claim_Appendix%rowtype;
begin
  if iClaim_Id is null then
    Raise_Application_Error(-20000,
                            'Не передан уникальный номер кредитной заявки!');
  end if;
  --
  select t.*
    into vClaim_Appendix
    from Ln_Claim_Appendix t
   where t.Claim_Id = iClaim_Id;
  return vClaim_Appendix;
exception
  when No_Data_Found then
    return null;
end Get_Claim_Appendix_Rowtype;
-------------------------------------------------------------------------------
Function Get_Card_Rowtype(Iloan_Id in Ln_Card.Loan_Id%type) return Ln_Card%rowtype is
  Vcard Ln_Card%rowtype;
begin
  if Iloan_Id is null then
    Raise_Application_Error(-20000,
                            'Не передан уникальный номер кредитного договора!');
  end if;
  --
  select t.*
    into Vcard
    from Ln_Card t
   where t.Loan_Id = Iloan_Id;
  return Vcard;
exception
  when No_Data_Found then
    Raise_Application_Error(-20000,
                            'Не найден кредитный договор с указанным уникальным номером Loan Id = ' ||
                            Iloan_Id || '!');
end Get_Card_Rowtype;
-------------------------------------------------------------------------------
Function Get_Nk_Card_Rowtype(Iloan_Id in integer) return Ln_Nik_Card%rowtype is
  result Ln_Nik_Card%rowtype;
begin
  if Iloan_Id is null then
    Raise_Application_Error(-20000,
                            'Не передан уникальный номер кредитного договора!');
  end if;
  --
  select t.*
    into result
    from Ln_Nik_Card t
   where t.Loan_Id = Iloan_Id;
  return result;
exception
  when No_Data_Found then
    Raise_Application_Error(-20000,
                            'Не найден кредитный договор из Ln_Nik_Card с указанным уникальным номером Loan Id = ' ||
                            Iloan_Id || '!');
end Get_Nk_Card_Rowtype;
-------------------------------------------------------------------------------
Function Get_Loan_Object(Iloan_Id in integer) return Ln_Cache.Contrat_Loan_t is
  Vloan Ln_Cache.Contrat_Loan_t;
begin
  Vloan.Card := Get_Card_Rowtype(Iloan_Id);
  select t.Credit_Source_Code,
         t.Foreign_Organization_Code,
         t.Financing_Currency_Code,
         t.Financing_Amount,
         t.Loan_Line_Purpose,
         t.Under_Guarantee_Ruz
    bulk collect
    into Vloan.Credit_Source,
         Vloan.Foreign_Organization,
         Vloan.Financing_Currency,
         Vloan.Financing_Amount,
         Vloan.Loan_Line_Purpose,
         Vloan.Under_Guarantee_Ruz
    from Ln_Credit_Sources t
   where t.Loan_Id = Iloan_Id;
  return Vloan;
end Get_Loan_Object;
-------------------------------------------------------------------------------
Procedure Log_Doc_Modification
(
  Idoc_Id         in number,
  Idoc_Type_Code  in varchar2,
  Istate_Code     in number,
  Inew_State_Code in number,
  Idescription    in varchar2
) is
  pragma autonomous_transaction;
begin
  insert into Ln_Doc_State_Changes_Protocol
    (Doc_Id,
     Doc_Type_Code,
     Filial_Code,
     State_Code,
     New_State_Code,
     Date_Modify,
     Emp_Code,
     Description)
  values
    (Idoc_Id,
     Idoc_Type_Code,
     Setup.Filial_Code,
     Istate_Code,
     Inew_State_Code,
     sysdate,
     Setup.Employee_Code,
     Idescription);
  commit;
end Log_Doc_Modification;
-------------------------------------------------------------------------------
Procedure Delete_Guarantee(Iguar_Id in Ln_Loan_Guar.Guar_Id%type) is
begin
  delete from Ln_Loan_Guar_Desc_a
   where Guar_Id = Iguar_Id;
  delete from Ln_Loan_Guar_Desc_Dp
   where Guar_Id = Iguar_Id;
  delete from Ln_Loan_Guar_Desc_g
   where Guar_Id = Iguar_Id;
  delete from Ln_Loan_Guar_Desc_m
   where Guar_Id = Iguar_Id;
  delete from Ln_Loan_Guar_Desc_Sp
   where Guar_Id = Iguar_Id;
  delete from Ln_Loan_Guar
   where Guar_Id = Iguar_Id;
end Delete_Guarantee;
-------------------------------------------------------------------------------
Function Is_Loan_Open_End_Credit(Iloan_Type in Ln_Card.Loan_Type%type) return boolean is
begin
  return Iloan_Type > 50;
end Is_Loan_Open_End_Credit;
-------------------------------------------------------------------------------
Function Is_Header_Bank return boolean is
begin
  return Setup.Get_Headermfo = Setup.Get_Filial_Code;
end;
-------------------------------------------------------------------------------
Function Is_Agricultural_Loans_Used return boolean is
begin
  return Nvl((Ln_Api.Get_Sys_Param('N', 'AGRO_LOAN_USED') = 'Y'), false);
end;
-------------------------------------------------------------------------------
Function Get_Active_Claims_From_Date return varchar2 is
  result varchar2(10);
begin
  select to_char(Setup.Operday - Ln_Const.Claims_Storage_Time_In_Days, 'dd.mm.yyyy')
    into result
    from Dual;
  return result;
end Get_Active_Claims_From_Date;
-------------------------------------------------------------------------------
Function Fetch_Report_From_Refcursor(Ireport in sys_refcursor) return varchar2 is
  Vreport_Snippet varchar2(3000);
  result          varchar2(32767);
begin
  loop
    fetch Ireport
      into Vreport_Snippet;
    exit when Ireport%notfound;
    result := result || Ut.Ccrlf || Vreport_Snippet;
  end loop;
  return result;
end Fetch_Report_From_Refcursor;
-------------------------------------------------------------------
Procedure Backup_Loan(Iloan in Ln_Cache.Contrat_Loan_t) is
  v_OD Date := Setup.Bankday;
  --v_Emp_Code    number := Setup.Employee_Code;
  --v_Modified_On date := sysdate;
begin
  insert into Ln_Card_His
    (Loan_Id,
     Filial_Code,
     Local_Code,
     Condition,
     Card_Type,
     Loan_Type,
     Client_Code,
     Claim_Number,
     Loan_Number,
     Loan_Line_Num,
     Committee_Number,
     Date_Committee,
     Contract_Code,
     Contract_Date,
     Contract_Desc,
     Agr_Num_Notarial,
     Agr_Date_Notarial,
     Doc_Notarial_Num,
     Doc_Notarial_Date,
     Doc_Gover_Num,
     Doc_Gover_Date,
     Open_Date,
     Close_Date,
     Currency,
     Summ_Loan,
     Days_In_Year,
     Grace_Period,
     Fc_Summ,
     Fc_Desc,
     Form_Delivery,
     Form_Redemption,
     Term_Loan_Type,
     Eco_Sec,
     Purpose_Loan,
     Object_Loan,
     Guar_Class,
     Source_Cred,
     Class_Cred,
     Class_Quality,
     Motive_Revising,
     Date_Revising,
     Date_Modify,
     Err_Message,
     Emp_Code,
     Sign_Delivery,
     Manager_Name,
     Sign_Ebrd,
     Gov_Num,
     Gov_Date,
     Locking,
     Day_Redemp,
     Loanmonth,
     Percent_Rate,
     Red_Debt_Month,
     Red_Perc_Month,
     Summinitial,
     Founders,
     Urgency_Type,
     Claim_Id,
     Client_Id,
     Product_Id,
     Oked,
     Client_Name,
     --Client_Uid,
     Created_On,
     Created_By,
     --Branch_Id,
     Lending_Type,
     Purpose_Lending,
     Cross_Loan_Id,
     Oper_Day)
  values 
    (iLoan.Card.Loan_Id,
     iLoan.Card.Filial_Code,
     iLoan.Card.Local_Code,
     iLoan.Card.Condition,
     iLoan.Card.Card_Type,
     iLoan.Card.Loan_Type,
     iLoan.Card.Client_Code,
     iLoan.Card.Claim_Number,
     iLoan.Card.Loan_Number,
     iLoan.Card.Loan_Line_Num,
     iLoan.Card.Committee_Number,
     iLoan.Card.Date_Committee,
     iLoan.Card.Contract_Code,
     iLoan.Card.Contract_Date,
     iLoan.Card.Contract_Desc,
     iLoan.Card.Agr_Num_Notarial,
     iLoan.Card.Agr_Date_Notarial,
     iLoan.Card.Doc_Notarial_Num,
     iLoan.Card.Doc_Notarial_Date,
     iLoan.Card.Doc_Gover_Num,
     iLoan.Card.Doc_Gover_Date,
     iLoan.Card.Open_Date,
     iLoan.Card.Close_Date,
     iLoan.Card.Currency,
     iLoan.Card.Summ_Loan,
     iLoan.Card.Days_In_Year,
     iLoan.Card.Grace_Period,
     iLoan.Card.Fc_Summ,
     iLoan.Card.Fc_Desc,
     iLoan.Card.Form_Delivery,
     iLoan.Card.Form_Redemption,
     iLoan.Card.Term_Loan_Type,
     iLoan.Card.Eco_Sec,
     iLoan.Card.Purpose_Loan,
     iLoan.Card.Object_Loan,
     iLoan.Card.Guar_Class,
     iLoan.Card.Source_Cred,
     iLoan.Card.Class_Cred,
     iLoan.Card.Class_Quality,
     iLoan.Card.Motive_Revising,
     iLoan.Card.Date_Revising,
     iLoan.Card.Date_Modify,
     iLoan.Card.Err_Message,
     iLoan.Card.Emp_Code,
     iLoan.Card.Sign_Delivery,
     iLoan.Card.Manager_Name,
     iLoan.Card.Sign_Ebrd,
     iLoan.Card.Gov_Num,
     iLoan.Card.Gov_Date,
     iLoan.Card.Locking,
     iLoan.Card.Day_Redemp,
     iLoan.Card.Loanmonth,
     iLoan.Card.Percent_Rate,
     iLoan.Card.Red_Debt_Month,
     iLoan.Card.Red_Perc_Month,
     iLoan.Card.Summinitial,
     iLoan.Card.Founders,
     iLoan.Card.Urgency_Type,
     iLoan.Card.Claim_Id,
     iLoan.Card.Client_Id,
     iLoan.Card.Product_Id,
     iLoan.Card.Oked,
     iLoan.Card.Client_Name,
     --iLoan.Card.Client_Uid,
     iLoan.Card.Created_On,
     iLoan.Card.Created_By,
     --iLoan.Card.Branch_Id,
     iLoan.Card.Lending_Type,
     iLoan.Card.Purpose_Lending,
     iLoan.Card.Cross_Loan_Id,
     v_OD);
  --
  insert into Ln_Card_Additional_His
  values (Iloan.Card_Additional.loan_id, 
          Iloan.Card_Additional.claim_guid,
          Iloan.Card_Additional.contract_guid,
          Iloan.Card_Additional.borrower_link,
          Iloan.Card_Additional.agreement_number,
          Iloan.Card_Additional.agreement_date,
          Iloan.Card_Additional.director_id,
          Iloan.Card_Additional.amount_uzs,
          Iloan.Card_Additional.amount_usd,
          Iloan.Card_Additional.amount_eur,
          Iloan.Card_Additional.issue_mode,
          Iloan.Card_Additional.factoring_type,
          Iloan.Card_Additional.created_on,
          Iloan.Card_Additional.created_by,
          Iloan.Card_Additional.date_modify,
          Iloan.Card_Additional.modified_by,
          Iloan.Card_Additional.property_type,
          Iloan.Card_Additional.property_cost,
          Iloan.Card_Additional.property_condition,
          'U');
  --
  for i in 1 .. Iloan.Credit_Source.Count
  loop
    insert into Ln_Credit_Sources_His
      (Loan_Id,
       Credit_Source_Code,
       Lending_Source_Code,
       Foreign_Organization_Code,
       Financing_Currency_Code,
       Financing_Amount,
       Loan_Line_Purpose,
       Date_Modify,
       Under_Guarantee_Ruz,
       --branch_id,
       local_code,
       action,
       oper_day)
    values
      (Iloan.Card.Loan_Id,
       Iloan.Credit_Source(i),
       Iloan.Lending_Source_Code(i),
       Iloan.Foreign_Organization(i),
       Iloan.Financing_Currency(i),
       Iloan.Financing_Amount(i),
       Iloan.Loan_Line_Purpose(i),
       Iloan.Card.Date_Modify,
       Iloan.Under_Guarantee_Ruz(i),
       --Iloan.Card.branch_id,
       Iloan.Card.local_code,
       'U',
       Setup.Bankday);
  end loop;
  --
 /*  insert into Ln_Loan_Report_Types_His
    select *
      from Ln_Loan_Report_Types Rt
     where Rt.Loan_Id = Iloan.Card.Loan_Id;
  --
  insert into Ln_Loan_Params_His
    (Loan_Id, Object_Id, Param_Id, value, Created_On, Modified_On, Modified_By)
    select Loan_Id, Object_Id, Param_Id, value, Created_On, v_Modified_On, v_Emp_Code
      from Ln_Loan_Params
     where Loan_Id = Iloan.Card.Loan_Id
       and exists (select 'X'
              from Ln_s_Loan_Params p
             where p.Object_Code = 'CARD'
               and p.Id = Param_Id
               and p.Condition = 'A');*/
end Backup_Loan;
  -------------------------------------------------------------------------------
  Procedure Backup_Loan_Card(i_Loan_Id number) is
    v_OD date := Setup.Bankday;
  begin
    insert into Ln_Card_His
      (Loan_Id,
       Filial_Code,
       --Branch_Id,
       Local_Code,
       Condition,
       Card_Type,
       Loan_Type,
       Client_Code,
       Claim_Number,
       Loan_Number,
       Loan_Line_Num,
       Committee_Number,
       Date_Committee,
       Contract_Code,
       Contract_Date,
       Contract_Desc,
       Agr_Num_Notarial,
       Agr_Date_Notarial,
       Doc_Notarial_Num,
       Doc_Notarial_Date,
       Doc_Gover_Num,
       Doc_Gover_Date,
       Open_Date,
       Close_Date,
       Currency,
       Summ_Loan,
       Days_In_Year,
       Grace_Period,
       Fc_Summ,
       Fc_Desc,
       Form_Delivery,
       Form_Redemption,
       Term_Loan_Type,
       Eco_Sec,
       Purpose_Loan,
       Object_Loan,
       Guar_Class,
       Source_Cred,
       Class_Cred,
       Class_Quality,
       Motive_Revising,
       Date_Revising,
       Date_Modify,
       Err_Message,
       Emp_Code,
       Sign_Delivery,
       Manager_Name,
       Sign_Ebrd,
       Gov_Num,
       Gov_Date,
       Locking,
       Day_Redemp,
       Loanmonth,
       Percent_Rate,
       Red_Debt_Month,
       Red_Perc_Month,
       Summinitial,
       Founders,
       Urgency_Type,
       Claim_Id,
       Client_Id,
       Product_Id,
       Oked,
       Client_Name,
       --Client_Uid,
       Created_On,
       Created_By,
       Lending_Type,
       Purpose_Lending,
       Cross_Loan_Id,
       Oper_Day)
      select Loan_Id,
             Filial_Code,
             --Branch_Id,
             Local_Code,
             Condition,
             Card_Type,
             Loan_Type,
             Client_Code,
             Claim_Number,
             Loan_Number,
             Loan_Line_Num,
             Committee_Number,
             Date_Committee,
             Contract_Code,
             Contract_Date,
             Contract_Desc,
             Agr_Num_Notarial,
             Agr_Date_Notarial,
             Doc_Notarial_Num,
             Doc_Notarial_Date,
             Doc_Gover_Num,
             Doc_Gover_Date,
             Open_Date,
             Close_Date,
             Currency,
             Summ_Loan,
             Days_In_Year,
             Grace_Period,
             Fc_Summ,
             Fc_Desc,
             Form_Delivery,
             Form_Redemption,
             Term_Loan_Type,
             Eco_Sec,
             Purpose_Loan,
             Object_Loan,
             Guar_Class,
             Source_Cred,
             Class_Cred,
             Class_Quality,
             Motive_Revising,
             Date_Revising,
             Date_Modify,
             Err_Message,
             Emp_Code,
             Sign_Delivery,
             Manager_Name,
             Sign_Ebrd,
             Gov_Num,
             Gov_Date,
             Locking,
             Day_Redemp,
             Loanmonth,
             Percent_Rate,
             Red_Debt_Month,
             Red_Perc_Month,
             Summinitial,
             Founders,
             Urgency_Type,
             Claim_Id,
             Client_Id,
             Product_Id,
             Oked,
             Client_Name,
             --Client_Uid,
             Created_On,
             Created_By,
             Lending_Type,
             Purpose_Lending,
             Cross_Loan_Id,
             v_OD
        from Ln_Card
       where Loan_Id = i_Loan_Id;
  end Backup_Loan_Card;
  -------------------------------------------------------------------------------
  Procedure Backup_Loan(i_Loan_Id number) is
    --v_date date;
	  --v_Emp_Code    number := Setup.Employee_Code;
    --v_Modified_On date := sysdate;							  
  begin
    /*select t.date_modify
      into v_date
      from Ln_Card t
     where Loan_Id = i_Loan_Id;
    delete Ln_Card_His
     where Loan_Id = i_Loan_Id
       and date_modify = v_date;*/
    Backup_Loan_Card(i_Loan_Id);
    --     
    /*select t.date_modify
      into v_date
      from Ln_Card_Additional t
     where Loan_Id = i_Loan_Id;
     delete Ln_Card_Additional_His
     where Loan_Id = i_Loan_Id
       and date_modify = v_date;*/
  insert into Ln_Card_Additional_His
    (Loan_Id,
           Claim_Guid,
           Contract_Guid,
           Borrower_Link,
           Agreement_Number,
           Agreement_Date,
           Director_Id,
           Amount_Uzs,
           Amount_Usd,
           Amount_Eur,
           Issue_Mode,
           Factoring_Type,
           Created_On,
           Created_By,
           Date_Modify,
           Modified_By)
    select Loan_Id,
           Claim_Guid,
           Contract_Guid,
           Borrower_Link,
           Agreement_Number,
           Agreement_Date,
           Director_Id,
           Amount_Uzs,
           Amount_Usd,
           Amount_Eur,
           Issue_Mode,
           Factoring_Type,
           Created_On,
           Created_By,
           Date_Modify,
           Modified_By
      from Ln_Card_Additional
     where Loan_Id = i_Loan_Id;
    --
    /*select max(t.date_modify)
      into v_date
      from Ln_Credit_Sources t
     where Loan_Id = i_Loan_Id;
     
    delete Ln_Credit_Sources_His t
     where Loan_Id = i_Loan_Id
       and date_modify = v_date;*/
       
    /*insert into Ln_Credit_Sources_His
      select Loan_Id,
             Credit_Source_Code,
             Foreign_Organization_Code,
             Financing_Currency_Code,
             Financing_Amount,
             Loan_Line_Purpose,
             Date_Modify,
             Under_Guarantee_Ruz,
             Lending_Source_Code
        from Ln_Credit_Sources
       where Loan_Id = i_Loan_Id;*/
    --
    /*select max(t.date_modify)
      into v_date
      from Ln_Loan_Report_Types t
     where Loan_Id = i_Loan_Id;
     
    delete Ln_Loan_Report_Types_His
     where Loan_Id = i_Loan_Id
       and date_modify = v_date;*/
    --   
    /*insert into Ln_Loan_Report_Types_His
      select Loan_Id, Report_Type_Id, Date_Modify
        from Ln_Loan_Report_Types
       where Loan_Id = i_Loan_Id;*/
    --
    /*select max(t.created_on)
      into v_date
      from Ln_Loan_Params t
     where Loan_Id = i_Loan_Id
       and exists (select 'X'
                     from Ln_s_Loan_Params p
                    where p.Object_Code = 'CARD'
                      and p.Id = Param_Id
                      and p.Condition = 'A');
     
    delete Ln_Loan_Params_His
     where Loan_Id = i_Loan_Id
       and exists (select 'X'
                     from Ln_s_Loan_Params p
                    where p.Object_Code = 'CARD'
                      and p.Id = Param_Id
                      and p.Condition = 'A')
       and created_on = v_date;*/
       
    /*insert into Ln_Loan_Params_His
           (Loan_Id, Object_Id, Param_Id, value, Created_On, Modified_On, Modified_By)
     select Loan_Id, Object_Id, Param_Id, value, Created_On, v_Modified_On, v_Emp_Code
       from Ln_Loan_Params
      where Loan_Id = i_Loan_Id
        and exists (select 'X'
                from Ln_s_Loan_Params p
               where p.Object_Code = 'CARD'
                 and p.Id = Param_Id
                 and p.Condition = 'A');*/
  end Backup_Loan;
  -------------------------------------------------------------------------------
  Procedure Send_Nk_Request_01
  (
    iClaim_Id in integer,
    Oreport   out varchar2
  ) is
    --type Refcursor is ref cursor;
    --Vreport    Refcursor;
    --vClaim     Ln_Claim%rowtype;
    Vblankuesd boolean := Ln_Util.Bank_Has_Blank_Used;
  begin
    if Ln_Setting.Get_Sys_Param('SEND_CLAIM_AUTOMATICALLY_ON_APPLICATION_APPROVAL') = 'Y' then
      $if rci_const.c_Has_Rci = true $then
        ln_rci_api_out.Send_Claim(iClaim_Id, Oreport,'LN');
      $else
        null;
      $end
    end if;
    if Ln_Setting.Get_Sys_Param('SEND_01_AUTOMATICALLY_ON_APPLICATION_APPROVAL') = 'N' and
       not Vblankuesd then
      return;
    end if;
  
    /*vClaim := Get_Claim_Rowtype(iClaim_Id);
  
    if (vClaim.Status = Ln_Const.Claim_Accepted_By_Filial and not Vblankuesd) or
       (vClaim.Status = Ln_Const.Claim_Accepted_By_Head and not Vblankuesd) or Vblankuesd then
      Nk_Api.Prepare_Send(Ireq_Num   => '01',
                          Itable_Pk  => vClaim.Nik_Id || '~' || vClaim.Claim_Num || '~' ||
                                        vClaim.Filial_Code || '~#',
                          Icol_Count => 3,
                          Orep       => Vreport,
                          Isend_Sign => 0);
    
    Oreport := Oreport || Chr(10) || Fetch_Report_From_Refcursor(Vreport);
    
      if Ln_Setting.Get_Sys_Param('NIKI_SEND_AUTOMATICALLY', Setup.Get_Filial_Code) = 'N' then
        return;
      end if;
      Oreport := Oreport || Ut.Ccrlf || Nk_Api.File_Create_Request(vClaim.Filial_Code, '01');
    end if;*/
  end Send_Nk_Request_01;
-------------------------------------------------------------------------------
  Procedure Send_Nk_Request_02
  (
    iClaim_Id in Ln_Claim.Claim_Id%type,
    Oreport   out varchar2
  ) is
    --type Refcursor is ref cursor;
    --Vreport Refcursor;
    vClaim  Ln_Claim%rowtype;
  
    Function Get_Claim_Rowtype(iClaim_Id in Ln_Claim.Claim_Id%type) return Ln_Claim%rowtype is
      vClaim Ln_Claim%rowtype;
    begin
      if iClaim_Id is null then
        Raise_Application_Error(-20000,
                                'Не передан уникальный номер кредитной заявки!');
      end if;
      --
      select t.*
        into vClaim
        from Ln_Claim t
       where t.Claim_Id = iClaim_Id;
      return vClaim;
    exception
      when No_Data_Found then
        Raise_Application_Error(-20000,
                                'Не найдена кредитная заявка с указанным уникальным номером Claim Id = ' ||
                                iClaim_Id || '!');
    end Get_Claim_Rowtype;
  
  begin
    vClaim := Get_Claim_Rowtype(iClaim_Id);
    if Ln_Setting.Get_Sys_Param('SEND_CLAIM_REJECT_AUTOMATICALLY_ON_APPLICATION') = 'Y' then
      $if rci_const.c_Has_Rci = true $then
        ln_rci_api_out.Send_Claim_Reject(iClaim_Id, Oreport,'LN');
      $else
        null;
      $end
    end if;
  
    /*if Ln_Setting.Get_Sys_Param('SEND_02_AUTOMATICALLY_ON_APPLICATION_REFUSAL') = 'N' then
      return;
    end if;
  
    if vClaim.Status = Ln_Const.Claim_Rejected then
      Nk_Api.Prepare_Send(Ireq_Num   => '02',
                          Itable_Pk  => vClaim.Nik_Id || '~' || vClaim.Claim_Num || '~' ||
                                        vClaim.Filial_Code || '~#',
                          Icol_Count => 3,
                          Orep       => Vreport,
                          Isend_Sign => 0);
    
    Oreport := Oreport || Chr(10) || Fetch_Report_From_Refcursor(Vreport);
    
      if Ln_Setting.Get_Sys_Param('NIKI_SEND_AUTOMATICALLY', Setup.Get_Filial_Code) = 'N' then
        return;
      end if;
      Oreport := Oreport || Ut.Ccrlf || Nk_Api.File_Create_Request(vClaim.Filial_Code, '02');
    end if;*/
  end Send_Nk_Request_02;
-------------------------------------------------------------------------------
Procedure Send_Rci_Request_03_04_05
  (
    Iloan_Id       in Ln_Card.Loan_Id%type,
    Iadd_Edit_Sign in integer,
    iSend_request_type in number,
    Oreport        out varchar2
  ) is
    --Vcard        Ln_Card%rowtype;
  
    --type Refcursor is ref cursor;
    --Vreport Refcursor;
  begin
    --
    if Iadd_Edit_Sign is null then 
      null; --Helped with the compiler
    end if;
    --Vcard := Get_Card_Rowtype(Iloan_Id);
  
    /*if Vcard.Condition = Ln_Const.c_Loan_Not_Approved then
      Oreport:='Невозможно отправить договор в ГРКИ в состоянии Неутвержденная ссуда';
      return;
    end if;*/
  
    if Ln_Setting.Get_Sys_Param('SEND_CONTRACT_AUTOMATICALLY_ON_LOAN_APPROVAL') = 'Y' then
      $if rci_const.c_Has_Rci = true $then
    if Isend_Request_Type = 3 then
        ln_rci_api_out.Send_Card(Iloan_Id, Oreport, 'LN');
    elsif Isend_Request_Type = 4 then
          ln_rci_api_out.Send_Guar(Iloan_Id, Oreport,'LN'); 
    elsif Isend_Request_Type = 5 then
          ln_rci_api_out.Send_Schedule(Iloan_Id, Oreport,'LN'); 
    else
      null;
        end if;
      $else
        null;
      $end
    end if;
  end Send_Rci_Request_03_04_05;
-------------------------------------------------------------------------------
  Procedure Send_Nk_Request_03_04_05
  (
    Iloan_Id       in Ln_Card.Loan_Id%type,
    Iadd_Edit_Sign in integer,
    Oreport        out varchar2
  ) is
    Vcard        Ln_Card%rowtype;
    --Vrequest_Num varchar2(2);

    --type Refcursor is ref cursor;
    --Vreport Refcursor;
  begin
    Vcard := Get_Card_Rowtype(Iloan_Id);
    --
    if Iadd_Edit_Sign is null then 
      null; --Helped with the compiler
    end if;
    if Vcard.Condition = Ln_Const.c_Loan_Not_Approved then
      return;
    end if;

    /*Vrequest_Num := case Vcard.Card_Type
                      when Ln_Const.Ln_Credit then
                       '03'
                      when Ln_Const.Ln_Leasing then
                       '04'
                      else
                       '05'
                    end;*/
    if Ln_Setting.Get_Sys_Param('SEND_CONTRACT_AUTOMATICALLY_ON_LOAN_APPROVAL') = 'Y' then
      $if rci_const.c_Has_Rci = true $then
        ln_rci_api_out.Send_Card(Iloan_Id, Oreport);
      $else
        null;
      $end
    end if;
    /*if Ln_Setting.Get_Sys_Param('SEND_03_04_05_AUTOMATICALLY_ON_LOAN_APPROVAL') = 'N' then
      return;
    end if;
  
    Nk_Api.Prepare_Send(Ireq_Num   => Vrequest_Num,
                        Itable_Pk  => Iloan_Id || '#',
                        Icol_Count => 1,
                        Orep       => Vreport,
                        Isend_Sign => 0 \*iAdd_Edit_Sign*\);
  
  Oreport := Oreport || Chr(10) || Fetch_Report_From_Refcursor(Vreport);
  
    if Ln_Setting.Get_Sys_Param('NIKI_SEND_AUTOMATICALLY', Setup.Get_Filial_Code) = 'N' then
      return;
    end if;
  
    Oreport := Oreport || Ut.Ccrlf || Nk_Api.File_Create_Request(Vcard.Filial_Code, Vrequest_Num);*/
  
  end Send_Nk_Request_03_04_05;
-----------------------------------------------------------------------------
Function Data_Exists
(
  Itable in varchar2,
  Iwhere in varchar2
) return boolean is
    vSql   varchar2(3000);
    vCount integer;
  begin
    vSql := 'select count(*) from ' || iTable || ' where rownum = 1 and ' || iWhere;
  execute immediate Vsql
    into Vcount;

    return vCount > 0;
  end Data_Exists;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Возвращает определенный тип процентной ставки
*  @iLoan_ID         -  уникальный номер договора
*  @iPerc_Code_Desc  -  код типа процентной ставки
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
Function Get_Percent_Rate
(
  Iloan_Id        in Ln_Card.Loan_Id%type,
  Iperc_Code_Desc in Ln_Percent_Rate.Perc_Code_Desc%type
) return Ln_Percent_Rate%rowtype is
    vPerc_Rate_Name ln_s_perc_code_desc.name%type;
    vPercent_Rate   ln_percent_rate%rowtype;
  begin
    if Not Data_Exists('Ln_s_Perc_Code_Desc', 'Code=''' || iPerc_Code_Desc || '''') then
    Raise_Application_Error(-20000,
                            'Передан несуществующий код вида процентной ставки - ' ||
                            Iperc_Code_Desc);
    end if;

    select --+ index_desc (t LN_PERCENT_RATE_PK )
           t.* into vPercent_Rate
      from LN_PERCENT_RATE t
     where t.LOAN_ID = iLoan_ID
       and t.PERC_CODE_DESC = iPerc_Code_Desc
     and Rownum = 1;
    return vPercent_Rate;
  exception
    when NO_DATA_FOUND then
    select t.Name
      into Vperc_Rate_Name
        from Ln_s_Perc_Code_Desc t
     where t.Code = Iperc_Code_Desc;
    Raise_Application_Error(-20000,
                            'Для текущего договора необходимо завести процентную ставку "' ||
                            Vperc_Rate_Name || ' - ' || Iperc_Code_Desc || '" !');
  end Get_Percent_Rate;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка данных процентной ставки
*  @iPercent_Rate  -  процентная ставка
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  function Check_Percent_Rate ( iPercent_Rate in Ln_Percent_Rate%rowtype ) return varchar2
  is
    v_Error_Text varchar2(500);
  begin
    if iPercent_Rate.PERC_CODE_DESC is NULL then
      v_Error_Text := 'Не указан ВИД ПРОЦЕНТНОЙ СТАВКИ!';

    elsif NOT Data_Exists('Ln_S_Perc_Code_Desc', 'CODE = ''' || iPercent_Rate.PERC_CODE_DESC || '''') then
      v_Error_Text := 'Введенный тип ПРОЦЕНТНОЙ СТАВКИ ( ' || iPercent_Rate.PERC_CODE_DESC || ' ) в справочнике не найден!';

    elsif iPercent_Rate.PERC_TYPE is NULL then
      v_Error_Text := 'Не указан ТИП ПРОЦЕНТНОЙ СТАВКИ ЗА ПРОСРОЧКУ!';

    elsif NOT Data_Exists('Ln_S_Perc_Rate_Type', 'PER_RATE_ID = ''' || iPercent_Rate.PERC_TYPE || '''') then
      v_Error_Text := 'Введенный тип ПРОЦЕНТНОЙ СТАВКИ ЗА ПРОСРОЧКУ ( ' || iPercent_Rate.PERC_TYPE || ' ) в справочнике не найден!';

    elsif iPercent_Rate.FIRST_DATE is NULL then
      v_Error_Text := 'Не указана ДАТА НАЧАЛА ДЕЙСТВИЯ ПРОЦЕНТНОЙ СТАВКИ!';

    elsif iPercent_Rate.PERC_RATE is NULL then
      v_Error_Text := 'Не указана ПРОЦЕНТНАЯ СТАВКА!';

    elsif iPercent_Rate.PERC_RATE < 0 then
      v_Error_Text := 'ПРОЦЕНТНАЯ СТАВКА не может быть меньше нуля!';
    end if;

    return v_Error_Text;
  end Check_Percent_Rate;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка всех процентных ставок указанного договора
*  @iCard      - договора
*  @oError_Log - текст ошибки
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  function Is_Percent_Rates_Valid ( iCard       in  LN_CARD%rowtype
                                  , oError_Log  out varchar2
                                  ) return boolean
  is
    vPerc_Rate         ln_percent_rate%rowtype;
    --vPercent_Rate_Name ln_s_perc_code_desc.NAME%type;
    vParam_Perc_Codes  array_varchar2;
    vPerc_Codes  array_varchar2;
    vPerc_Rates  array_number;
    vPerc_Types  array_varchar2;
  begin
    --productni uzini nastroykasi bor
    if Ln_Init.Is_Product then
      select Perc_Code_Desc, Perc_Rate, Perc_Type bulk collect
        into vPerc_Codes, vPerc_Rates, vPerc_Types
        from Ln_Percent_Rate
       where Loan_Id = iCard.Loan_Id;
      Ln_Product.Check_Blank_Perc_Rates(i_Perc_Codes => vPerc_Codes,
                                        i_Perc_Rates => vPerc_Rates,
                                        i_Perc_Types => vPerc_Types,
                                        o_Err_Msg    => oError_Log);
      return oError_Log is null; --return true;
    end if;
    --faktoringlarda % bolmaydi...
    if iCard.CARD_TYPE = ln_const.Ln_Factoring then
      return true;
    end if;
    --nastroykada kiritishili lozim % stavkalarni tekshirish - BE_SURE_FIX_PERCENT_RATE_FOR_APPROVE_LOAN
    vParam_Perc_Codes := ln_setting.Get_Sys_Param_Value_List('BE_SURE_FIX_PERCENT_RATE_FOR_APPROVE_LOAN',Setup.Get_HeaderMFO);
    for i in 1..vParam_Perc_Codes.count loop
      if iCard.LOAN_TYPE not between '50' and '56' -- открытая кредитная линия
         and vParam_Perc_Codes(i) = 'UNU' then
        continue;
      end if;
      vPerc_Rate := Get_Percent_Rate( iCard.LOAN_ID, vParam_Perc_Codes(i) );
      oError_Log := Check_Percent_Rate( vPerc_Rate );
      if oError_Log is NOT NULL then
        oError_Log := 'Ошибка(и) при проверке '||Ln_Service.Get_Perc_Code_Desc_Name(vParam_Perc_Codes(i))||
                   ': ' || Ut.cCRLF  || oError_Log;
        return false;
      end if;
    end loop;
    --
    return true;
  end Is_Percent_Rates_Valid;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка обеспечения
*  @iGuarantee  -  текущее обеспечение
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  function Check_Guarantee( i_GUAR_TYPE LN_LOAN_GUAR.Guar_Type%type, i_SUM_GUAR LN_LOAN_GUAR.Sum_Guar%type, i_CURRENCY LN_LOAN_GUAR.Currency%type) return varchar2
  is
    v_Error_Text varchar2(3000);
  begin

    if i_GUAR_TYPE is NULL then
      v_Error_Text := 'Не указан тип обеспечения кредита!';

    elsif NOT Data_Exists('Ln_v_Credit_Guarant', 'CODE = ''' || i_GUAR_TYPE || '''') then
      v_Error_Text := 'Введенный ТИП ОБЕСПЕЧЕНИЯ ( ' || i_GUAR_TYPE || ' ) в справочнике не найден!';

    elsif i_SUM_GUAR is NULL then
      v_Error_Text := 'Не указана сумма обеспечения!';

    elsif i_SUM_GUAR < 0 then
      v_Error_Text := 'Некорректно указана сумма обеспечения!';

    elsif i_CURRENCY is NULL then
      v_Error_Text := 'Не указана валюта обеспечения!';

    elsif NOT Data_Exists('V_CURRENCY', 'CODE = ''' || i_CURRENCY || '''') then
      v_Error_Text := 'Введенный код ВАЛЮТЫ обеспечения ( ' || i_CURRENCY || ' ) в справочнике не найден!';
    end if;

    return v_Error_Text;

  end Check_Guarantee;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка График погашения основного долга
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Function Is_Graph_Debt
  (
    iLoan_Id   in Ln_Card.Loan_Id%type,
    iLoan_Type in Ln_Card.Loan_Type%type,
    iSumm_Loan in Ln_Card.Summ_Loan%type,
    oError_Log out varchar2
  ) return boolean is
    v_Summ_Graph number(20);
    v_Cnt        pls_integer;
  begin
    select count(*), sum(Summ_Red)
      into v_Cnt, v_Summ_Graph
      from Ln_Graph_Debt t
     where t.Loan_Id = Iloan_Id;
    --
    if v_Cnt = 0 then
      oError_Log := 'Не задано "График погашения основного долга"!';
      return false;
    end if;
    --
    if v_Summ_Graph = 0 then
      oError_Log := 'Обшая сумма "График погашения основного долга" не должна быть 0!';
      return false;
    end if;
    --
    if iSumm_Loan != v_Summ_Graph then
      if Is_Loan_Open_End_Credit(iLoan_Type) and iSumm_Loan < v_Summ_Graph then
        return true;
      else
        oError_Log := 'Обшая сумма "График погашения основного долга" не совподает сумма договора!';
        return false;
      end if;
    end if;
    --
    return true;
  end Is_Graph_Debt;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка График погашения основных процентов
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Function Is_Graph_Perc
  (
    Iloan_Id   in Ln_Card.Loan_Id%type,
    Oerror_Log out varchar2
  ) return boolean is
    v_Summ_Graph number(20);
    --v_Summ_Loan  number(20);
    v_Cnt        pls_integer;
  begin
    select count(*), sum(Summ_Red)
      into v_Cnt, v_Summ_Graph
      from Ln_Graph_Perc t
     where t.Loan_Id = Iloan_Id;
    --
    if v_Cnt = 0 then
      Oerror_Log := 'Не задано "График погашения основных процентов"!';
      return false;
    end if;
    --
    if v_Summ_Graph = 0 then
      Oerror_Log := 'Обшая сумма "График погашения основных процентов" не должна быть 0!';
      return false;
    end if;
    --
    return true;
  end Is_Graph_Perc;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка всех обеспечений текущего договора
*  @iGuarantee  -  текущее обеспечение
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  function Is_Guarantee_Valid ( iLoan_ID    in  ln_card.loan_id%type
                              , oError_Log  out varchar2
                              ) return boolean
  is
    v_Error_Text           varchar2(3000);
    v_Is_Guarantee_Exists  boolean := false;
    v_Count                pls_integer;
    v_Guar_Summ            number(20);
    v_Coas                 Totalizer := Totalizer();
    v_Accs                 Totalizer := Totalizer();
    v_Coa_Buckets          Totalizer_Bucket;
    v_Acc_Coas            Array_Varchar2; 
    v_Acc_Saldos          Array_Number;
    v_Od                  date := Setup.Get_Operday;
  begin
    if Ln_Cache.Loan.Guar_Type = Ln_Const.Loan_Not_Guaranteed then
      return true;
    end if;
    v_Guar_Summ := 0;
    for gua in (select g.*, 
                       (select s.Name from Ln_v_Credit_Guarant s where s.CODE = g.guar_type) Guar_Type_Name,
                       (select c.Coa from ln_s_coa_guarant_types c where c.Guar_Type = g.Guar_Type) Coa
                  from Ln_Loan_Guar g 
                 where g.Loan_Id = iLoan_ID 
                   and g.Condition = 1)
    loop
      if Gua.Coa is not null then 
        v_Coas.Plus(Gua.Coa, Gua.Sum_Guar);
      end if;
      v_Guar_Summ := v_Guar_Summ + gua.Sum_Guar/* * Currency.Get_Course(gua.Currency)*/;
      v_Is_Guarantee_Exists := true;
      v_Error_Text := Check_Guarantee( Gua.Guar_Type, Gua.Sum_Guar, Gua.Currency );
      if v_Error_Text is NOT NULL then
        oError_Log := 'Ошибка при проверке обеспечения "' || Gua.Guar_Type_Name || '" :' || Ut.cCRLF || v_Error_Text;
        return false;
      end if;
      --Проверка Обеспечения принят ЗР
      if Gua.Guar_Type <> '73' and 
         Ln_Util.Is_Access_Param_With_Clients('APPROVED_LOAN_WITHOUT_PLEDGE_REGISTRY', 'CHECK_LOANS_APPROVED_LOAN_WITHOUT_PLEDGE_REGISTRY', to_char(iLoan_ID)) = 'Y' then
        select count(Stat_Code)
          into v_Count
          from Pr_r_State_Provisions
         where Stat_Code = gua.Guar_Type
           and Rownum = 1;
         if v_Count = 1 then
           select count(t.Code_Pr)
             into v_Count
             from Pr_Records t
            where t.Id = Gua.Record_Id
              and t.Code_Pr is not null;
           if v_Count = 0 then
             oError_Log := 'Обеспечение кредита не зарегистрировано в залоговом реестре, отправьте запись в залоговый реестр.';
             return false;
           end if;
         end if;
       end if;
    end loop;
    if NOT v_Is_Guarantee_Exists then
      oError_Log := 'Не задано обеспечение кредита!';
      return false;
    end if;
    if Ln_Cache.Loan.Summ_Loan * 1.25 > v_Guar_Summ and Ln_Setting.Get_Sys_Param('NOT_APPROVE_ALL_GUAR_IS_LESS_THAN_125%_OF_LOAN') = 'Y' and 
       Ln_Cache.Loan.Product_Id > 1 and not Ln_Init.Is_Beepul_Product(Ln_Cache.Loan.Product_Id) and not Ln_Init.Is_New_Client_Product(Ln_Cache.Loan.Product_id) then
      oError_Log := 'Запрет утверждения договора если сумма обеспечения меньше 125% от суммы договора';
      return false;
    end if;
    --
    v_Is_Guarantee_Exists := true;
    if Ln_Product.Get_Product_Param('APPRVL_CNTRCT_MATCH_GUAR_BLNC', Ln_Cache.Loan.Product_ID, false) = 'Y' then 
      select l.Coa,sum(abs(a.Saldo_Out))
        bulk collect
        into v_Acc_Coas, v_Acc_Saldos
        from Ln_Account l, Accounts a
       where l.Loan_Id = iLoan_Id
         and l.Loan_Type_Account in (28, 39, 71)
         and l.Date_Validate <= v_Od
         and l.Date_Next > v_Od
         and l.Acc_Id = a.Id
       group by l.Coa;
       --
      for i in 1..v_Acc_Coas.count loop
        v_Accs.Plus(v_Acc_Coas(i), v_Acc_Saldos(i));
      end loop;
      --
      v_Coa_Buckets := v_Coas.Get_Bucket;
      oError_Log := 'Ошибка при сравнении сальдо и суммы обеспечения:';
      for i in 1..v_Coa_Buckets.Count loop
        if abs(v_Accs.Get(v_Coa_Buckets(i).Key)) <> v_Coa_Buckets(i).Amount then 
          v_Is_Guarantee_Exists := false;
          oError_Log := oError_Log || Ut.cCRLF || '   ' || v_Coa_Buckets(i).Key || 
                        ' не равен сальдо ' || Adm_Rep_Util.f_Sum(abs(v_Accs.Get(v_Coa_Buckets(i).Key)/100)) ||
                        ' и сумма обеспечения ' || Adm_Rep_Util.f_Sum(v_Coa_Buckets(i).Amount/100);
        end if;
      end loop;
    end if;
    return /*true*/v_Is_Guarantee_Exists;
  end Is_Guarantee_Valid;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка График ЛИМИТА для ОВЕРДРАФТА
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Function Is_Overdraft_Limit
  (
    i_Loan_Id number,
    o_Msg     out varchar2
  ) return boolean is
    result       pls_integer := 0;
    v_Count      number := 0;
    v_Product_Id Ln_Products.Product_Id%type := Ln_Cache.Loan.Product_Id;
  begin
    if v_Product_Id is null then 
      select c.Product_Id
        into v_Product_Id
        from Ln_Card c
       where c.Loan_Id = i_Loan_Id;
    end if;
    --
    select count(*)
      into v_Count
      from Ln_Products t
     where t.Group_Id = -1
       and t.Product_Id = v_Product_Id;
    if v_Count = 0 then
      return true;
    elsif Ln_Init.Get_Product_Id = Ln_Const.c_Pid_Overdraft_Bs then
      begin
        select count(*)
          into v_Count
          from Ln_Loan_Guar t
         where t.Guar_Type = 51
           and t.Loan_Id = i_Loan_Id;
      exception
        when No_Data_Found then
          v_Count := 0;
      end;
      if v_Count = 0 then
        o_Msg := 'Не заполнено обеспечение.  Для Benefit Supreme необходимо заполнить информацию о Страховом полисе';
        return false;
      end if;
    end if;
    --
    if 'GRAPH_NO_LIMIT' = Ln_Product.Get_Product_Param('SENDING_BTRT25_ACCORDING_TO', v_Product_Id, false) then
      return true;
    end if;
    --
    select count(*)
      into result
      from Ln_Overdraft_Limit
     where Loan_Id = i_Loan_Id;
    --
    if result = 0 then
      o_Msg := 'Не задано "График лимита"!';
      return false;
    end if;
    return true;
  end Is_Overdraft_Limit;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Productda plastik karta briktirilgan bolishi kk bolsa plastik karta bor
    yoqligini tekshiramiz
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Check_Has_Plastic_Card
  (
    i_Loan_Id    Ln_Card.Loan_Id%type,
    i_Product_Id Ln_Card.Product_Id%type
  ) is
    v_Count number(1);
  begin
    --if Nvl(i_Product_Id, Ln_Const.c_Pid_Default) = Ln_Const.c_Pid_Default then
      return;
    --end if;
    --
    if Ln_Product.Get_Product_Param(i_Code => 'REPAYMENT_WITH_PL_CARD', i_Product_Id => i_Product_Id) = 'Y' then
      select count(*)
        into v_Count
        from Ln_Loan_Uzcards t
       where t.Loan_Id = i_Loan_Id
         and t.State_Id = Ln_Const.c_Us_Accepted
         and Rownum = 1;
      if v_Count = 0 then
        Ut.Raise_Err('Не закреплена ни одна пластиковая карта клиента или поручителя');
      end if;
    end if;
  end Check_Has_Plastic_Card;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка данных договора
*  @iCard       - данные договора
*  @iMode       -  режим проверки данных договора :
                     1 - проверка при добавлении нового договора
                     2- проверка при корректировке неутвержденной ссудной карточки
                     3- проверка при корректировке утвержденной ссудной карточки
                     4- проверка при утверждении ссудной карточки
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
Procedure Validate_Card_Data
(
  Iloan in Ln_Cache.Contrat_Loan_t,
  Imode in varchar2
) is
    vCheck         Ln_Check_Card%rowtype;
    vMandatory     constant integer := 1;
    vGuar_Ids      array_varchar2;
    vClaim         Ln_Claim%rowtype;
    v_Client_Country_Code varchar2(3);
    Ex             Exception;
    vMessage       varchar2(3000);
    vClSubjectName varchar2(50);
    vCard          Ln_Card%rowtype := iLoan.Card;
    vDummy1        pls_integer;
    vDummy2        pls_integer;
    vFin_Amount    Ln_Credit_Sources.Financing_Amount%type;
    vLTYParam      Ln_Param_Defs.Code%type := 'LOAN_TYPES_FOR_';
    vPURParam      Ln_Param_Defs.Code%type := 'PURPOSE_LOAN_FOR_';
    vECOParam      Ln_Param_Defs.Code%type := 'ECO_SECTORS_FOR_PHYS';
    vORGParam      Ln_Param_Defs.Code%type := 'ORGAN_DIRECTS_FOR_';
    vCRSParam      Ln_Param_Defs.Code%type := 'CREDIT_SOURCE_FOR_';
    --v_Claim_Month  number;
    --v_Claim_day    number;
    --v_date         date;
    V_Leap_Years   number;
  begin
  select t.*
    into Vcheck
      from Ln_Check_Card t
     where t.Md = iMode;
    --
    vClaim := Get_Claim_Rowtype( iClaim_Id => Dw_Util.Get_Doc_Id( 'LNCONTRACT', vCard.Loan_Id, 'LNCLAIM' ) );
    --
    if vClaim.Client_Type is null then
      vClaim.Client_Type := Ln_Util.Get_Client_Subject_Code(vCard.Client_Code,vCard.Filial_Code,vCard.Client_Id);
    end if;
    --
    if vClaim.Client_Type = Ln_Const.JURIDICAL_PERSON then
      vMessage       := 'JUR';
      vClSubjectName := 'юридических лиц';
    elsif vClaim.Client_Type = Ln_Const.PHYSICAL_PERSON then
      vMessage       := 'PHYS';
      vClSubjectName := 'физических лиц';
    else
      vMessage       := 'IND';
      vClSubjectName := 'индивидуальный предприниматель';
    end if;
    vLTYParam := vLTYParam || vMessage;
    vPURParam := vPURParam || vMessage;
    vORGParam := vORGParam || vMessage;
    vCRSParam := vCRSParam || vMessage;
    --
    V_Leap_Years := Ln_Util.Count_Leap_Years(vCard.Open_Date, vCard.Close_Date);
    --
    vMessage := '';
    if vCard.Client_Code is Null then
      vMessage := 'Не задан код клиента!';
      raise Ex;

  elsif not Data_Exists('LN_V_CUR_FILIAL_CLIENTS', 'CODE=''' || Vcard.Client_Code || '''') then
    Vmessage := 'Указанный клиент ( ' || Vcard.Client_Code ||
                ' ) находится в состоянии НЕ АКТИВКЕН ' ||
                  'или НЕ ЯВЛЯЕТСЯ клиентом вашего филиала. (см. "Клиенты и счета")!';
      raise Ex;

    elsif vClaim.Client_Code <> vCard.Client_Code then
    Vmessage := 'В договоре указан недопустимый клиент - заявка заведена на "' ||
                vClaim.Client_Name || '"!';
      raise Ex;

    elsif vCard.Committee_Number is Null then
      vMessage := 'Не задан номер решения кредитного комитета!';
      raise Ex;

    elsif vCard.Date_Committee is Null then
      vMessage := 'Не задана дата решения кредитного комитета!';
      raise Ex;

    elsif trim(vCard.Contract_Desc) is Null or length(trim(vCard.Contract_Desc)) < 2 then
      vMessage := 'Поле "Заключение кредитного комитета о выдаче" должно содержать информацию, отличную от пробела и имеющую длину не менее 2 позиций!';
      raise Ex;

    elsif vCard.Card_Type is Null then
      vMessage := 'Не задан тип договора!';
      raise Ex;

  elsif not Data_Exists('Ln_V_Claim_Type', 'CODE=''' || Vcard.Card_Type || '''') then
      vMessage := 'Введенный тип договора( ' || vCard.Card_Type || ' ) в справочнике не найден!';
      raise Ex;

    elsif vCard.Claim_Number is Null then
      vMessage := 'Не задан номер заявки!';
      raise Ex;

    elsif vCard.Contract_Code is Null then
      vMessage := 'Не задан НОМЕР КРЕДИТНОГО ДОГОВОРА!';
      raise Ex;

    elsif vCard.Loan_Number is Null then
      vMessage := 'Не задан ПОРЯДКОВЫЙ НОМЕР КРЕДИТА!';
      raise Ex;

    elsif vCard.Contract_Date is Null then
      vMessage := 'Не задана ДАТА КРЕДИТНОГО ДОГОВОРА!';
      raise Ex;

    elsif vCard.Open_Date is Null then
      vMessage := 'Не задана дата начала договора!';
      raise Ex;

    elsif nvl(vClaim.Creator_Code, 'LN') != 'TBC' and vCard.Open_Date > setup.Get_Operday then
      vMessage := 'Не правильно введено дата начала договора!';
      raise Ex;

    elsif vCard.Date_Committee > vCard.Contract_Date then
    Vmessage := 'Дата договора ' || to_char(Vcard.Contract_Date, 'dd.mm.yyyy') ||
                ' должна быть больше или равна дате решения кредитного комитета ' ||
                to_char(Vcard.Date_Committee, 'dd.mm.yyyy') || '!';
      raise Ex;

    elsif vCard.Close_Date is Null then
      vMessage := 'Не задана дата окончания договора!';
      raise Ex;

    elsif vCard.Contract_Date >= vCard.Close_Date then
    Vmessage := 'Дата окончания договора должна быть больше даты кредитного договора!';
      raise Ex;

    elsif vClaim.Claim_Date >= vCard.Close_Date then
      vMessage := 'Дата окончания договора должна быть больше даты подачи заявки!';
      raise Ex;

    elsif vCard.Close_Date < vCard.Open_Date then
      vMessage := 'Дата окончания не должна быть меньше даты начала действия кредитного договора!';
      raise Ex;

    elsif vCard.Currency is Null then
      vMessage := 'Не задана ВАЛЮТА договора!';
      raise Ex;

  elsif not Data_Exists('V_CURRENCY', 'CODE=''' || Vcard.Currency || ''' and CONDITION = ''A''') then
      vMessage := 'Введенный код ВАЛЮТЫ ( ' || vCard.Currency || ' ) в справочнике не найден!';
      raise Ex;

  elsif Nvl(Vcard.Summ_Loan, 0) <= 0 then
      vMessage := 'Сумма кредита по договору должна быть больше нуля!';
      raise Ex;

    elsif vCard.Loan_Type is Null then
      vMessage := 'Не задан ВИД КРЕДИТОВАНИЯ!';
      raise Ex;
  elsif not
         Data_Exists('LN_V_CREDIT_TYPES', 'CODE=''' || Vcard.Loan_Type || ''' and Condition=''A''') then
    Vmessage := 'Введенный код ВИДА КРЕДИТОВАНИЯ ' || Vcard.Loan_Type ||
                ' в справочнике не найден!';
    raise Ex;
  elsif not Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List(Vltyparam,
                                                                          Setup.Get_Headermfo),
                                      Vcard.Loan_Type) then
      vMessage := 'Введенный код ВИДА КРЕДИТОВАНИЯ не предназначен для ' || vClSubjectName;
      raise Ex;
    --
    elsif vCard.Lending_Type is Null And vCard.Card_Type = '1' then
      vMessage := 'Не задан ВИД КРЕДИТОВАНИЯ (№ 110)';
      raise Ex;
  elsif not
         Data_Exists('V_TYPE_LENDINGS', 'CODE=''' || Vcard.Lending_Type || ''' and Condition=''A''') and
        Vcard.Card_Type = '1' then
    Vmessage := 'Введенный код ВИДА КРЕДИТОВАНИЯ (№ 110)' || Vcard.Lending_Type ||
                ' в справочнике не найден!';
      raise Ex;
    --
    elsif vCard.Card_Type = Ln_Const.Ln_Credit and vCard.Purpose_Loan is Null then
      vMessage := 'Не задана ЦЕЛЬ КРЕДИТА!';
      raise Ex;
  elsif vCard.Card_Type = Ln_Const.Ln_Credit and not Data_Exists('LN_V_PURPOSE_CIPHER',
          'Code=''' || Vcard.Purpose_Loan || ''' and Condition=''A'' and Code1<>''00''') then
    Vmessage := 'Введенный код ЦЕЛИ КРЕДИТА ( ' || Vcard.Purpose_Loan ||
                ' ) в справочнике не найден!';
    raise Ex;
  elsif vCard.Card_Type = Ln_Const.Ln_Credit and not Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List(Vpurparam, Setup.Get_Headermfo),
                                      Vcard.Purpose_Loan) then
      vMessage := 'Введенный код ЦЕЛИ КРЕДИТА не предназначен для ' || vClSubjectName;
      raise Ex;

    elsif vCard.Purpose_Lending is Null And vCard.Card_Type = '1' then
      vMessage := 'Не задана ЦЕЛЬ КРЕДИТА (№ 112)';
      raise Ex;
  elsif vCard.Card_Type = Ln_Const.Ln_Credit and not Data_Exists('LN_V_LENDING_PURPOSES', 'Code=''' || Vcard.Purpose_Lending || '''') and
        Vcard.Card_Type = '1' then
    Vmessage := 'Введенный код ЦЕЛИ КРЕДИТА (№ 112) ( ' || Vcard.Purpose_Lending ||
                ' ) в справочнике не найден!';
      raise Ex;

  elsif vCard.Eco_Sec is Null then
    vMessage := 'Не задан ЭКОНОМИЧЕСКИЙ СЕКТОР!';
      raise Ex;

  elsif not
         Data_Exists('LN_V_SECTOR',
                     'Code=''' || Vcard.Eco_Sec || ''' and Condition=''A'' and Kod_Class <> ''000''') then
    Vmessage := 'Введенный код ЭКОНОМИЧЕСКОГО СЕКТОРА ( ' || Vcard.Eco_Sec ||
                ' ) в справочнике не найден!';
    raise Ex;

  elsif vClaim.Client_Type = 2 and
        not Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List(Vecoparam,
                                                                          Setup.Get_Headermfo),
                                      Vcard.Eco_Sec) then
      vMessage := 'Введенный код ЭКОНОМИЧЕСКОГО СЕКТОРА  не предназначен для ' || vClSubjectName;
      raise Ex;

    elsif vCheck.Object_Loan = vMandatory and vCard.Object_Loan is Null then
      vMessage := 'Не задан ОБЪЕКТ ССУДЫ ( подробное описание назначения ссуды )!';
      raise Ex;

    elsif vCard.Guar_Class is Null then
      vMessage := 'Не задан КЛАСС ОБЕСПЕЧЕНИЯ ССУДЫ!';
      raise Ex;

  elsif not
         Data_Exists('V_CR_CL_GUARANT', 'CODE=''' || Vcard.Guar_Class || ''' and Condition=''A''') then
    Vmessage := 'Введенный код КЛАССА ОБЕСПЕЧЕНИЯ ССУДЫ ( ' || Vcard.Guar_Class ||
                ' ) в справочнике не найден!';
      raise Ex;

    elsif vCard.Form_Delivery is Null then
      vMessage := 'Не задана ФОРМА ВЫДАЧИ КРЕДИТА!';
      raise Ex;

  elsif not Data_Exists('V_LOAN_REDEMPTION_TYPE',
                        'CODE=''' || Vcard.Form_Delivery || ''' and Condition=''A''') then
    Vmessage := 'Введенный код ФОРМЫ ВЫДАЧИ КРЕДИТА ( ' || Vcard.Form_Delivery ||
                ' ) в справочнике не найден!';
      raise Ex;

    elsif vCard.Class_Quality is Null then
      vMessage := 'Не задан КЛАСС КАЧЕСТВА КРЕДИТА!';
      raise Ex;

  elsif not Data_Exists('V_CREDIT_CLASS_QUALITY',
                        'CODE=''' || Vcard.Class_Quality || ''' and Condition=''A''') then
    Vmessage := 'Введенный код КЛАССА КАЧЕСТВА КРЕДИТА ( ' || Vcard.Class_Quality ||
                ' ) в справочнике не найден!';
      raise Ex;

    elsif vCard.Form_Redemption is Null then
      vMessage := 'Не задана ФОРМА ПОГАШЕНИЯ КРЕДИТА!';
      raise Ex;

  elsif not Data_Exists('V_LOAN_REDEMPTION_TYPE',
                        'CODE=''' || Vcard.Form_Redemption || ''' and Condition=''A''') then
    Vmessage := 'Введенный код ФОРМЫ ПОГАШЕНИЯ КРЕДИТА ( ' || Vcard.Form_Redemption ||
                ' ) в справочнике не найден!';
      raise Ex;

    elsif vCard.Term_Loan_Type is Null then
      vMessage := 'Не задан ТИП ССУДЫ ПО СРОКУ';
      raise Ex;

  elsif not
         Data_Exists('V_CREDIT_TIME', 'CODE=''' || Vcard.Term_Loan_Type || ''' and Condition=''A''') then
    Vmessage := 'Введенный код ТИПА ССУДЫ ПО СРОКУ ( ' || Vcard.Term_Loan_Type ||
                ' ) в справочнике не найден!';
    raise Ex;
  
  elsif Vcard.Term_Loan_Type = Ln_Const.Short_Term_Type and
        (Vcard.Close_Date - Vcard.Open_Date) > 366 then
      vMessage := 'Для краткосрочного кредита неверно задан период действия кредита!';
      raise Ex;

  elsif Vcard.Term_Loan_Type = Ln_Const.Long_Term_Type and
        (Vcard.Close_Date - Vcard.Open_Date) < 366 then
      --- leap_Years
      if V_Leap_Years <> 0 then
        vMessage := 'Для долгосрочного кредита неверно задан период действия кредита!';
        raise Ex;
      end if;
    elsif vCard.Urgency_Type is Null then
      vMessage := 'Не указан интервал срочности кредита';
      raise Ex;

  elsif not Data_Exists('V_URGENCY', 'CODE=''' || Vcard.Urgency_Type || ''' and Condition=''A''') then
    Vmessage := 'Введенный код интервала срочности кредита ( ' || Vcard.Urgency_Type ||
                ' ) в справочнике не найден!';
      raise Ex;

    elsif vCard.Purpose_Loan = '020202' and vCard.Urgency_Type != '08' then
      vMessage := 'Цель кредита 020202 не равно сроку кредита "ОТ 1 ГОДА ДО 2 ЛЕТ"';
      raise Ex;

    elsif vCard.Purpose_Loan = '020203' and vCard.Urgency_Type != '07' then
      vMessage := 'Цель кредита 020203 не равно сроку кредита "ОТ 181 ДНЕЙ ДО 1 ГОДА"';
      raise Ex;

    elsif trim(vCard.Manager_Name) is Null or length(trim(vCard.Manager_Name)) < 2 then
      vMessage := 'Поле "ФИО управляющего, выдавшего кредит" должно содержать информацию, отличную от пробела и имеющую длину не менее 2 позиций!';
      raise Ex;
    end if;
   /* if nvl(vClaim.Creator_Code, 'LN') != 'FBCRM' 
      and vClaim.Client_Type = Ln_Const.JURIDICAL_PERSON 
      then
      vMessage :=  'Не задан ID руководителя !'; 
      raise Ex;
    end if;*/
  -- проверка на пустоту client_uid
    /*$IF CORE_APP_VERSION.C_CLIENT_UNIQUE $THEN
      if vCard.Client_Uid is null then
        vMessage := 'Уникальный Ид клиента не запольнено (Client_UID)';
        raise Ex;
      end if;
    $END*/
    if vCard.Card_Type = Ln_Const.Ln_Factoring then
      if nvl(vCard.Fc_Summ, 0) <= 0 and core_app_version.c_Header_Code <> 9002 then
        vMessage := 'СУММА УСТУПАЕМОГО ОБЯЗАТЕЛЬСТВА (Дисконт) должна быть больше нуля!';
        raise Ex;

      elsif vCheck.Fc_Desc = vMandatory and vCard.Fc_Desc is Null then
        vMessage := 'Не заданы СВЕДЕНИЯ О ПРИОБРЕТАЕМОМ ОБЯЗАТЕЛЬСТВЕ!';
        raise Ex;
      end if;
    end if;

  if Vcard.Card_Type in (Ln_Const.Ln_Credit, Ln_Const.Ln_Leasing) then
      if nvl(vCard.Grace_Period, 0) < 0 then
        vMessage := 'Льготный период не может принимать отрицательные значения!';
        raise Ex;

      elsif nvl(vCard.Grace_Period, 0) >= Months_Between(vCard.Close_Date, vCard.Open_Date) then
        vMessage := 'Количество льготных месяцев должно быть меньше (кол.во месяц-1 месяц)';
        raise Ex;

      elsif vCard.Days_In_Year is Null then
        vMessage := 'Не задан ТИП КАЛЕНДАРЯ!';
        raise Ex;

    elsif Vcard.Days_In_Year not in (1, 2, 3, 4, 5, 6) then
        vMessage := 'ТИП КАЛЕНДАРЯ может принимать только значения 360 либо 365, 366 дней!';
        raise Ex;

      elsif trim(vCard.Founders) is Null or length(trim(vCard.Founders)) < 2 then
        vMessage := 'Поле "Сведения об учредителях" должно содержать информацию, отличную от пробела и имеющую длину не менее 2 позиций!';
        raise Ex;
      elsif vCard.Class_Cred is Null then
        vMessage := 'Не задан КЛАСС КРЕДИТОСПОСОБНОСТИ ЗАЁМЩИКА!';
        raise Ex;

    elsif not
           Data_Exists('V_CLASS_CREDIT', 'CODE=''' || Vcard.Class_Cred || ''' and Condition=''A''') then
      Vmessage := 'Введенный КЛАСС КРЕДИТОСПОСОБНОСТИ ЗАЁМЩИКА ( ' || Vcard.Class_Cred ||
                  ' ) в справочнике не найден!';
        raise Ex;

    /*elsif vCard.Sign_Delivery is Null then
      vMessage := 'Не задан ПРИЗНАК ВЫДАЧИ КРЕДИТА!';
      raise Ex;

    elsif not Data_Exists('Ln_S_Sign_Delivery', 'CODE=''' || Vcard.Sign_Delivery || '''') then
      Vmessage := 'Введенный код ПРИЗНАКА ВЫДАЧИ КРЕДИТА ( ' || Vcard.Sign_Delivery ||
                  ' ) в справочнике не найден!';
      raise Ex;*/
    end if;
  
    if Vcard.Sign_Delivery = '1' then
      -- Кредит выдан по решению правительства
        if vCard.Gov_Num is Null then
          vMessage := 'Не задан НОМЕР ПОСТАНОВЛЕНИЯ ПРАВИТЕЛЬСТВА!';
          raise Ex;

        elsif vCard.Gov_Date is Null then
          vMessage := 'Не задана ДАТА ПОСТАНОВЛЕНИЯ ПРАВИТЕЛЬСТВА!';
          raise Ex;
        end if;
      end if;
    end if;

    if vCard.Guar_Class = Ln_Const.Loan_Not_Guaranteed then
    Vguar_Ids := Dw_Util.Get_Docs_Id('LNCONTRACT', Vcard.Loan_Id, 'LNGUARANTEE');

      if vGuar_Ids.count > 0 then
        select count(*), count(Decode(t.Guar_Type, '61', t.Guar_Type, '62', t.Guar_Type, null))
          into vDummy1, vDummy2
          from Ln_Loan_Guar t
          where Loan_Id = Vcard.Loan_Id and t.condition<>3;
        if vDummy2 = 0 or (vDummy2 > 0 and vDummy1 != vDummy2) then
        Vmessage := 'Нельзя изменить класс обеспечения договора на "Необеспеченная ссуда", ' ||
                    Ut.Ccrlf || 'так как за текущим договором закреплены обеспечения! ' || Ut.Ccrlf ||
                    'Сначало необходимо их удалить!';
          raise Ex;
        end if;
      end if;
    end if;

    if vClaim.Credit_Type = Ln_Const.Ln_Leasing and vCard.Loan_Type <> '26' then
      vMessage := 'Договору по лизингу в качестве вида кредитования может быть указан только [26]Лизинг';
      raise Ex;
    end if;

    if vCard.Loan_Type = '28' and vCard.Card_Type <> Ln_Const.Ln_Factoring then
      vMessage := 'Договору по факторингу в качестве вида кредитования может быть указан только [28]Факторинг';
      raise Ex;
    end if;

  if Vcard.Card_Type = Ln_Const.Ln_Credit and Vcard.Loan_Type in ('26', '28') then
      vMessage := 'Кредитному договору в качестве вида кредитования не могут быть указаны [26]Лизинг и [28]Факторинг';
      raise Ex;
    end if;

  if Substr(Vcard.Purpose_Loan, 0, 2) = '05' and
     vClaim.Client_Type = Ln_Const.Individual_Entrepreneur then
      vMessage := 'Индивидуальным предпринимателям не может быть выдан кредит по отдельным решениям правительства (поле "Цель кредита")';
      raise Ex;
    end if;

    if vClaim.Client_Type = Ln_Const.PHYSICAL_PERSON and substr(vCard.Purpose_Loan, 0, 2) <> '06' then
      vMessage := 'Физ. лицам может быть выдан только кредит, выдаваемый населению (поле "Цель кредита")';
      raise Ex;
    end if;

    if substr(vCard.Purpose_Loan, 0, 2) = '06' and vClaim.Client_Type <> Ln_Const.PHYSICAL_PERSON then
      vMessage := 'Только физ. лицам может быть выдан кредит, выдаваемый населению (поле "Цель кредита")';
      raise Ex;
    end if;

    if vCard.Loan_Type in ('54', '30') and vClaim.Client_Type <> Ln_Const.PHYSICAL_PERSON then
      vMessage := '[54]Овердрафт по пластиковым карточкам физ. лиц, [30]Потребительский кредит (поле "Вид кредитования") может выдаваться только физ. лицам!';
      raise Ex;
    end if;

  if Vcard.Loan_Type = '22' and (vClaim.Client_Type <> Ln_Const.Juridical_Person or
     Substr(vClaim.Borrower, 0, 2) not in ('06', '07')) then
      vMessage := '[22]Межбанковский кредит (поле "Вид кредитования") может выдаваться только юр. лицам с типом клиента "Центральный банк" и "Коммерческие банки"!';
      raise Ex;
    end if;

  if Vcard.Card_Type = Ln_Const.Ln_Factoring and
     Vcard.Close_Date - Vcard.Open_Date > Nk_Const.Factoring_Period_Use_In_Days then
    Vmessage := 'Срок пользования для факторинга не должен превышать ' ||
                Nk_Const.Factoring_Period_Use_In_Days || ' дней! (' ||
                to_char(Vcard.Open_Date, 'dd.mm.yyyy') || ',' ||
                to_char(Vcard.Close_Date, 'dd.mm.yyyy') || ')';
      raise Ex;
    end if;
    vFin_Amount := 0;
  for i in 1 .. Iloan.Credit_Source.Count
    loop
      if iLoan.Credit_Source(i) is Null then
        vMessage := 'Не задан ИСТОЧНИК ФИНАНСИРОВАНИЯ!';
        raise Ex;

    elsif not Data_Exists('Ln_v_Credit_Source', 'CODE=''' || Iloan.Credit_Source(i) || '''') then
      Vmessage := 'Введенный код ИСТОЧНИКА ФИНАНСИРОВАНИЯ ( ' || Iloan.Credit_Source(i) ||
                  ' ) в справочнике не найден!';
      raise Ex;
    elsif not Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List(Vcrsparam,
                                                                            Setup.Get_Headermfo),
                                        Iloan.Credit_Source(i)) then
        vMessage := 'Введенный код ИСТОЧНИКА ФИНАНСИРОВАНИЯ не предназначен для ' || vClSubjectName;
        raise Ex;
      end if;

    if Iloan.Credit_Source(i) in ('41', '46') then
      -- Зарубежные банки и другие международные организации
        if iLoan.Foreign_Organization(i) is Null then
          vMessage := 'Для ИСТОЧНИКОВ ФИНАНСИРОВАНИЯ [41]Зарубежные банки, [46]Другие международные организации необходимо указать код зарубежного банка!';
          raise Ex;

      elsif not
             Data_Exists('V_FOREIGN_ORGANIZATION',
                         'Code=''' || Iloan.Foreign_Organization(i) || ''' and Condition=''A''') then
        Vmessage := 'Введенный код зарубежного банка ( ' || Iloan.Foreign_Organization(i) ||
                    ' ) в справочнике не найден!';
          raise Ex;
        end if;
      end if;

      if iLoan.Financing_Currency(i) is Null then
        vMessage := 'Не указана валюта финансирования!';
        raise Ex;

    elsif not Data_Exists('V_CURRENCY',
                          'CODE=''' || Iloan.Financing_Currency(i) || ''' and CONDITION = ''A''') then
      Vmessage := 'Введенная валюта финансирования ( ' || Iloan.Financing_Currency(i) ||
                  ' ) в справочнике не найдена!';
        raise Ex;
      end if;

      if nvl(iLoan.Financing_Amount(i), 0) <= 0 then
        vMessage := 'Сумма финансирования должна быть больше нуля!';
        raise Ex;
      end if;

      if trim(iLoan.Loan_Line_Purpose(i)) is Null or length(trim(iLoan.Loan_Line_Purpose(i))) < 2 then
        vMessage := 'Поле "Цель кредитной линии" должно содержать информацию, отличную от пробела и имеющую длину не менее 2 позиций!';
        raise Ex;
      end if;
      if iLoan.Financing_Currency(i) = Setup.Get_BaseCurrency then
        vFin_Amount := vFin_Amount + nvl(iLoan.Financing_Amount(i), 0);
      else
      Vfin_Amount := Vfin_Amount + Currency.Calc_Eqv(Nvl(Iloan.Financing_Amount(i), 0),
                                                     Iloan.Financing_Currency(i),
                                                     Iloan.Card.Contract_Date);
      end if;
    end loop;
    if iLoan.Card.Currency = Setup.Get_BaseCurrency then
      if vFin_Amount <> iLoan.Card.Summ_Loan then
      Em.Raise_Error('LNCRS',
                     'Общая сумма финансирования по источникам кредитования не соответствует сумме договора');
    end if;
  else
    if Vfin_Amount <>
       Currency.Calc_Eqv(Iloan.Card.Summ_Loan, Iloan.Card.Currency, Iloan.Card.Contract_Date) then
      Em.Raise_Error('LNCRS',
                     'Общая сумма финансирования по источникам кредитования не соответствует сумме договора');
      end if;
    end if;
    --
    if vClaim.Client_Type <> Ln_Const.PHYSICAL_PERSON and
     not
      Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List(Vorgparam, Setup.Get_Headermfo),
                                Bank.Get_Client_Orgdirect(Vcard.Client_Code, 'N', Vcard.Filial_Code)) then
      begin
        select t.country_code
          into v_Client_Country_Code
          from client_current t
         where t.subject = 'J'
           and t.id = vClaim.Client_Id
           and rownum = 1;
      exception
        when no_data_found then
          null;
      end;
    if v_Client_Country_Code = '860' then
      -- UZB
        vMessage := 'Введенный код ОРГАНОВ УПРАВЛЕНИЯ не предназначен для ' || vClSubjectName || '. ' ||
                    'Исправьте данные клиента в подсистеме "Клиенты и счета"';
        raise Ex;
      end if;
    end if;
    --
    if iLoan.Card.SIGN_DELIVERY = 1 and
     Setup.Get_Headermfo not in ('09002', '09003', '09004', '09009', '09013') then
       vMessage := 'Ваш банк не может выдавать кредиты по решению Правительства';
       raise Ex;
    end if;
    --
    --v_Claim_Month := to_number(Substr(vClaim.Period_Use, 1, 3));
    --v_Claim_day   := to_number(substr(vClaim.Period_Use, 5));
    --v_date := add_months(vCard.Open_Date, v_Claim_Month);
    --v_date := v_date + v_Claim_day;
    /*if vCard.Close_Date > v_date then
      raise_application_error(-20000, 'Период пользования ссудой в заявке не совподает с сроком кредита');
    end if;*/
    if iLoan.Card.guar_class = 3 and not Ln_Init.Is_Online_Product(iLoan.Card.product_id) then
      select count(*)
        into vDummy1
        from ln_loan_guar
       where loan_id = iLoan.Card.loan_id
         and guar_type not in (61, 62) --bez obespecheniya
         and condition<>3
         and rownum = 1;
      if vDummy1 > 0 then
        vMessage := 'Для этого договора завядено обеспечения';
        raise Ex;
      end if;
    end if;
    --
    if Ln_Product.Product_Group_Id(iLoan.Card.Product_Id) = Ln_Const.c_PGid_Credit_Card_Acc then
      select count(*)
        into vDummy1
        from Ln_Loan_Params
       where Loan_Id = iLoan.Card.Loan_Id
         and Param_Id = 74
         and Ln_Product.Is_Card_Product_Code(i_Code => Value) = 'Y';
      --
      if vDummy1 = 0 then
        vMessage := 'Неправильно введена ТИП КАРТЫ';
        raise Ex;
      end if;
    end if;
    -- Физ лиц проверки
    if vClaim.Client_Type = Ln_Const.Physical_Person  then
      --- Связанные с банком лица
    if Ln_Util.Check_Persons_Associated(vClaim.Client_Id) <>
       Ln_Util.Get_Loan_Param_Value(Vcard.Loan_Id, 65) then
        if Ln_Util.Check_Persons_Associated(vClaim.Client_Id) = 'Y' then
          vMessage := 'Этот заемщик является связанным лицом, изменение данных невозможно';
        else
          vMessage := 'Этот заемщик не является связанным лицом, изменение данных невозможно';
        end if;
        raise Ex;
      end if;
    end if;
    --
    if Ln_Schedule.Get_Min_Graph_Date(vCard.Loan_Id) < vCard.Open_Date then
      vMessage := 'Дата начала графика основного долга или процентов должна быть болmше Даты начала договора';
    end if;
    --
    /*if core_app_version.c_Header_Code <> 9012 and vClaim.Summ_Claim < iLoan.Card.SUMM_LOAN then
       vMessage := 'Сумма договора превышает сумму заявки';
       raise Ex;
    end if;*/
  exception
    when Ex then
    Ut.Raise_Err(Vmessage);
  end Validate_Card_Data;
/* -----------------------------------------------------------------
*     Проверка на возможность корректировки реквизитов утвержденного договора
* @iNew_Loan  - реквизиты нового договора
* @iLoan      - реквизиты текущего договора
* @return     - сообщения
----------------------------------------------------------------- */
Function Check_Locked_Card_Before_Edit
(
  Inew_Loan in Ln_Cache.Contrat_Loan_t,
  Iloan     in Ln_Cache.Contrat_Loan_t
) return varchar2 is
    vMessage   varchar2(3000);
    vLocked    Ln_Check_card%rowtype;
    vCard      Ln_Card%rowtype := iLoan.Card;
    vNew_Card  Ln_Card%rowtype := iNew_Loan.Card;
  begin
  select t.*
    into Vlocked
      from Ln_Check_Card t
   where t.Md = Ln_Const.Lock_Card;
    if vLocked.LOAN_TYPE = 1 and vNew_Card.LOAN_TYPE <> vCard.LOAN_TYPE then
      vMessage := 'Вы не можете изменить ВИД КРЕДИТОВАНИЯ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.OPEN_DATE = 1 and vNew_Card.OPEN_DATE <> vCard.OPEN_DATE then
      vMessage := 'Вы не можете изменить ДАТУ ВЫДАЧИ ССУДЫ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CLOSE_DATE = 1 and vNew_Card.CLOSE_DATE <> vCard.CLOSE_DATE then
      vMessage := 'Вы не можете изменить ДАТУ ПОГАШЕНИЯ ССУДЫ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.OBJECT_LOAN = 1 and vNew_Card.OBJECT_LOAN <> vCard.OBJECT_LOAN then
      vMessage := 'Вы не можете изменить ОБЪЕКТ ССУДЫ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CARD_TYPE = 1 and vNew_Card.CARD_TYPE <> vCard.CARD_TYPE then
      vMessage := 'Вы не можете изменить ТИП ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CLAIM_NUMBER = 1 and vNew_Card.CLAIM_NUMBER <> vCard.CLAIM_NUMBER then
      vMessage := 'Вы не можете изменить НОМЕР ЗАЯВКИ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.COMMITTEE_NUMBER = 1 and vNew_Card.COMMITTEE_NUMBER <> vCard.COMMITTEE_NUMBER then
      vMessage := 'Вы не можете изменить НОМЕР РЕШЕНИЯ КРЕДИТНОГО КОМИТЕТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.DATE_COMMITTEE = 1 and vNew_Card.DATE_COMMITTEE <> vCard.DATE_COMMITTEE then
      vMessage := 'Вы не можете изменить ДАТУ РЕШЕНИЯ КРЕДИТНОГО КОМИТЕТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CONTRACT_CODE = 1 and vNew_Card.CONTRACT_CODE <> vCard.CONTRACT_CODE then
      vMessage := 'Вы не можете изменить НОМЕР КРЕДИТНОГО ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CONTRACT_DATE = 1 and vNew_Card.CONTRACT_DATE <> vCard.CONTRACT_DATE then
      vMessage := 'Вы не можете изменить ДАТУ КРЕДИТНОГО ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CONTRACT_DESC = 1 and vNew_Card.CONTRACT_DESC <> vCard.CONTRACT_DESC then
      vMessage := 'Вы не можете изменить ОСНОВАНИЕ ДЛЯ ЗАКЛЮЧЕНИЯ КРЕДИТНОГО ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.AGR_NUM_NOTARIAL = 1 and vNew_Card.AGR_NUM_NOTARIAL <> vCard.AGR_NUM_NOTARIAL then
      vMessage := 'Вы не можете изменить НОМЕР НОТАРИАЛЬНОГО ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.AGR_DATE_NOTARIAL = 1 and vNew_Card.AGR_DATE_NOTARIAL <> vCard.AGR_DATE_NOTARIAL then
      vMessage := 'Вы не можете изменить ДАТУ НОТАРИАЛЬНОГО ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.DOC_NOTARIAL_NUM = 1 and vNew_Card.DOC_NOTARIAL_NUM <> vCard.DOC_NOTARIAL_NUM then
      vMessage := 'Вы не можете изменить НОМЕР НОТАРИАЛЬНОГО УДОСТОВЕРЕНИЯ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.DOC_NOTARIAL_DATE = 1 and vNew_Card.DOC_NOTARIAL_DATE <> vCard.DOC_NOTARIAL_DATE then
      vMessage := 'Вы не можете изменить ДАТУ НОТАРИАЛЬНОГО УДОСТОВЕРЕНИЯ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.DOC_GOVER_NUM = 1 and vNew_Card.DOC_GOVER_NUM <> vCard.DOC_GOVER_NUM then
      vMessage := 'Вы не можете изменить НОМЕР ГОС. РЕГИСТРАЦИИ ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.DOC_GOVER_DATE = 1 and vNew_Card.DOC_GOVER_DATE <> vCard.DOC_GOVER_DATE then
      vMessage := 'Вы не можете изменить ДАТУ ГОС. РЕГИСТРАЦИИ ДОГОВОРА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CURRENCY = 1 and vNew_Card.CURRENCY <> vCard.CURRENCY then
      vMessage := 'Вы не можете изменить ВАЛЮТУ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.SUMM_LOAN = 1 and vNew_Card.SUMM_LOAN <> vCard.SUMM_LOAN then
      vMessage := 'Вы не можете изменить ДОГОВОРНУЮ СУММУ КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.DAYS_IN_YEAR = 1 and vNew_Card.DAYS_IN_YEAR <> vCard.DAYS_IN_YEAR then
      vMessage := 'Вы не можете изменить ТИП КАЛЕНДАРЯ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.GRACE_PERIOD = 1 and vNew_Card.GRACE_PERIOD <> vCard.GRACE_PERIOD then
      vMessage := 'Вы не можете изменить ЛЬГОТНЫЙ ПЕРИОД ( В МЕСЯЦАХ ) без разрешения Кредитного Департамента ГО!';

    elsif vLocked.FORM_DELIVERY = 1 and vNew_Card.FORM_DELIVERY <> vCard.FORM_DELIVERY then
      vMessage := 'Вы не можете изменить ФОРМУ ВЫДАЧИ КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.FORM_REDEMPTION = 1 and vNew_Card.FORM_REDEMPTION <> vCard.FORM_REDEMPTION then
      vMessage := 'Вы не можете изменить ФОРМУ ПОГАШЕНИЯ КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.TERM_LOAN_TYPE = 1 and vNew_Card.TERM_LOAN_TYPE <> vCard.TERM_LOAN_TYPE then
      vMessage := 'Вы не можете изменить ТИП ССУДЫ ПО СРОКУ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.ECO_SEC = 1 and vNew_Card.ECO_SEC <> vCard.ECO_SEC then
      vMessage := 'Вы не можете изменить ЭКОНОМИЧЕСКИЙ СЕКТОР без разрешения Кредитного Департамента ГО!';

    elsif vLocked.PURPOSE_LOAN = 1 and vNew_Card.PURPOSE_LOAN <> vCard.PURPOSE_LOAN then
      vMessage := 'Вы не можете изменить ЦЕЛЬ КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CLASS_CRED = 1 and vNew_Card.CLASS_CRED <> vCard.CLASS_CRED then
      vMessage := 'Вы не можете изменить КЛАСС КРЕДИТОСПОСОБНОСТИ ЗАЁМЩИКА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.CLASS_QUALITY = 1 and vNew_Card.CLASS_QUALITY <> vCard.CLASS_QUALITY then
      vMessage := 'Вы не можете изменить КЛАСС КАЧЕСТВА КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.MOTIVE_REVISING = 1 and vNew_Card.MOTIVE_REVISING <> vCard.MOTIVE_REVISING then
      vMessage := 'Вы не можете изменить ОбОСНОВАНИЕ ПЕРЕСМОТРА КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.DATE_REVISING = 1 and vNew_Card.DATE_REVISING <> vCard.DATE_REVISING then
      vMessage := 'Вы не можете изменить ДАТУ ВСТУПЛЕНИЯ В ДЕЙСТВИЕ ПЕРЕСМОТРА КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.SIGN_DELIVERY = 1 and vNew_Card.SIGN_DELIVERY <> vCard.SIGN_DELIVERY then
      vMessage := 'Вы не можете изменить ПРИЗНАК ВЫДАЧИ КРЕДИТА без разрешения Кредитного Департамента ГО!';

    elsif vLocked.GUAR_CLASS = 1 and vNew_Card.GUAR_CLASS <> vCard.GUAR_CLASS then
      vMessage := 'Вы не можете изменить КЛАСС ОБЕСПЕЧЕНИЯ без разрешения Кредитного Департамента ГО!';

    elsif vLocked.MANAGER_NAME = 1 and vNew_Card.MANAGER_NAME <> vCard.MANAGER_NAME then
      vMessage := 'Вы не можете изменить ФИО УПРАВЛЯЮЩЕГО БАНКОМ, ВЫДАВШЕГО КРЕДИТ без разрешения Кредитного Департамента ГО!';
    end if;

    if vNew_Card.CARD_TYPE = Ln_const.Ln_Factoring then
      if vLocked.FC_DESC = 1 and vNew_Card.FC_DESC <> vCard.FC_DESC then
      Vmessage := Vmessage || Ut.Ccrlf ||
                  'Вы не можете изменить СВЕДЕНИЯ О ПРИОБРЕТАЕМОМ ОБЯЗАТЕЛЬСТВЕ без разрешения Кредитного Департамента ГО!';

      elsif vLocked.FC_SUMM = 1 and vNew_Card.FC_SUMM <> vCard.FC_SUMM then
      Vmessage := Vmessage || Ut.Ccrlf ||
                  'Вы не можете изменить СУММУ УСТУПАЕМОГО ОБЯЗАТЕЛЬСТВА - ДИСКОНТ без разрешения Кредитного Департамента ГО!';
      end if;
    end if;

    return vMessage;
  end Check_Locked_Card_Before_Edit;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверка настроек режимов работы
*  @iLoan_ID   - уникальный номер договора
*  @oError_Log - текст ошибки
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
Function Is_Mode_Actions_Valid
(
  Iloan_Id     in Ln_Card.Loan_Id%type,
  Icredit_Type in Ln_Card.Card_Type%type,
  Iproduct_Id  in Ln_Card.Product_Id%type,
  Oerror_Log   out varchar2
) return boolean is
    vIs_Data_Valid  boolean := true;
    vError_Log      varchar2(3000);
    vMode_Actions   Ln_Mode_Actions%rowtype;
    vCheck_ORP      varchar2(10) := 'ALL';
    vCheck_OCHP     varchar2(10) := 'ALL';
    --vPerc_Mode      varchar2(3) := 'IN';
    vProduct_Gr_Id  Ln_Products.Group_Id%type := Ln_Product.Product_Group_Id(iProduct_Id);
  begin
  select *
    into Vmode_Actions
      from Ln_Mode_Actions
     where Loan_Id = iLoan_ID;
    --
    if not Ln_Init.Is_Product then
      vCheck_ORP  := nvl(LN_SETTING.Get_Sys_Param('CHECK_OPTION_REDEMPTION_PERCENT'),'ALL');
      vCheck_OCHP := nvl(LN_SETTING.Get_Sys_Param('CHECK_OPTION_CHARGE_PERCENT'),'ALL');
    else
      Ln_Product.Check_Mode_Action(i_Mode_Action => vMode_Actions);
      return true;
    end if;
    --
    if vMode_Actions.CALC_DATE is Null then
      vError_Log := 'Не задана ДАТА НАЧАЛА РАСЧЕТОВ!';
    elsif iCredit_Type = ln_const.Ln_Credit and vMode_Actions.RED_DATE is Null then
      vError_Log := 'Не задан ДЕНЬ МЕСЯЦА ПОГАШЕНИЯ ПРОЦЕНТОВ!';
    elsif vMode_Actions.Mode_Perc_Calc is Null then
      vError_Log := 'Не задан РЕЖИМ НАЧИСЛЕНИЯ ПРОЦЕНТОВ!';
    elsif NOT Data_Exists('Ln_S_Mode_Perc_Calc', 'CODE = ''' || vMode_Actions.Mode_Perc_Calc || '''') then
    Verror_Log := 'Введенный код РЕЖИМА НАЧИСЛЕНИЯ ПРОЦЕНТОВ ( ' || Vmode_Actions.Mode_Perc_Calc ||
                  ' ) в справочнике не найден!';
    elsif vCheck_OCHP <> 'ALL' and vCheck_OCHP <> vMode_Actions.Mode_Perc_Calc then
    Verror_Log := 'В вашем банке РЕЖИМА НАЧИСЛЕНИЯ ПРОЦЕНТОВ может быть установлен только "' ||
                  Upper(Ln_Service.Get_Mode_Perc_Calc_Name(Vcheck_Ochp)) || '"!';
    elsif vMode_Actions.SEND_TO_PERC is Null then
      vError_Log := 'Не задано МЕСТО АККУМУЛИРОВАНИЯ НАЧИСЛЕННЫХ ОСНОВНЫХ ССУДНЫХ ПРОЦЕНТОВ!';
    elsif NOT Data_Exists('Ln_S_Send_To_Perc', 'CODE = ''' || vMode_Actions.SEND_TO_PERC || '''') then
    Verror_Log := 'Введенный код МЕСТА АККУМУЛИРОВАНИЯ НАЧИСЛЕННЫХ ОСНОВНЫХ ССУДНЫХ ПРОЦЕНТОВ ( ' ||
                  Vmode_Actions.Send_To_Perc || ' ) в справочнике не найден!';
    elsif (vMode_Actions.SEND_TO_PERC = 'OUT' and vProduct_Gr_Id <> Ln_Const.c_PGid_Credit_Card_Acc) or
          (vMode_Actions.SEND_TO_PERC = 'IN' and vProduct_Gr_Id = Ln_Const.c_PGid_Credit_Card_Acc) then
      vError_Log := 'Введенный код МЕСТА АККУМУЛИРОВАНИЯ НАЧИСЛЕННЫХ ОСНОВНЫХ ССУДНЫХ ПРОЦЕНТОВ не верен';
    elsif vMode_Actions.Perc_Delinquency_Send_To is Null then
      vError_Log := 'Не задано МЕСТО АККУМУЛИРОВАНИЯ НАЧИСЛЕННЫХ ПРОЦЕНТОВ ПО ПРОСРОЧЕННОЙ ССУДЕ!';
  elsif (Vmode_Actions.Perc_Delinquency_Send_To = 'OUT' and
        Vproduct_Gr_Id <> Ln_Const.c_Pgid_Credit_Card_Acc) or
        (Vmode_Actions.Perc_Delinquency_Send_To = 'IN' and
        Vproduct_Gr_Id = Ln_Const.c_Pgid_Credit_Card_Acc) then
      vError_Log := 'Введенный код МЕСТА АККУМУЛИРОВАНИЯ НАЧИСЛЕННЫХ ПРОЦЕНТОВ ПО ПРОСРОЧЕННОЙ ССУДЕ не верен';
  elsif not Data_Exists('Ln_S_Send_To_Perc',
                        'CODE = ''' || Vmode_Actions.Perc_Delinquency_Send_To || '''') then
    Verror_Log := 'Введенный код МЕСТА АККУМУЛИРОВАНИЯ НАЧИСЛЕННЫХ ПРОЦЕНТОВ ПО ПРОСРОЧЕННОЙ ССУДЕ ( ' ||
                  Vmode_Actions.Perc_Delinquency_Send_To || ' ) в справочнике не найден!';
    elsif vMode_Actions.Perc_Gashenie_Control is Null then
      vError_Log := 'Не задан РЕЖИМ ПОГАШЕНИЯ ПРОЦЕНТОВ!';
  elsif not Data_Exists('Ln_S_Mode_Perc_Calc',
                        'CODE = ''' || Vmode_Actions.Perc_Gashenie_Control || '''') then
    Verror_Log := 'Введенный код РЕЖИМА ПОГАШЕНИЯ ПРОЦЕНТОВ ( ' ||
                  Vmode_Actions.Perc_Gashenie_Control || ' ) в справочнике не найден!';
  elsif Vcheck_Orp <> 'ALL' and Vcheck_Orp <> Vmode_Actions.Perc_Gashenie_Control and
        not Ln_Init.Is_Online_Product then
    Verror_Log := 'В вашем банке РЕЖИМА ПОГАШЕНИЯ ПРОЦЕНТОВ может быть установлен только "' ||
                  Upper(Ln_Service.Get_Mode_Perc_Calc_Name(Vcheck_Orp)) || '"!';
    end if;
    --
    if vError_Log is not null then
      vIs_Data_Valid := false;
    Oerror_Log     := 'Ошибка(и) при проверке настроек режимов работы кредита:' || Ut.Ccrlf ||
                      Verror_Log;
    end if;
    return vIs_Data_Valid;
  exception
    when NO_DATA_FOUND then
    Raise_Application_Error(-20000,
                            'Для текущего договора не заведены настройки режимов работы!');
  end Is_Mode_Actions_Valid;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*  Сведения о контракте
*  @iLoan_ID   - уникальный номер договора
*  @oError_Log - текст ошибки
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
Function Is_Loan_Info_Contract
(
  Iloan_Id     in Ln_Card.Loan_Id%type,
  Icredit_Type in Ln_Card.Card_Type%type,
  Oerror_Log   out varchar2
) return boolean is
    vIs_Data_Valid   boolean := true;
    --vError_Log       varchar2(3000);
    vDummy           Pls_Integer;
  begin
    if Icredit_Type is null then 
      null; --Helped with the compiler
    end if;
    --
    if Ln_Setting.Get_Sys_Param('ENABLE_LOAN_INFO_CONTRACT', Setup.Get_Headermfo) = 'N' then
      return true;
    end if;
    --
    select count(*)
      into vDummy
      from Ln_Loan_Info_Contracts
     where Loan_Id = iLoan_ID;
    --
    if vDummy = 0 then
      vIs_Data_Valid := false;
      oError_Log     := 'Не заполнено "Сведения о контракте"!';
    end if;
    return vIs_Data_Valid;
  end Is_Loan_Info_Contract;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Вытаскиваем данные договора
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
Procedure Retrieve_Card_Data_From_Dw
(
  Ievent    in Dw_Event_t,
  Onew_Loan out Ln_Cache.Contrat_Loan_t,
  Oloan     out Ln_Cache.Contrat_Loan_t
) is
    vClaim_Row   Ln_Claim%rowtype;
    vProcess_Id  integer;
    v_Department_id number(10);
  begin
    oNew_Loan.Card.Loan_Id := iEvent.Docs(1).Id;
    oNew_Loan.Card_Additional.Loan_Id := oNew_Loan.Card.Loan_Id;
    if iEvent.Creating_Document() then
    vClaim_Row := Get_Claim_Rowtype(iClaim_Id => Ievent.Params.Get_Number('CLAIM_ID'));
      begin
        vProcess_Id := Dw_Util.Get_Process_Id(i_Doc_Type_Code => 'LNCLAIM', i_Doc_Id => vClaim_Row.Claim_Id);
      exception
        when No_Data_Found then
          Raise_Application_Error(-20000, 'Dw_Process не найдено. process_id = ' || Nvl(to_char(vProcess_Id), 'null'));
    end;
    Dw_Mpi.Attach_Doc_To_Process(i_Process_Id    => Vprocess_Id,
                                 i_Doc_Type_Code => Ievent.Docs(1).Type_Code,
                                 i_Doc_Id        => Onew_Loan.Card.Loan_Id);

      oNew_Loan.Card.Product_Id            := vClaim_Row.Product_Id;
      oNew_Loan.Card.Claim_Id              := vClaim_Row.Claim_Id;
      /*$IF CORE_APP_VERSION.C_CLIENT_UNIQUE $THEN
       --client_uid
       oNew_Loan.Card.Client_Uid            := vClaim_Row.Client_Uid;
       if oNew_Loan.Card.Client_Uid is null then
         Onew_Loan.Card.Client_Uid := Ln_Util.Get_Client_Uid_By_Client_Id(i_Client_Id => Onew_Loan.Card.Client_Id);
         Em.Raise_Error_If(oNew_Loan.Card.Client_Uid is null, 'LNCARD', 'Не найден Client_Uid в Client_Current или не вводили эту полю');
       end if;
      $END*/
      oNew_Loan.Card.Client_Id             := vClaim_Row.Client_Id;
      oNew_Loan.Card.Condition             := Ln_Const.c_Loan_Not_Approved;
      oNew_Loan.Card.Filial_Code           := Setup.Filial_Code;
      --oNew_Loan.Card.Branch_Id             := Setup.Branch_Id;
      oNew_Loan.Card.Local_Code            := Setup.Local_Code;
      oNew_Loan.Card.Locking               := Ln_Const.Loan_Unlocked;
      oNew_Loan.Card.Motive_Revising       := Null;
      oNew_Loan.Card.Date_Revising         := Null;
      oNew_Loan.Card.Err_Message           := Null;
      oNew_Loan.Card.Created_On            := sysdate;
      oNew_Loan.Card.Created_By            := Setup.Get_Employee_Code;
      --
      oNew_Loan.Card_Additional.created_on := sysdate;
      oNew_Loan.Card_Additional.created_by   := Setup.Get_Employee_Code;
    else
    Oloan := Get_Loan_Object(Ievent.Docs(1).Id);
      --
      oNew_Loan.Card.Product_Id       := oLoan.Card.Product_Id;
      oNew_Loan.Card.Claim_Id         := oLoan.Card.Claim_Id;
      oNew_Loan.Card.Client_Id        := oLoan.Card.Client_Id;
      --$IF CORE_APP_VERSION.C_CLIENT_UNIQUE $THEN
      --oNew_Loan.Card.Client_Uid       := oLoan.Card.Client_Uid;
      --$END
      oNew_Loan.Card.Cross_Loan_Id    := oLoan.Card.Cross_Loan_Id;
      oNew_Loan.Card.Condition        := oLoan.Card.Condition;
      oNew_Loan.Card.Filial_Code      := oLoan.Card.Filial_Code;
      --oNew_Loan.Card.Branch_Id        := oLoan.Card.Branch_Id;
      oNew_Loan.Card.Local_Code       := oLoan.Card.Local_Code;
      oNew_Loan.Card.Locking          := oLoan.Card.Locking;
      oNew_Loan.Card.Motive_Revising  := oLoan.Card.Motive_Revising;
      oNew_Loan.Card.Date_Revising    := oLoan.Card.Date_Revising;
      oNew_Loan.Card.Err_Message      := oLoan.Card.Err_Message;
      oNew_Loan.Card.Created_On       := oLoan.Card.Created_On;
      oNew_Loan.Card.Created_By       := oLoan.Card.Created_By;
      --
      oNew_Loan.Card_Additional.created_on  := oLoan.Card.Created_On;
      oNew_Loan.Card_Additional.created_by    := oLoan.Card.Created_By;
    end if;
    oNew_Loan.Card.DATE_MODIFY        := sysdate;
    oNew_Loan.Card.EMP_CODE           := Setup.Get_Employee_Code;
    oNew_Loan.Card.CLIENT_CODE        := iEvent.Params.Get_Varchar2('CLIENT_CODE');
    ----
    if oNew_Loan.Card.Client_Id is null then
      oNew_Loan.Card.Client_Id := Account.Get_Client_ID(iClient_Code => oNew_Loan.Card.Client_Code,
                                                        iFilal_Code  => oNew_Loan.Card.Filial_Code);
    end if;
    oNew_Loan.Card.CLIENT_NAME        := Bank.Get_Client_Name(oNew_Loan.Card.Client_Id);
    oNew_Loan.Card.COMMITTEE_NUMBER   := iEvent.Params.Get_Varchar2('DECISION_NUM');
    oNew_Loan.Card.DATE_COMMITTEE     := iEvent.Params.Get_Date('DECISION_DATE', Ln_Const.MaskDate);
  Onew_Loan.Card.Contract_Desc    := Replace_Unicode(Substr(Ievent.Params.Get_Varchar2('CONTRACT_DESC'),
                                                            0,
                                                            100));
    oNew_Loan.Card.CARD_TYPE          := iEvent.Params.Get_Number('CREDIT_TYPE');
    Begin
      oNew_Loan.Card.CLAIM_NUMBER       := iEvent.Params.Get_Varchar2('CLAIM_NUM');
  exception
    when others then
      Raise_Application_Error(-20000, 'Номер заявки введён неверно!');
    End;
    oNew_Loan.Card.CONTRACT_CODE      := iEvent.Params.Get_Varchar2('CONTRACT_NUM');
    oNew_Loan.Card.LOAN_NUMBER        := iEvent.Params.Get_Number('LOAN_NUM');
    oNew_Loan.Card.CONTRACT_DATE      := iEvent.Params.Get_Date('CONTRACT_DATE', Ln_Const.MaskDate);
    oNew_Loan.Card.OPEN_DATE          := iEvent.Params.Get_Date('OPEN_DATE', Ln_Const.MaskDate);
    oNew_Loan.Card.CLOSE_DATE         := iEvent.Params.Get_Date('CLOSE_DATE', Ln_Const.MaskDate);
    oNew_Loan.Card.CURRENCY           := iEvent.Params.Get_Varchar2('CURRENCY_CODE');
  Onew_Loan.Card.Summ_Loan     := Ievent.Params.Get_Number('AMOUNT') *
                                  Ln_Service.Get_Currency_Scale(Onew_Loan.Card.Currency);
  Onew_Loan.Card.Summinitial   := Ievent.Params.Get_Number('FIRST_PAY') *
                                  Ln_Service.Get_Currency_Scale(Onew_Loan.Card.Currency);
    oNew_Loan.Card.LOAN_TYPE          := iEvent.Params.Get_Varchar2('LOAN_TYPE_CODE');
    
    
    if oNew_Loan.Card.CARD_TYPE = '1' then
      oNew_Loan.Card.LENDING_TYPE       := iEvent.Params.Get_Optional_Varchar2('LENDING_TYPE');
    end if;
    
    oNew_Loan.Card.PURPOSE_LENDING    := iEvent.Params.Get_Optional_Varchar2('PURPOSE_LENDING');
    ---
    oNew_Loan.LOAN_PURPOSE_CODES       := iEvent.Params.Get_Array_Varchar2('PURPOSE_CODE');
    oNew_Loan.LOAN_PURPOSE_INFO       := iEvent.Params.Get_Array_Varchar2('PURPOSE_NAME');
    oNew_Loan.Card.PURPOSE_LOAN       := oNew_Loan.Loan_Purpose_Codes(1);
    oNew_Loan.Card.ECO_SEC            := iEvent.Params.Get_Varchar2('ECO_SEC_CODE');
    oNew_Loan.Card.OKED               := iEvent.Params.Get_Varchar2('OKED_CODE');
    oNew_Loan.Card.OBJECT_LOAN        := substr(iEvent.Params.Get_Varchar2('OBJECT'), 0 , 100);
    oNew_Loan.Card.GUAR_CLASS         := iEvent.Params.Get_Varchar2('GUAR_CLASS');
    oNew_Loan.Card.FORM_DELIVERY      := iEvent.Params.Get_Varchar2('DELIVERY_FORM');
    oNew_Loan.Card.CLASS_QUALITY      := iEvent.Params.Get_Varchar2('CLASS_QUALITY');
    oNew_Loan.Card.FORM_REDEMPTION    := iEvent.Params.Get_Varchar2('REDEMP_FORM');
    oNew_Loan.Card.URGENCY_TYPE       := iEvent.Params.Get_Varchar2('URGENCY_TYPE');
    oNew_Loan.Card.MANAGER_NAME       := replace_unicode( substr(iEvent.Params.Get_Varchar2('MANAGER'), 0 , 50) );
    oNew_Loan.Card.Source_Cred        := null;

    if iEvent.Params.Has('EBRD_SIGN') then
      oNew_Loan.Card.SIGN_EBRD  := iEvent.Params.Get_Number('EBRD_SIGN');
    else
      oNew_Loan.Card.SIGN_EBRD  := 0;
    end if;

    if oNew_Loan.Card.Urgency_Type is Not Null and Data_Exists('V_URGENCY', 'CODE=''' || oNew_Loan.Card.Urgency_Type ||''' and Condition=''A''' ) then
      select s.Urgency_Type into oNew_Loan.Card.Term_Loan_Type
        from V_Urgency s
       where s.Code = oNew_Loan.Card.Urgency_Type
      ;
    end if;

    if oNew_Loan.Card.Card_Type = Ln_Const.Ln_Factoring then -- Договор по факторингу
      oNew_Loan.Card.FC_SUMM := iEvent.params.Get_Number('DISCOUNT') * Ln_Service.Get_Currency_Scale( oNew_Loan.Card.Currency );
      oNew_Loan.Card.FC_DESC := replace_unicode( substr(iEvent.params.Get_Varchar2('FACTORIN_DESC'), 0, 100) );
    end if;

    if oNew_Loan.Card.Card_Type = Ln_Const.Ln_Leasing then -- Лизинг
      oNew_Loan.Card.AGR_NUM_NOTARIAL   := iEvent.Params.Get_Varchar2('NOTARIAL_AGREEM_NUM');
      oNew_Loan.Card.AGR_DATE_NOTARIAL  := iEvent.Params.Get_Date('NOTARIAL_AGREEM_DATE', Ln_Const.MaskDate);
      oNew_Loan.Card.DOC_NOTARIAL_NUM   := iEvent.Params.Get_Varchar2('NOTARIAL_DOC_NUM');
      oNew_Loan.Card.DOC_NOTARIAL_DATE  := iEvent.Params.Get_Date('NOTARIAL_DOC_DATE', Ln_Const.MaskDate);
      oNew_Loan.Card.DOC_GOVER_NUM      := iEvent.Params.Get_Varchar2('GOV_DOC_NUM');
      oNew_Loan.Card.DOC_GOVER_DATE     := iEvent.Params.Get_Date('GOV_DOC_DATE', Ln_Const.MaskDate);
    end if;

    if oNew_Loan.Card.Card_Type in ( Ln_Const.Ln_Credit, Ln_Const.Ln_Leasing ) then  -- Кредитный договор или Лизинг
      oNew_Loan.Card.DAYS_IN_YEAR  := iEvent.params.get_number('DAYS_IN_YEAR');
      oNew_Loan.Card.GRACE_PERIOD  := iEvent.params.get_number('GRACE_PERIOD');
      oNew_Loan.Card.FOUNDERS      := replace_unicode( substr(iEvent.params.Get_Varchar2('FOUNDERS'), 0, 100) );
      oNew_Loan.Card.SIGN_DELIVERY := iEvent.Params.Get_Varchar2('DELIVERY_SIGN');
      oNew_Loan.Card.CLASS_CRED    := iEvent.Params.Get_Varchar2('CLASS_CRED');

      if oNew_Loan.Card.Sign_Delivery = '1' then -- Кредит выдан по решению правительства
        oNew_Loan.Card.GOV_NUM  := iEvent.Params.Get_Varchar2('ORDER_NUM');
        oNew_Loan.Card.GOV_DATE := iEvent.Params.Get_Date('ORDER_DATE', Ln_Const.MaskDate);
      end if;
    end if;

    oNew_Loan.Credit_Source           := iEvent.Params.Get_Array_Varchar2('CREDIT_SOURCE_CODE');
    oNew_Loan.Lending_Source_Code     := iEvent.Params.Get_Array_Varchar2('LENDING_SOURCE_CODE');
    oNew_Loan.Foreign_Organization    := iEvent.Params.Get_Array_Varchar2('FOREIGN_ORGANIZATION_CODE');
    oNew_Loan.Financing_Currency      := iEvent.Params.Get_Array_Varchar2('FINANCING_CURRENCY_CODE');
    oNew_Loan.Financing_Amount        := iEvent.Params.Get_Array_Number('FINANCING_AMOUNT');
    oNew_Loan.Loan_Line_Purpose       := iEvent.Params.Get_Array_Varchar2('LOAN_LINE_PURPOSE');
    oNew_Loan.Under_Guarantee_RUz     := iEvent.Params.Get_Optional_Array_Number('UNDER_GUARANTEE_RUZ');
    --oNew_Loan.Loan_Report_Types       := iEvent.Params.Get_Array_Number('REPORT_TYPE_ID');
    --

    if not oNew_Loan.Under_Guarantee_RUz.exists(1) then
      oNew_Loan.Under_Guarantee_RUz := array_number();
      oNew_Loan.Under_Guarantee_RUz.extend(oNew_Loan.Credit_Source.count);
    end if;
    for i in 1..oNew_Loan.Credit_Source.count loop
      oNew_Loan.Card.Source_Cred := oNew_Loan.Credit_Source(i);
      oNew_Loan.Financing_Amount(i)  := oNew_Loan.Financing_Amount(i) * Ln_Service.Get_Currency_Scale( oNew_Loan.Financing_Currency(i) );
      oNew_Loan.Loan_Line_Purpose(i) := substr(oNew_Loan.Loan_Line_Purpose(i), 0, 100);
      if not oNew_Loan.Under_Guarantee_RUz.exists(i) then
        oNew_Loan.Under_Guarantee_RUz(i) := null;
      end if;
      if oNew_Loan.Card.Source_Cred Not in ('41','46') then
        oNew_Loan.Foreign_Organization(i) := '000';
        oNew_Loan.Under_Guarantee_RUz(i)  := 2;
      end if;
    end loop;
    -- LOAN ADDITIONAL
    -- Ln_Card_additional
    oNew_Loan.Card_Additional.Claim_Guid          := '';
    oNew_Loan.Card_Additional.Contract_Guid       := '';
    -- oNew_Loan.Card_Additional.Borrower_Link       := iEvent.Params.Get_Varchar2('BORROWER_LINK');
    oNew_Loan.Card_Additional.Agreement_Number    := iEvent.Params.Get_Optional_Varchar2('AGREEMENT_NUMBER');
    oNew_Loan.Card_Additional.Agreement_Date      := iEvent.Params.Get_Optional_Date('AGREEMENT_DATE', 'dd.mm.yyyy');
    oNew_Loan.Card_Additional.Director_Id         := iEvent.Params.Get_Optional_Varchar2('DIRECTOR_ID');
    oNew_Loan.Card_Additional.Amount_Uzs          := iEvent.Params.Get_Optional_Number('AMOUNT_UZS');
    oNew_Loan.Card_Additional.Amount_Usd          := iEvent.Params.Get_Optional_Number('AMOUNT_USD');
    oNew_Loan.Card_Additional.Amount_Eur          := iEvent.Params.Get_Optional_Number('AMOUNT_EUR');
    oNew_Loan.Card_Additional.Issue_Mode          := iEvent.Params.Get_Optional_Varchar2('ISSUE_MODE');
    oNew_Loan.Card_Additional.Factoring_Type      := iEvent.Params.Get_Optional_Varchar2('FACTORING_TYPE');
    oNew_Loan.Card_Additional.date_modify         := sysdate;
    oNew_Loan.Card_Additional.modified_by         := setup.Get_Employee_Code;
    ---
    $if core_app_version.c_Header_Code = 9002 $then
    begin
    select t.Department_Id
      into v_Department_Id
      from Ln_s_Blank_Product_Departments t
     where t.product_id = oNew_Loan.Card.Product_Id; 
     if iEvent.Params.Get_Array_Number('DEPARTMENT_ID')(1) is null or
       iEvent.Params.Get_Array_Number('DEPARTMENT_ID')(1) != v_Department_Id then
       Raise_Application_Error(-20000, 'Данный департамент не прикреплен к кредитному продукту'); 
     end if;
     exception when no_data_found then
       null;--Raise_Application_Error(-20000, 'Данный департамент не прикреплен к кредитному продукту');
    end;
    $end
    ---check loan params ln_cache dan keyin globalniyga olib chiqib ketiladi
    Em.Raise_Error_If(oNew_Loan.Card.Loan_Type = '24' and iEvent.Params.Get_Optional_Varchar2('HOUSING_TYPE') is null,
                      'LN', 'Не выбран "Вид приобретаемой недвижимости"');
  end Retrieve_Card_Data_From_Dw;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*    Изменение кода состояния кредита при проведении документа
*  @iLoan_ID - уникальный номер договора
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  procedure Set_Loan_State( iLoan_ID in Ln_Card.Loan_Id%type )
  is
    vLn_State_New         Ln_Card.Condition%type;
    vCard                 Ln_Card%rowtype;
  begin
    vCard := Get_Card_Rowtype( iLoan_Id );

    if vCard.Condition = Ln_Const.c_Loan_Not_Approved then
      return;
    end if;

    vLn_State_New := Get_Loan_State( vCard );

    if vCard.Condition <> vLn_State_New then
      update Ln_Card t
         set t.Condition   = vLn_State_New
           , t.Date_Modify = sysdate
           , t.Emp_Code    = Setup.Get_Employee_Code
       where t.Loan_Id = iLoan_Id;
      Backup_Loan_Card(iLoan_Id);
      --agar kredit zakrit sostoyaniyadan tekushiyga utganda
      if vCard.Condition = Ln_Const.c_Loan_Closed and vLn_State_New != Ln_Const.c_Loan_Closed then
        delete from Ln_Closed_Loans
         where loan_id = iLoan_Id;
      end if;
      --agar kredit yopilayotgan bolsa
      if vLn_State_New = Ln_Const.c_Loan_Closed then
        Ln_Contract.Closed_Acc_Before_Close_Loan(i_Loan_Id => vCard.Loan_Id);
        /*update Ln_Closed_Loans t
           set t.Oper_Day  = Setup.Get_Operday,
               t.Closed_On = sysdate,
               t.Closed_By = Setup.Get_Employee_Code
         where Loan_Id = Iloan_Id;
        if sql%rowcount = 0 then
          insert into Ln_Closed_Loans
          values (iLoan_Id, Setup.Get_Operday, sysdate, Setup.Get_Employee_Code);
        end if;*/
        for r in (select distinct Record_Id
                    from Ln_Loan_Guar
                   where Loan_Id = vCard.Loan_Id)
        loop
          begin
            Pr_Api.Prepare_Del_Record(r.Record_Id, Ln_Const.Task_Code);
          exception
            when others then
              null;
          end;
        end loop;
        --
        /*if ln_init.Is_Overdraft_Product(vCard.Product_Id) then
          Ln_Overdraft.Close_Overdraft(i_Loan_Id => vCard.Loan_Id);
        end if;*/
        --
        if Ln_Product.Product_Group_Id(vCard.Product_Id) = Ln_Const.c_PGid_Overdraft then
          Ln_Overdraft.Update_Limit(i_Loan_Id       => vCard.Loan_Id,
                                    i_Action_Type   => 1,
                                    i_New_Limit_Sum => 0);
        end if;
      end if;
      Log_Doc_Modification( iDoc_Id         => vCard.Loan_Id
                          , iDoc_Type_Code  => 'LNCONTRACT'
                          , iState_Code     => vCard.Condition
                          , iNew_State_Code => vLn_State_New
                          , iDescription    => 'Синхронизация состояния ссуды' );
    end if;
  end Set_Loan_State;
----------------------------------------------------------------------------------
  procedure Check_Agricultural_Claim( iEvent in Dw_Event_t )
  is
  begin
    if iEvent.Params.Get_Varchar2('purposeLoan') in ('020202', '020203') and Is_Agricultural_Loans_Used then
      if (iEvent.Params.Get_Varchar2('currency') <> '000') then
        Ut.Raise_Err('В С/Х кредитах должен ипользоваться только сум (000)');
      end if;
    end if;
  end Check_Agricultural_Claim;
----------------------------------------------------------------------------------
  procedure Retrieve_Claim_Data_From_Dw( iEvent           in Dw_Event_t
                                       , oClaim          out Ln_Claim%rowtype
                                       , oClaim_Appendix out Ln_Claim_Appendix%rowtype
                                       , oClaim_Add      out Ln_Claim_Additional%rowtype )
  is
    vPeriod_Use_In_Months  integer;
    vPeriod_Use_In_Days    integer;
    v_Is_New_Doc           boolean := true;
  begin
    if iEvent.Creating_Document() then
      oClaim.Filial_Code := Setup.Filial_Code;
      --oClaim.Branch_Id   := Setup.Branch_Id;
      oClaim.Local_Code  := Setup.Local_Code;
      oClaim.Status      := Ln_Const.CLAIM_INPUTTED;
      oClaim.Count_Nik   := 0;
      oClaim.Cond_Nik    := Nk_Const.Req_Not_Sent;
      oClaim.Client_Id   := iEvent.Params.Get_Optional_Number('clientId');
    else
      oClaim          := Get_Claim_Rowtype( iEvent.Docs(1).Id );
      oClaim_Appendix := Get_Claim_Appendix_Rowtype( iEvent.Docs(1).Id );
      v_Is_New_Doc    := false;
    end if;
    --
    oClaim.Client_Type            := iEvent.Params.Get_Varchar2('clientType');
    --
    /*$IF CORE_APP_VERSION.C_CLIENT_UNIQUE $THEN
    oClaim.Client_Uid := iEvent.Params.Get_Number('clientUid');
    --
    if oClaim.Client_Uid is null then
      if oClaim.Client_Id is not null then
        oClaim.Client_Uid := Ln_Util.Get_Client_UId_By_Client_Id( i_Client_id => oClaim.Client_Id);
        Em.Raise_Error_If(oClaim.Client_Uid is null, 'LNCAM','Не найден Client_Uid в Client_Current или не вводили эту полю');
      else
        Em.Raise_Error('LNCAM', 'Ункальный ID клиента не запольнено');
      end if;
    end if;
    --
    if oClaim.Client_Id is null then
      Cam_Kernel.Copy_Old_Phys_Client_Temp(i_Client_Uid => oClaim.Client_Uid);
      oClaim.Client_Id := Ln_Util.Get_Client_Id_By_Client_Uid(i_Filial_Code => oClaim.Filial_Code,
                                                              i_Client_Uid  => oClaim.Client_Uid,
                                                              i_Client_Type => oClaim.Client_Type);
      Em.Raise_Error_If(oClaim.Client_Id is null, 'LNCAM','Client_Uid : Copy_Old_Phys_Client_Temp dan so`ng Client_Current.Id topilmadi');
    end if;
    $END*/
    --
    oClaim.Claim_Id               := iEvent.Docs(1).Id;
    oClaim_Appendix.Claim_Id      := iEvent.Docs(1).Id;
    oClaim.Client_Code            := iEvent.Params.Get_Varchar2('clientCode');
    oClaim.Client_Name            := substr(iEvent.Params.Get_Varchar2('clientName'), 0, 100);
    oClaim.Borrower               := iEvent.Params.Get_Varchar2('borrowerCode');
    oClaim.Resident               := iEvent.Params.Get_Number('resident');
    oClaim.INN                    := iEvent.Params.Get_Varchar2('inn');
    oClaim.Credit_Type            := iEvent.Params.Get_Varchar2('creditType');
    oClaim.Claim_Num              := iEvent.Params.Get_Varchar2('claimNum');
    oClaim.Claim_Date             := iEvent.Params.Get_Date('claimDate', Ln_Const.MaskDate);
    oClaim.Product_Id             := iEvent.Params.Get_Number('productId');

    vPeriod_Use_In_Months         := iEvent.Params.Get_Number('periodUseInMonths');
    vPeriod_Use_In_Days           := iEvent.Params.Get_Number('periodUseInDays');

    oClaim.Period_Use             := lpad(vPeriod_Use_In_Months, 3, '0') || '.' || lpad(vPeriod_Use_In_Days, 2, '0');
    oClaim.Currency               := iEvent.Params.Get_Varchar2('currency');
    oClaim.Summ_Claim             := iEvent.Params.Get_Number('summClaim') * Ln_Service.Get_Currency_Scale( oClaim.Currency );
    oClaim.Summinitial            := iEvent.Params.Get_Optional_Number('summInitial') * Ln_Service.Get_Currency_Scale( oClaim.Currency );
    oClaim.Loan_Type              := iEvent.Params.Get_Varchar2('loanType');
    oClaim.Lending_Type           := iEvent.Params.Get_Optional_Varchar2('lendingType');
    oClaim.Purpose_Loan           := iEvent.Params.Get_Array_Varchar2('purposeLoan')(1);
    oClaim.Purpose_Lending        := iEvent.Params.Get_Optional_Varchar2('purposeLending');
    --
    if oClaim.Client_Type in (Ln_Const.Physical_Person, Ln_Const.Individual_Entrepreneur) or
       (oClaim.Client_Type = Ln_Const.Juridical_Person and oClaim.Resident = Ln_Const.Nonresident) then
      null;
    else  
      oClaim.Eco_Sec                := iEvent.Params.Get_Optional_Varchar2('ecoSec');
      oClaim.Oked                   := iEvent.Params.Get_Varchar2('oked');
      oClaim_Appendix.Normative_Act := iEvent.Params.Get_Varchar2('normativeActCode');
    end if;
    --
    if v_Is_New_Doc then
     oClaim.Creator_Code           := iEvent.Params.Get_Optional_Varchar2('creatorCode');
    end if;
    oClaim_Appendix.Loan_Line_Purpose := iEvent.Params.Get_Optional_Varchar2('loanLinePurpose');
    --
    oClaim_Appendix.Mahalla_Code            := iEvent.Params.Get_Optional_Varchar2('mahallaCode');
    --
    if oClaim.Client_Type in ( Ln_Const.JURIDICAL_PERSON, Ln_Const.INDIVIDUAL_ENTREPRENEUR ) then
      oClaim_Appendix.Object_Neoplazm_Sign      := iEvent.Params.Get_Varchar2('objectNeoplazmSign');
      oClaim_Appendix.Enterprise_Classification := iEvent.Params.Get_Varchar2('enterpriseClassification');
      oClaim_Appendix.Jobs_Amount               := iEvent.Params.Get_Number('jobsAmount');
      -- Для онлайн продуктов ненужен
      /*if not Ln_Init.Is_Online_Product then*/
        oClaim_Add.Egrsp_Data           := iEvent.Params.Get_Optional_Date('ergspData', 'dd.mm.yyyy');
        oClaim_Add.Egrsp_Number         := iEvent.Params.Get_Optional_Varchar2('ergspNumber');
      /*end if;*/
    end if;
    --
    if oClaim.Client_Type in ( Ln_Const.PHYSICAL_PERSON, Ln_Const.INDIVIDUAL_ENTREPRENEUR ) /*or ( oClaim.Client_Type = Ln_Const.JURIDICAL_PERSON and oClaim.Resident = Ln_Const.NONRESIDENT )*/
    then
      oClaim_Appendix.Sex               := iEvent.Params.Get_Varchar2('sex');
      oClaim_Appendix.Document_Type     := iEvent.Params.Get_Varchar2('docType');
      oClaim.Doc_Number                 := iEvent.Params.Get_Varchar2('docNumber');
      oClaim_Appendix.Employment_Sign   := iEvent.Params.Get_Varchar2('employmentSign');
      oClaim_Appendix.Region            := iEvent.Params.Get_Varchar2('regionCode');
      oClaim_Appendix.District          := iEvent.Params.Get_Varchar2('districtCode');
      oClaim.Client_Address             := substr(iEvent.Params.Get_Varchar2('clientAddress'), 0, 100);
      oClaim.Doc_Reg_Date               := iEvent.Params.Get_Date('docRegDate', Ln_Const.MaskDate);
      oClaim.Doc_Reg_Place              := substr(iEvent.Params.Get_Varchar2('docRegPlace'), 0, 100);
      oClaim.Date_Of_Birth              := iEvent.Params.Get_Date('dateOfBirth', Ln_Const.MaskDate);
      oClaim_Appendix.Avg_Month_Income  := iEvent.Params.Get_Optional_Number('avg_month_income');
      oClaim_Appendix.Avg_Month_Outcome := iEvent.Params.Get_Optional_Number('avg_month_outcome');
    end if;
    --
    if oClaim.Client_Type in (Ln_Const.PHYSICAL_PERSON, Ln_Const.INDIVIDUAL_ENTREPRENEUR) and oClaim_Appendix.Employment_Sign = Ln_Const.WORKING then
      /*oClaim_Appendix.NINPS_Bank := iEvent.Params.Get_Varchar2('ninpsBankCode');
      oClaim_Appendix.NINPS      := iEvent.Params.Get_Varchar2('ninps');
      oClaim_Appendix.Job_Inn    := iEvent.Params.Get_Optional_Varchar2('jobInn');
      oClaim_Appendix.Job_Name   := substr(iEvent.Params.Get_Optional_Varchar2('jobName'), 0, 100);*/
      --
      oClaim_Appendix.Citizen_Id         := iEvent.Params.Get_Optional_Varchar2('citizenId');
      oClaim_Appendix.Cadas_Num_Resident := iEvent.Params.Get_Optional_Varchar2('cadastralNumOfResidence');
      oClaim_Appendix.Cadas_Regist_Num   := iEvent.Params.Get_Optional_Varchar2('cadastralRegistrationNum');
      --overdraft
    end if;
    if ln_init.Is_Overdraft_Product(oClaim.Product_Id) or ln_init.Is_Beepul_Product(oClaim.Product_Id) or
      Ln_Init.Is_Credit_Card_Product(oClaim.Product_Id) or Ln_Init.Is_Online_Product then
      oClaim_Appendix.Parent_Client_Id          := iEvent.Params.Get_Optional_Number('parentClientId');
      oClaim_Appendix.Parent_Client_Filial_Code := iEvent.Params.Get_Optional_Varchar2('topFilialCode');
      oClaim_Appendix.Parent_Sv_Contract_Id     := iEvent.Params.Get_Optional_Number('parentSvContractId');
      oClaim_Appendix.Sv_Contract_Id            := iEvent.Params.Get_Optional_Number('svContractId');
      oClaim_Appendix.Top_Client_Id             := iEvent.Params.Get_Optional_Number('topClientId');
      oClaim_Appendix.Sv_Main_Contract_Id       := iEvent.Params.Get_Optional_Number('svMainContractId');
      oClaim_Appendix.Card_Number               := iEvent.Params.Get_Optional_Varchar2('cardNumber');
    end if;
    --
    if oClaim.Creator_Code = 'FBCRM' then
      oClaim_Appendix.Parent_Client_Id := iEvent.Params.Get_Optional_Number('parentClientId');
    end if;
    --
    oClaim_Appendix.Mobile_Number             := Ln_Util.Get_Mobile_Number(iEvent.Params.Get_Optional_Varchar2('mobilePhone'));
    oClaim_Appendix.Card_Type                 := iEvent.Params.Get_Optional_Varchar2('cardType');
    if Ln_Cache.Product_Group.Group_Id = Ln_Const.c_PGID_TET_Without_Operation then
      oClaim_Appendix.Card_Type := Ln_Const.c_TET;
    end if;  
    oClaim_Appendix.Family_Status             := iEvent.Params.Get_Optional_Varchar2('familyStatus');
    oClaim_Appendix.Grace_Period              := iEvent.Params.Get_Optional_Number('gracePeriod');
    oClaim_Appendix.Use_Credit_Object         := iEvent.Params.Get_Optional_varchar2('useCreditObject');
    oClaim_Appendix.credit_object_id          := iEvent.Params.Get_Optional_Number('creditObject');
    oClaim_Appendix.credit_object_sum         := iEvent.Params.Get_Optional_Number('creditObjectSum') * 100;
    oClaim_Appendix.Calc_Loan_Sum_Type        :=  Nvl(Ln_Product.Get_Product_Param('CALC_LOAN_SUM_TYPE', oClaim.Product_Id, false), 0);
     -- Индвидуальный предпринимателы
    if oClaim.Client_Type = Ln_Const.Individual_Entrepreneur /*and not Ln_Init.Is_Online_Product*/ then
      oClaim_Add.Activity_Form        := iEvent.Params.Get_optional_Varchar2('activityForm');
      oClaim_Add.Activity_Direction   := iEvent.Params.Get_optional_Varchar2('activityDirection');
    end if;
    -- Юрик клиента
    if oClaim.Client_Type = Ln_Const.Juridical_Person /*and not Ln_Init.Is_Online_Product*/ then
      oClaim_Add.Ownership            := iEvent.Params.Get_optional_Varchar2('ownership');
      oClaim_Add.Emps_Count           := iEvent.Params.Get_optional_Varchar2('empsCount');
      oClaim_Add.Short_Name           := substr(iEvent.Params.Get_optional_Varchar2('shortName'), 1, 50);
      oClaim_Add.Profit               := iEvent.Params.Get_Optional_Number('profit');
      -- oClaim_Add.Small_Business       := iEvent.Params.Get_optional_Varchar2('smallBusiness');
    end if;
    oClaim_Add.a_Net_Id               := iEvent.Params.Get_Optional_Varchar2('aNetId');
    Check_Agricultural_Claim( iEvent );
  end Retrieve_Claim_Data_From_Dw;
----------------------------------------------------------------------------------
 Procedure Validate_Claim_Data
 (
   Iclaim          in Ln_Claim%rowtype,
   Iclaim_Appendix in Ln_Claim_Appendix%rowtype,
   Iclaim_Add      in Ln_Claim_Additional%rowtype,
   Ievent          in Dw_Event_t
 ) is
   Vclaim_Id             integer;
   Ex                    exception;
   Vmessage              varchar2(500);
   Vperiod_Use_In_Months integer;
   Vperiod_Use_In_Days   integer;
   Vorgdirect            Client_Juridical_Current.Organ_Directive_Code%type;
   Vdoc_Num              varchar2(30);
   --
   Is_Employer_Must_Client_Bank boolean;
   Is_Overdraft_Product         boolean;
   --v_Count                      number;
   --v_Pinfls                     Array_Varchar2 := Array_Varchar2();
   --v_Emp_Names                  varchar2(32672);
 begin
   begin
     Vperiod_Use_In_Months := to_number(Substr(Iclaim.Period_Use, 0, 3));
     Vperiod_Use_In_Days   := to_number(Substr(Iclaim.Period_Use, -2));
   exception
     when others then
       Vmessage := 'Некорректно задан период пользования ссудой! Период необходимо задавать в формате МММ.ДД, где МММ и ДД - кол-во месяцев и дней соответственно - числовые значения!';
       raise Ex;
   end;
 
   if Is_Header_Bank then
     Vmessage := 'Операции по созданию-изменению кредитной заявки не должны выполняться на ГО!';
     raise Ex;
   end if;
 
   if Iclaim.Client_Code is null then
     Vmessage := 'Укажите код клиента!';
     raise Ex;
   end if;
 
   if not Data_Exists('LN_V_CUR_FILIAL_CLIENTS', 'CODE=''' || Iclaim.Client_Code || '''') then
     Raise_Application_Error(-20000,
                             'Указанный клиент с кодом ( ' || Iclaim.Client_Code ||
                             ' ) не является клиентом Вашего филиала!');
   end if;
 
   if trim(Iclaim.Client_Name) is null or Length(trim(Iclaim.Client_Name)) < 2 then
     Vmessage := 'Поле Наименование заёмщика должно содержать информацию, отличную от пробела и имеющую длину не менее 2 символов';
     raise Ex;
   end if;
   -- проверка на сушествование client_uid
   /*$IF CORE_APP_VERSION.C_CLIENT_UNIQUE $THEN
   if Iclaim.Client_Uid is null then
     Vmessage := 'Уникальный Ид клиента не запольнено (Client_UID)';
     raise Ex;
   end if;
   if Iclaim.Client_Type = 2 then
     select count(*)
       into v_Count
       from Client_Current t
      where t.Client_Uid = Iclaim.Client_Uid
        and t.Code_Filial = Iclaim.Filial_Code;
   else
     select count(*)
       into v_Count
       from Client_Current t
      where t.Client_Uid = Iclaim.Client_Uid
        and t.Code_Filial = Setup.Get_Headermfo;
   end if;
   if v_Count = 0 then
     Vmessage := 'Введенный ID клиента в данном филиале не совпадает с ID в Клиентах и счетах';
     raise Ex;
   end if;
   --
   \*if iEvent.Event_Type = Dw_Util.c_Et_Edit_Document then
   begin
     select substr( string_Agg('(МФО' || '-' || t.Filial_Code || ') ' ||
                       t.emp_code || '-' ||
                       Employee.Get_Emp_Name(t.emp_code) || chr(10) ||
                       chr(13)), 1, 32672)
       into v_Emp_Names
       from ln_claim t
      where t.status = 0
        and t.client_uid = Iclaim.Client_Uid;
     --
     Vmessage := 'У клиента есть незавершенное заявки. Обратетесь кредитному испектору ' ||
                 v_Emp_Names;
     raise Ex;
   exception
     when no_data_found then
       null;
   end;
   end if;*\
 
   $END*/
   /*if nvl( iClaim.Claim_Num, 0 ) = 0 then
     vMessage := 'Укажите номер кредитной заявки! Номер должен быть больше нуля!';
     raise Ex;
   end if;*/
 
   begin
     select q.Claim_Id
       into Vclaim_Id
       from Ln_Claim q
      where q.Filial_Code = Iclaim.Filial_Code
        and q.Client_Code = Iclaim.Client_Code
        and q.Claim_Num = Iclaim.Claim_Num;
     if Vclaim_Id <> Iclaim.Claim_Id then
       Vmessage := 'Введенный номер заявки уже существует по текущему клиенту! Измените номер заявки';
       raise Ex;
     end if;
   exception
     when No_Data_Found then
       null;
     when Too_Many_Rows then
       Vmessage := 'Введенный номер заявки уже существует по текущему клиенту! Измените номер заявки';
       raise Ex;
   end;
 
   if Iclaim.Client_Type is null then
     Vmessage := 'Укажите тип субъекта!';
     raise Ex;
   end if;
 
   if not Data_Exists('V_SUBJECT_TYPE', 'Code=''' || Iclaim.Client_Type || ''' and Condition=''A''') then
     Vmessage := 'Введенный код типа субъекта ' || Iclaim.Client_Type ||
                 ' в справочнике не найден!';
     raise Ex;
   end if;
 
   /*if Iclaim.Borrower is null then
     Vmessage := 'Укажите Тип Заёмщика!';
     raise Ex;
   end if;
 
   if Iclaim.Client_Type = '2' and Substr(Iclaim.Borrower, 1, 2) <> '08' then
     Vmessage := 'Для физических лиц неправильно указан код типа заёмщика.';
     raise Ex;
   end if;
 
   if not Data_Exists('LN_V_BORROWER', 'ALL_CODE=''' || Iclaim.Borrower || ''' and Condition=''A''') then
     Vmessage := 'Введенный код типа заёмщика ' || Iclaim.Borrower || ' в справочнике не найден!';
     raise Ex;
   end if;
 
   if Substr(Iclaim.Borrower, 1, 2) = '08' and Iclaim.Client_Type <> Nk_Const.Physical_Person then
     Vmessage := 'Типу заёмщика "08-Физические лица" должен соответствовать тип субъекта "Физическое лицо"';
     raise Ex;
   end if;
 
   if Substr(Iclaim.Borrower, 1, 2) = '11' and
      Iclaim.Client_Type <> Nk_Const.Individual_Entrepreneur then
     Vmessage := 'Типу заёмщика "11-Индивидуальные предприниматели" должен соответствовать тип субъекта "Индивидуальный предприниматель"';
     raise Ex;
   end if;
 
   if Substr(Iclaim.Borrower, 1, 2) not in ('08', '11') and
      Iclaim.Client_Type <> Nk_Const.Juridical_Person then
     Vmessage := 'Указанному типу заёмщика должен соответствовать тип субъекта "Юридическое лицо"';
     raise Ex;
   end if;*/
 
   if Iclaim.Resident is null then
     Vmessage := 'Укажите резидентность клиента!';
     raise Ex;
   end if;
 
   if not Data_Exists('V_REZ_CL', 'Code=''' || Iclaim.Resident || ''' and Condition=''A''') then
     Vmessage := 'Введенный код резидентности ' || Iclaim.Resident || ' в справочнике не найден!';
     raise Ex;
   end if;
 
   if Iclaim.Inn is null and Iclaim.Client_Type = 1 then
     Vmessage := 'Не указан ИНН заёмщика! Если у физ. лица отсутствует ИНН, задайте "000000000"';
     raise Ex;
   end if;
 
   if Ln_Setting.Get_Sys_Param('CHECK_CLAIM_INN') = 'Y' and Iclaim.Client_Type = 1 then
     if Checks.Check_Inn(Iclaim.Inn) = -1 then
       Ut.Raise_Err('Указан некорректный код ИНН ' || Iclaim.Inn || '.');
     end if;
     if mod(to_number(Iclaim.Inn), 111111111) = 0 then
       Ut.Raise_Err('Указан некорректный код ИНН ' || Iclaim.Inn || '.');
     end if;
   end if;
 
   if Iclaim.Credit_Type is null then
     Vmessage := 'Укажите тип документа!';
     raise Ex;
   end if;
 
   if not Data_Exists('Ln_V_Claim_Type', 'CODE=''' || Iclaim.Credit_Type || '''') then
     Vmessage := 'Указан несуществующий тип документа "' || Iclaim.Credit_Type || '"!';
     raise Ex;
   end if;
 
   if Iclaim.Claim_Date is null then
     Vmessage := 'Укажите дату кредитной заявки!';
     raise Ex;
   end if;
 
   if Iclaim.Claim_Date > Setup.Get_Operday then
     Vmessage := 'Дата кредитной заявки должна быть меньше или равна текущей дате!';
     raise Ex;
   end if;
 
   if Vperiod_Use_In_Months = 0 and Vperiod_Use_In_Days = 0 then
     Vmessage := 'Неверно указан период пользования кредитом! Период должен быть больше нуля!';
     raise Ex;
   end if;
 
   if Nvl(Iclaim.Summ_Claim, 0) = 0 then
     Vmessage := 'Сумма кредита должна быть больше нуля!';
     raise Ex;
   end if;
 
   if Iclaim.Currency is null then
     Vmessage := 'Укажите валюту кредита!';
     raise Ex;
   end if;
 
   if not Data_Exists('V_Currency', 'Code=''' || Iclaim.Currency || ''' and Condition=''A''') then
     Vmessage := 'Введенный код валюты ' || Iclaim.Currency || ' в справочнике не найден!';
     raise Ex;
   end if;
 
   if Iclaim.Loan_Type is null then
     Vmessage := 'Укажите вид кредитования (№ 031)';
     raise Ex;
   end if;
   if not
       Data_Exists('LN_V_CREDIT_TYPES', 'CODE=''' || Iclaim.Loan_Type || ''' and Condition=''A''') then
     Vmessage := 'Введенный код вида кредитования ' || Iclaim.Loan_Type ||
                 ' в справочнике не найден!';
     raise Ex;
   end if;
 
   if Iclaim.Lending_Type is null and Iclaim.Credit_Type = '1' then
     Vmessage := 'Укажите вид кредитования (№ 110)';
     raise Ex;
   end if;
 
   if not
       Data_Exists('V_TYPE_LENDINGS', 'CODE=''' || Iclaim.Lending_Type || ''' and Condition=''A''') and
      Iclaim.Credit_Type = '1' then
     Vmessage := 'Введенный код вида кредитования (№ 110) ' || Iclaim.Lending_Type ||
                 ' в справочнике не найден!';
     raise Ex;
   end if;
 
   if iClaim.Credit_Type = Ln_Const.Ln_Credit and Iclaim.Purpose_Loan is null then
     Vmessage := 'Укажите цель кредита!';
     raise Ex;
   end if;
   if iClaim.Credit_Type = Ln_Const.Ln_Credit and not Data_Exists('LN_V_PURPOSE_CIPHER',
                      'Code=''' || Iclaim.Purpose_Loan || ''' and Condition=''A''') then
     Vmessage := 'Введенный код цели кредита ' || Iclaim.Purpose_Loan ||
                 ' в справочнике не найден!';
     raise Ex;
   end if;
 
   if Iclaim.Purpose_Lending is null and Iclaim.Credit_Type = '1' then
     Vmessage := 'Укажите цель кредита (№ 112)';
     raise Ex;
   end if;
   if not Data_Exists('LN_V_LENDING_PURPOSES', 'Code=''' || Iclaim.Purpose_Lending || '''') and
      Iclaim.Credit_Type = '1' then
     Vmessage := 'Введенный код цели кредита (№ 112) ' || Iclaim.Purpose_Lending ||
                 ' в справочнике не найден!';
     raise Ex;
   end if;
   /*if Iclaim.Client_Type = Ln_Const.Juridical_Person and iclaim.resident = ln_const.Resident then 
     if Iclaim.Eco_Sec is null then
       Vmessage := 'Укажите экономический сектор!';
       raise Ex;
     end if;
     -- 
     if not Data_Exists('LN_V_SECTOR', 'CODE=''' || Iclaim.Eco_Sec || ''' and Condition=''A'' and Kod_Class <> ''000''') then
       Vmessage := 'Введенный код экономического сектора ' || Iclaim.Eco_Sec || ' в справочнике не найден!';
       raise Ex;
     end if;
   end if;
   if Iclaim_Appendix.Normative_Act is null then
     Vmessage := 'Укажите код нормативно-правового акта!';
     raise Ex;
   end if;
 
   if not Data_Exists('V_NORMATIVE_LEGAL_ACT',
                      'CODE=''' || Iclaim_Appendix.Normative_Act || ''' and Condition=''A''') then
     Vmessage := 'Введенный код нормативно-правового акта ' || Iclaim_Appendix.Normative_Act ||
                 ' в справочнике не найден!';
     raise Ex;
   end if;*/
 
   --- данные из бизнес-плана заявителя
   if Iclaim.Client_Type in (Ln_Const.Juridical_Person, Ln_Const.Individual_Entrepreneur) then
     if Iclaim_Appendix.Jobs_Amount is null then
       Vmessage := 'Не указана число создаваемых рабоч. мест';
       raise Ex;
     end if;
   
     if Iclaim_Appendix.Object_Neoplazm_Sign is null then
       Vmessage := 'Укажите признак новообразования объекта!';
       raise Ex;
     end if;
   
     if Iclaim_Appendix.Object_Neoplazm_Sign not in (Ln_Const.Existing_Object, Ln_Const.New_Object) then
       Vmessage := 'Указан несуществующий признак новообразования объекта "' ||
                   Iclaim_Appendix.Object_Neoplazm_Sign || '"!';
       raise Ex;
     end if;
   
     if Iclaim_Appendix.Enterprise_Classification is null then
       Vmessage := 'Укажите классификатор предприятия!';
       raise Ex;
     end if;
   
     if Iclaim_Appendix.Enterprise_Classification not in
        (Ln_Const.Micro_Enterprise, Ln_Const.Small_Enterprise, Ln_Const.Large_Enterprise) then
       Vmessage := 'Указан несуществующий код классификатора предприятия "' ||
                   Iclaim_Appendix.Enterprise_Classification || '"!';
       raise Ex;
     end if;
     --
     select Organ_Directive_Code
       into Vorgdirect
       from Client_Juridical_Current
      where Id = Iclaim.Client_Id;
     if (Iclaim.Client_Type = Ln_Const.Individual_Entrepreneur and
        Vorgdirect not in ('90644', '90712')) or (Iclaim.Client_Type = Ln_Const.Juridical_Person and
        Vorgdirect in ('90716', '90644', '90712')) then
       Raise_Application_Error(-20000,
                               'Для юридических лиц неправильно указан код вышестоящей организации');
     end if;
   end if;
 
   -- доп данные по заемщику
   if Iclaim.Client_Type in (Ln_Const.Physical_Person, Ln_Const.Individual_Entrepreneur) /*or ( iClaim.Client_Type = Ln_Const.JURIDICAL_PERSON and iClaim.Resident = Ln_Const.NONRESIDENT )*/
    then
     if Iclaim_Appendix.Sex is null then
       Vmessage := 'Укажите пол заёмщика!';
       raise Ex;
     end if;
   
     if not Data_Exists('V_SUBJECT_SEXUAL_IDENTITY',
                        'CODE=''' || Iclaim_Appendix.Sex || ''' and Condition=''A''') then
       Vmessage := 'Введенный код половой принадлежности заёмщика ' || Iclaim_Appendix.Sex ||
                   ' в справочнике не найден!';
       raise Ex;
     end if;
   
     if Iclaim.Date_Of_Birth is not null and
        Extract(year from(sysdate - Iclaim.Date_Of_Birth) year to month) <
        Nk_Const.Borrower_Min_Age_In_Years then
       Vmessage := 'Дата рождения заёмщика должна быть не меньше ' ||
                   Nk_Const.Borrower_Min_Age_In_Years || ' лет от текущей даты!';
       raise Ex;
     end if;
   
     if Iclaim_Appendix.Document_Type is null then
       Vmessage := 'Укажите тип удостоверяющего документа!';
       raise Ex;
     end if;
   
     if not Data_Exists('V_VERIFYING_DOCUMENT_TYPE',
                        'CODE=''' || Iclaim_Appendix.Document_Type || ''' and Condition=''A''') then
       Vmessage := 'Введенный тип удостоверяющего документа ' || Iclaim_Appendix.Document_Type ||
                   ' в справочнике не найден!';
       raise Ex;
     end if;
     --agar 4 - Паспорт иностранного гражд va 5-Вид на жительство tekshirilmasin
     if Iclaim_Appendix.Document_Type in (1, 6, 7) and not Ln_Service.Check_Passport(Iclaim.Doc_Number) then
       Vmessage := 'Не указаны серия и номер удостоверяющего документ либо указаны неверно! Корректный формат AZ1234567';
       raise Ex;
     end if;
   
     if trim(Iclaim.Client_Address) is null or Length(trim(Iclaim.Client_Address)) < 2 then
       Vmessage := 'Поле "Почтовый адрес" должно содержать информацию, отличную от пробела и имеющую длину не менее 2 позиций!';
       raise Ex;
     end if;
   
     if Iclaim_Appendix.Region is null then
       Vmessage := 'Укажите регион проживания заёмщика!';
       raise Ex;
     end if;
   
     if not Data_Exists('V_Region', 'Code=''' || Iclaim_Appendix.Region || ''' and Condition=''A''') then
       Vmessage := 'Введенный код регион проживания заёмщика ' || Iclaim_Appendix.Region ||
                   ' в справочнике не найден!';
       raise Ex;
     end if;
   
     if Iclaim_Appendix.District is null then
       Vmessage := 'Укажите район проживания заёмщика!';
       raise Ex;
     end if;
   
     if not
         Data_Exists('V_District', 'Code=''' || Iclaim_Appendix.District || ''' and Condition=''A''') then
       Vmessage := 'Введенный код района проживания заёмщика ' || Iclaim_Appendix.District ||
                   ' в справочнике не найден!';
       raise Ex;
     end if;
     --
     if not Ln_Init.Is_Online_Product and Iclaim_Appendix.Mahalla_Code is not null and
        not
         Data_Exists('ln_s_mahalla',
                     'mahalla_code=''' || Iclaim_Appendix.Mahalla_Code || ''' and Condition=''A''') then
       Vmessage := 'Введенный код махаллы проживания заёмщика ' || Iclaim_Appendix.Mahalla_Code ||
                   ' в справочнике не найден!';
       raise Ex;
     end if;
     if not Ln_Init.Is_Online_Product and Iclaim_Appendix.Mahalla_Code is null and
        Setup.Get_Headermfo = '09005' then
       Vmessage := 'Не введен код махалле проживания';
       raise Ex;
     end if;
     
     /*if Iclaim.Client_Type in (Ln_Const.Juridical_Person, Ln_Const.Individual_Entrepreneur) then
       if Iclaim_Appendix.Employment_Sign is null then
         Vmessage := 'Укажите признак занятости заёмщика!';
         raise Ex;
       end if;
     
       if Iclaim_Appendix.Employment_Sign not in (Ln_Const.Working, Ln_Const.Unemployed) then
         Vmessage := 'Указан несуществующий признак занятости заёмщика "' ||
                     Iclaim_Appendix.Employment_Sign || '"!';
         raise Ex;
       end if;
     end if;*/
   
     if Iclaim.Doc_Reg_Date is null then
       Vmessage := 'Укажите дату выдачи удостоверяющего документа!';
       raise Ex;
     end if;
   
     if Iclaim.Doc_Reg_Date > Setup.Get_Operday then
       Vmessage := 'Дата выдачи удостоверяющего документа должна быть меньше либо равна текущей дате!';
       raise Ex;
     end if;
   
     if Iclaim.Client_Type in (Ln_Const.Physical_Person, Ln_Const.Individual_Entrepreneur) then
       if Iclaim.Date_Of_Birth is null then
         Vmessage := 'Укажите дату рождения заёмщика!';
         raise Ex;
       end if;
     
       if trim(Iclaim.Doc_Reg_Place) is null or Length(trim(Iclaim.Doc_Reg_Place)) < 2 then
         Vmessage := 'Поле "Кем выдан" должно содержать информацию, отличную от пробела и имеющую длину не менее 2 позиций!!';
         raise Ex;
       end if;
     end if;
   end if;
 
   -- проверка информации из пенсионного фонда
   /*if Iclaim.Client_Type in (Ln_Const.Physical_Person, Ln_Const.Individual_Entrepreneur) and
      Iclaim_Appendix.Employment_Sign = Ln_Const.Working then
     if Iclaim_Appendix.Ninps_Bank is null then
       Vmessage := 'Укажите банк, где открыт счет НИНПС!';
       raise Ex;
     
     elsif not Data_Exists('V_Bank',
                           'CODE=''' || Iclaim_Appendix.Ninps_Bank ||
                           ''' and Condition=''A'' and Active = ''A''') then
       Vmessage := 'Введенный код банка ' || Iclaim_Appendix.Ninps_Bank ||
                   ', где открыт счет НИНПС, в справочнике не найден!';
       raise Ex;
     
     elsif Iclaim_Appendix.Ninps is null then
       Vmessage := 'Укажите НИНПС заемщика!';
       raise Ex;
     
       /*elsif iClaim_Appendix.Job_Inn is Null and iClaim.Client_Type = 1 then
         vMessage := 'Укажите ИНН организации заемщика!';
         raise Ex;
       
       elsif iClaim_Appendix.Job_Inn = iClaim.INN and iClaim.Client_Type = 1 then
         vMessage := 'Неправильно указан ИНН организации, где работает заёмщик.';
         raise Ex;
       
       elsif trim(iClaim_Appendix.Job_Name) is Null or length(trim(iClaim_Appendix.Job_Name)) < 2 then
         vMessage := 'Поле "Наименование организации, в которой работает заемщик" должно содержать информацию, отличную от пробела и имеющую длину не менее 2 позиций!';
         raise Ex;* /
     end if;
     --
     if Iclaim_Appendix.Job_Inn is null and (Checks.Check_Inn(Iclaim_Appendix.Job_Inn) = -1 or
        mod(to_number(Iclaim_Appendix.Job_Inn), 111111111) = 0) then
       Vmessage := 'Указан некорректный код ИНН (' || Iclaim_Appendix.Job_Inn ||
                   ') организации, где работает заёмщик.';
       raise Ex;
     end if;
     -- ИНПС (чёрный список)
     if Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List('NINPS_CONTROL',
                                                                      Setup.Get_Headermfo),
                                  Iclaim_Appendix.Ninps) then
       Vmessage := 'Запрешено! Введенный НИНПС  находиться в списке запрешенных, обратитесь в ГО';
       raise Ex;
     end if;
     --
     if Iclaim_Appendix.Citizen_Id is null then
       Vmessage := 'Укажите "ПИНФЛ" заемщика!';
       raise Ex;
     end if;
   end if;*/
 
   -- логические контроли
   if Iclaim.Credit_Type = Ln_Const.Ln_Leasing and Iclaim.Loan_Type <> '26' then
     Vmessage := 'Договору по лизингу в качестве вида кредитования может быть указан только [26]Лизинг';
     raise Ex;
   end if;
 
   if Iclaim.Loan_Type = '28' and Iclaim.Credit_Type <> Ln_Const.Ln_Factoring then
     Vmessage := 'Договору по факторингу в качестве вида кредитования может быть указан только [28]Факторинг';
     raise Ex;
   end if;
 
   if Iclaim.Credit_Type = Ln_Const.Ln_Credit and Iclaim.Loan_Type in ('26', '28') then
     Vmessage := 'Кредитному договору в качестве вида кредитования не могут быть указаны только [26]Лизинг и [28]Факторинг';
     raise Ex;
   end if;
 
   if Substr(Iclaim.Purpose_Loan, 0, 2) = '05' and
      Iclaim.Client_Type = Ln_Const.Individual_Entrepreneur then
     Vmessage := 'Индивидуальным предпринимателям не может быть выдан кредит по отдельным решениям правительства (поле "Цель кредита")';
     raise Ex;
   end if;
 
   if Iclaim.Client_Type = Ln_Const.Physical_Person and Substr(Iclaim.Purpose_Loan, 0, 2) <> '06' then
     Vmessage := 'Физ. лицам может быть выдан только кредит, выдаваемый населению (поле "Цель кредита")';
     raise Ex;
   end if;
 
   if Substr(Iclaim.Purpose_Loan, 0, 2) = '06' and Iclaim.Client_Type <> Ln_Const.Physical_Person then
     Vmessage := 'Только физ. лицам может быть выдан кредит, выдаваемый населению (поле "Цель кредита")';
     raise Ex;
   end if;
 
   if Iclaim.Loan_Type in ('54', '30') and Iclaim.Client_Type <> Ln_Const.Physical_Person then
     Vmessage := '[54]Овердрафт по пластиковым карточкам физ. лиц, [30]Потребительский кредит (поле "Вид кредитования") может выдаваться только физ. лицам!';
     raise Ex;
   end if;
 
   if Iclaim.Loan_Type = '22' and (Iclaim.Client_Type <> Ln_Const.Juridical_Person or
      Substr(Iclaim.Borrower, 0, 2) not in ('06', '07')) then
     Vmessage := '[22]Межбанковский кредит (поле "Вид кредитования") может выдаваться только юр. лицам с типом клиента "Центральный банк" и "Коммерческие банки"!';
     raise Ex;
   end if;
   --if iClaim.Credit_Type = Ln_Const.Ln_Factoring and vPeriod_Use_In_Months * 30 + vPeriod_Use_In_Days > Nk_Const.FACTORING_PERIOD_USE_IN_DAYS then
   if Iclaim.Credit_Type = Ln_Const.Ln_Factoring and
      Add_Months(Iclaim.Claim_Date, Vperiod_Use_In_Months) + Vperiod_Use_In_Days >
      Iclaim.Claim_Date + Nk_Const.Factoring_Period_Use_In_Days then
     Vmessage := 'Срок пользования для факторинга не должен превышать ' ||
                 Nk_Const.Factoring_Period_Use_In_Days || ' дней!';
     raise Ex;
   end if;
   if Iclaim_Appendix.Mobile_Number is null then
     Vmessage := 'Не введен номер мобильного телефона в "Клиентах и счетах"';
     raise Ex;
   end if;
   --
   Is_Overdraft_Product := Ln_Init.Is_Overdraft_Product(Iclaim.Product_Id);
   if Is_Overdraft_Product or Ln_Init.Is_Credit_Card_Product(Iclaim.Product_Id) then
     Is_Employer_Must_Client_Bank := Ln_Product.Is_Employer_Must_Client_Bank = 'Y';
     if Is_Employer_Must_Client_Bank and
        Iclaim_Appendix.Parent_Client_Filial_Code = Iclaim.Filial_Code then
       if Iclaim_Appendix.Parent_Client_Id is null then
         Vmessage := 'Не введен ID клиента работодателя';
         raise Ex;
       elsif Iclaim_Appendix.Parent_Client_Id is not null then
         if not Ln_Overdraft.Is_Exists_Contract(Iclaim_Appendix.Parent_Client_Id,
                                                Iclaim.Client_Id,
                                                Iclaim_Appendix.Card_Type) then
           Vmessage := 'Неправильно введен код клиента работодателя. (ID parent : ' ||
                       Iclaim_Appendix.Parent_Client_Id || ' ID client : ' || Iclaim.Client_Id ||
                       ' Тип карта : ' || Iclaim_Appendix.Card_Type || ')';
           raise Ex;
         end if;
       end if;
     elsif Is_Employer_Must_Client_Bank then
       --if iClaim_Appendix.Parent_Client_Filial_Code <> iClaim.Filial_Code then
       --demak overdraft olayotkan klient kartochkasi iClaim_Appendix.Parent_Client_Filial_Code
       -- filialda registratsiyadan utgan
       begin
         select t.Passport_Serial || t.Passport_Number
           into Vdoc_Num
           from Client_Physical_Current t
          where Id = Iclaim_Appendix.Top_Client_Id;
       exception
         when No_Data_Found then
           Vmessage := 'Неправильно указаны паспортные данные в "Клиентах и счетах"';
           raise Ex;
       end;
       if Vdoc_Num <> Iclaim.Doc_Number then
         Vmessage := 'Не соответсвует серия и номер паспорта клиента текущего филиала с серией и номером паспорта в филиале работодателя';
         raise Ex;
       end if;
       --
       if not Ln_Overdraft.Is_Exists_Contract(Iclaim_Appendix.Parent_Client_Id,
                                              Iclaim_Appendix.Top_Client_Id,
                                              Iclaim_Appendix.Card_Type) then
         Vmessage := 'Неправильно введен код клиента работодателя. (ID parent : ' ||
                     Iclaim_Appendix.Parent_Client_Id || ' ID client : ' ||
                     Iclaim_Appendix.Top_Client_Id || ' Тип карта : ' || Iclaim_Appendix.Card_Type || ')';
         raise Ex;
       end if;
     end if;
     if Iclaim_Appendix.Sv_Contract_Id = Iclaim_Appendix.Sv_Main_Contract_Id then
       Vmessage := 'Договора с клиентами SV и Договора с клиентами SV (зарплатный) не должна быть одинаковый';
       raise Ex;
     end if;
   end if;
   -- Проверки контокоррентых кредитов
   if Ln_Product.Product_Group_Id(Iclaim.Product_Id) = Ln_Const.c_Pgid_Conct then
     Ln_Util.Check_Conct_Credit(i_Client_Code => Iclaim.Client_Code);
   end if;
   ---Проверка пластиковую карту для Овердрафта
   if Ievent.Creating_Document and Is_Overdraft_Product and
      (Setup.Get_Headermfo <> '09048' or Iclaim.Product_Id <> 165) then
     --
     Ln_Init.Set_Product(i_Product_Id => Iclaim.Product_Id);
     Ln_Util.Check_Overdraft(i_Client_Id   => Iclaim.Client_Id,
                             i_Card_Type   => Iclaim_Appendix.Card_Type,
                             i_Card_Number => Iclaim_Appendix.Card_Number,
                             i_Period_Use  => Vperiod_Use_In_Months);
   end if;
   ---Проверка пластиковую карту для Продкта
   /*if iEvent.Creating_Document and not Is_Overdraft_Product and (Setup.Get_Headermfo <> '09048' Or iClaim.Product_Id <> 165) Then
     --
     ln_Init.Set_Product(i_Product_Id => iClaim.Product_Id);
     Ln_Util.Check_Product(i_Client_Id => iClaim.Client_Id,
                           i_Card_Type => iClaim_Appendix.Card_Type,
                           i_Card_Number => iClaim_Appendix.Card_Number,
                           i_Period_Use  => vPeriod_Use_In_Months);
   end if;*/
   if Length(Iclaim_Add.Short_Name) > 100 then
     Vmessage := 'Длина поля Сокращенное наименование не должна быть больше 100 символов';
     raise Ex;
   end if;
   if Iclaim.Client_Type = Ln_Const.Juridical_Person and Iclaim_Add.Emps_Count is null then
     Vmessage := 'Не указана Количество сотрудников!';
     raise Ex;
   end if;
   if Iclaim.Client_Type = Ln_Const.Physical_Person and
      Ievent.Params.Get_Optional_Array_Varchar2('INCOME_TYPE') is null then
     Vmessage := 'Не заполнено обязательное поле "Среднемесячный доход" для Физ. лиц';
     raise Ex;
   end if;
 exception
   when Ex then
     Raise_Application_Error(-20000, Vmessage);
 end Validate_Claim_Data;
----------------------------------------------------------------------------------
  procedure Check_Claim_Data_4_Editing( iNew_Claim          in Ln_Claim%rowtype
                                      , iNew_Claim_Appendix in Ln_Claim_Appendix%rowtype)
  is
    vClaim           Ln_Claim%rowtype;
    vClaim_Appendix  Ln_Claim_Appendix%rowtype;
    vHas_Contract    boolean := false;
    vLoan_Id         integer;
    Ex               exception;
    vMessage         varchar2(500);
  begin
    vClaim          := Get_Claim_Rowtype( iNew_Claim.Claim_Id );
    vClaim_Appendix := Get_Claim_Appendix_Rowtype( vClaim.Claim_Id );

    if vClaim.Status = Ln_Const.CLAIM_REJECTED then
      vMessage := 'Данные заявок в состоянии "Отклонен" изменению не подлежат!';
      raise Ex;
    end if;

    begin
      vLoan_Id := Dw_Util.Get_Doc_Id( i_Doc_Type_Code        => 'LNCLAIM'
                                    , i_Doc_Id               => vClaim.Claim_Id
                                    , i_Obtain_Doc_Type_Code => 'LNCONTRACT');
    exception
      when NO_DATA_FOUND then
        vLoan_Id := 0;
    end;
    vHas_Contract := vLoan_Id > 0;
    --
    if vClaim.Client_Code <> iNew_Claim.Client_Code then
      vMessage := 'Код клиента изменению не подлежит!';
      raise Ex;
    end if;

    if vClaim.Claim_Num <> iNew_Claim.Claim_Num then
      vMessage := 'Номер заявки изменению не подлежит!';
      raise Ex;
    end if;

    if vClaim.Claim_Date <> iNew_Claim.Claim_Date then
      vMessage := 'Дата заявки изменению не подлежит!';
      raise Ex;
    end if;

    if vHas_Contract then
      if vClaim.Credit_Type <> iNew_Claim.Credit_Type then
        vMessage := 'Тип документа изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Eco_Sec <> iNew_Claim.Eco_Sec then
        vMessage := 'Экономический сектор изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Loan_Type <> iNew_Claim.Loan_Type then
        vMessage := 'Вид кредитования изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Purpose_Loan <> iNew_Claim.Purpose_Loan then
        vMessage := 'Цель кредита изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Summ_Claim <> iNew_Claim.Summ_Claim then
        vMessage := 'Сумма кредита изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Period_Use <> iNew_Claim.Period_Use then
        vMessage := 'Период пользования кредитом изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Client_Type <> iNew_Claim.Client_Type then
        vMessage := 'Тип субъекта изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Client_Address <> iNew_Claim.Client_Address then
        vMessage := 'Почтовый адрес заёмщика изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Doc_Reg_Date <> iNew_Claim.Doc_Reg_Date then
        vMessage := 'Дата выдачи удостоверяющего документа заёмщика изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Doc_Reg_Place <> iNew_Claim.Doc_Reg_Place then
        vMessage := 'Место выдачи удостоверяющего документа изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim.Date_Of_Birth <> iNew_Claim.Date_Of_Birth then
        vMessage := 'Дата рождения заёмщика изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Normative_Act is Not Null and vClaim_Appendix.Normative_Act <> iNew_Claim_Appendix.Normative_Act then
        vMessage := 'Нормативно-правовой акт изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Object_Neoplazm_Sign is Not Null and vClaim_Appendix.Object_Neoplazm_Sign <> iNew_Claim_Appendix.Object_Neoplazm_Sign then
        vMessage := 'Признак новообразования нового объекта изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Enterprise_Classification is Not Null and vClaim_Appendix.Enterprise_Classification <> iNew_Claim_Appendix.Enterprise_Classification then
        vMessage := 'Классификатор предприятия изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Jobs_Amount is Not Null and vClaim_Appendix.Jobs_Amount <> iNew_Claim_Appendix.Jobs_Amount then
        vMessage := 'Количество рабочих мест изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Sex is Not Null and vClaim_Appendix.Sex <> iNew_Claim_Appendix.Sex then
        vMessage := 'Половая принадлежность заёмщика изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Document_Type is Not Null and vClaim_Appendix.Document_Type <> iNew_Claim_Appendix.Document_Type then
        vMessage := 'Тип удостоверяющего документа заёмщика изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Employment_Sign is Not Null and vClaim_Appendix.Employment_Sign <> iNew_Claim_Appendix.Employment_Sign then
        vMessage := 'Признак занятости заёмщика изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.Region is Not Null and vClaim_Appendix.Region <> iNew_Claim_Appendix.Region then
        vMessage := 'Область проживания заёмщика изменению не подлежит!';
        raise Ex;
      end if;

      if vClaim_Appendix.District is Not Null and vClaim_Appendix.District <> iNew_Claim_Appendix.District then
        vMessage := 'Район проживания заёмщика изменению не подлежит!';
        raise Ex;
      end if;
    end if;

  exception
    when Ex then
      Raise_Application_Error(-20000, vMessage);
  end Check_Claim_Data_4_Editing;
----------------------------------------------------------------------------------
-- Кредит дастлабки берилаётганда ушбу счётлар бириктирил-
-- ганлигини ва остатка борлигини текшириши керак
  Function Is_Client_Acc_Collateral (
    i_Loan_Id     Ln_Card.Loan_Id%type,
    i_Client_Code Ln_Card.Client_Code%type,
    o_Message  out varchar2
  ) return boolean is
    v_Saldo        number := 0;
    v_Saldo_Kontr  number := 0;
    v_Count        Pls_Integer;
    --vMessage              varchar2(3000);
    v_Clients             Array_Varchar2;
    v_Param_Value         Ln_Params.Value%type;
    --v_Param_Name          Ln_Param_Defs.Name%type;
  begin
    --
    v_Param_Value := Ln_Setting.Get_Sys_Param('CHECK_CLIENT_HAS_ACCOUNT_PROVIDING_COLLATERAL');
    case v_Param_Value
      when 'N' then
        return true;
      when 'Y_CLIENTS_ONLY' then
        v_Clients := Ln_Setting.Get_Sys_Param_Value_List('CLIENT_LIST_HAS_ACCOUNT_PROVIDING_COLLATERAL',
                                                         Setup.Get_Headermfo);
        if Ln_Service.Is_Array_Value(v_Clients, i_Client_Code) then
          null;
        else
          return true;
        end if;
      when 'Y_CLIENTS_EXCEPT' then
        v_Clients := Ln_Setting.Get_Sys_Param_Value_List('CLIENT_LIST_HAS_ACCOUNT_PROVIDING_COLLATERAL',
                                                         Setup.Get_Headermfo);
        if not Ln_Service.Is_Array_Value(v_Clients, i_Client_Code) then
          null;
        else
          return true;
        end if;
      else
        null;
    end case;
    --
    select sum((case when t.Loan_Type_Account in (28, 39, 71) then Abs(a.Saldo_Out) else 0 end)) Saldo,
           sum((case when t.Loan_Type_Account in (29, 72) then Abs(a.Saldo_Out) else 0 end)) Saldo_Kontr,
           sign(count((case when t.Loan_Type_Account in (28, 39, 71) then 1 else null end))) +
           sign(count((case when t.Loan_Type_Account in (29, 72) then 1 else null end)))
      into v_Saldo, v_Saldo_Kontr, v_Count
      from Ln_Account t, Accounts a
     where t.Loan_Id = i_Loan_Id
       and t.Loan_Type_Account in (28, 39, 29, 71, 72)
       and t.Date_Next = Ln_Const.c_Max_Date
       and t.Acc_Id = a.Id;
    --
    if v_Count <> 2 then
      o_Message := '@48';
    elsif v_Saldo = 0 or v_Saldo_Kontr = 0 then
      o_Message:= '@49';
    end if;
    o_Message := Ln_Util.Parse_Operation_Template(o_Message);
    return o_Message is not null;
    --
  end Is_Client_Acc_Collateral;
----------------------------------------------------------------------------------
  function Exists_Loan_Account(
    i_Filial_Code varchar2,
    i_Loan_Id     number,
    i_Card_Type   ln_card.card_type%type,
    o_Message     out varchar2
  ) return boolean is
    -- обязательные счета
    vExist_Account     array_varchar2;
    vExist_Acc               varchar2(50);
    vExist_Account_Credit    varchar2(50) := 'EXIST_ACCOUNT_CREDIT';      -- кредиты
    vExist_Account_Leazing   varchar2(50) := 'EXIST_ACCOUNT_LEAZING';     -- лизинг
    vExist_Account_Factoring varchar2(50) := 'EXIST_ACCOUNT_FACTORING';   -- факторинг
    vMessage                 varchar2(3000);
  begin
    -- Контроль за назначением счетов при выдачи кредитов (25)
    if ln_setting.Get_Sys_Param('CREDITING_CHECK_ACC',i_Filial_Code) <> 'Y' then
      return true;
    end if;
    if i_Card_Type = LN_CONST.Ln_Credit then -- кредит
      vExist_Acc:= vExist_Account_Credit;
    elsif i_Card_Type = LN_CONST.Ln_Leasing then -- лизинг
      vExist_Acc:= vExist_Account_Leazing;
    elsif i_Card_Type = LN_CONST.Ln_Factoring then -- факторинг
      vExist_Acc:= vExist_Account_Factoring;
    end if;
    vExist_Account := Ln_Action.Get_Action_Desc_Values(iAction_Code => 'CREDITING',
                                                       iDesc_Code   => vExist_Acc,
                                                       iFilial_Code => i_Filial_Code,
                                                       iLoan_Id     => i_Loan_Id);
    -- проверка на наличае счетов
    vMessage := ln_service.Exists_Loan_Account(i_LOAN_ID,vExist_Account);

    -- если есть не закрепленные счета
    if vMessage is not null then
      o_Message := Ln_Util.Parse_Operation_Template(vMessage);
      return false;
    end if;
    return true;
  end Exists_Loan_Account;
----------------------------------------------------------------------------------
  procedure On_Save_Claim( i_Event in Dw_Event_t )
  is
    vClaim            Ln_Claim%rowtype;
    vClaim_Appendix   Ln_Claim_Appendix%rowtype;
    vClaim_Add        Ln_Claim_Additional%rowtype;
    v_OD              date := Setup.Get_Operday;
    v_Is_Create_Claim boolean := i_Event.Creating_Document();
  begin
    Em.Raise_Error_If(v_Is_Create_Claim and Ln_Util.Is_Header_Bank, 'LNCLAIM', 'Вводить заявки в ГО запрещено');
    Em.Raise_Error_If(Not v_Is_Create_Claim and Ln_Util.Is_Header_Bank, 'LNCLAIM', 'Изменять заявки в ГО запрещено');
    --
    Retrieve_Claim_Data_From_Dw( iEvent          => i_Event
                               , oClaim          => vClaim
                               , oClaim_Appendix => vClaim_Appendix
                               , oClaim_Add      => vClaim_Add );

    /*if i_Event.Event_Type = Dw_Util.c_Et_Edit_Document then
      Check_Claim_Data_4_Editing( vClaim, vClaim_Appendix );
    end if;*/
    if v_Is_Create_Claim then
      if vClaim_Appendix.Card_Type is null then 
        vClaim_Appendix.Card_Type := Ln_Product.Get_Product_Param(i_Code => 'CARD_TYPE_FOR_OVERDRAFT', i_Product_Id => vClaim.Product_Id, i_Is_Error => false);
      end if;
      --
      if Ln_Init.Is_Overdraft_Product(vClaim.Product_Id) then
        for r in (select l.Loan_Id,
                         Nvl((select Card_Type
                                from Ln_Claim_Appendix a
                               where a.Claim_Id = c.Claim_Id), 'OV') Card_Type,
                          l.Product_Id
                    from Ln_Claim c, Ln_Card l
                   where c.Filial_Code = vClaim.Filial_Code
                     and c.Client_Code = vClaim.Client_Code
                     and l.Condition not in (-3, -2, 8)
                     and exists
                   (select Product_Id
                            from Ln_Products p
                           where p.Product_Id = l.Product_Id
                             and p.Group_Id in (Ln_Const.c_Pgid_Overdraft, Ln_Const.c_Pgid_Mobile_Overdraft))
                     and c.Claim_Id <> vClaim.Claim_Id
                     and c.Claim_Id = l.Claim_Id
                     and (select --+index_desc(o LN_OVERDRAFT_LIMIT_PK)
                           o.Summ_Limit
                            from Ln_Overdraft_Limit o
                           where Loan_Id = l.Loan_Id
                             and Date_Limit <= v_Od
                             and Condition = 1
                             and Rownum = 1) <> 0)
        loop
          if ((Nvl(vClaim_Appendix.Card_Type, 'OV') <> Ln_Const.c_TET and r.Card_Type <> Ln_Const.c_TET) or (vClaim_Appendix.Card_Type = Ln_Const.c_TET and
               r.Card_Type = Ln_Const.c_TET)) and not (vClaim.Product_Id <> r.Product_Id and Setup.Get_Headermfo = '09055') then
            Ut.Raise_Err('У клиента есть овердрафтный кредит с ненулевым лимитом'); --Лимити 0 болмаган овердрафт кредити бор
          end if;
        end loop;
      end if;
      --
      $IF Core_App_Version.c_Header_Code = 9062 $THEN
        if Setup.Get_Task_Code = Ln_Const.Task_Code and vClaim.Client_Type = Ln_Const.Physical_Person then 
          Ut.Raise_Err('Данная операция запрещена для физ.лиц. для вашего банка (TBC)');
        end if;
      $END
    end if;
    Ln_Product.Check_Claim( vClaim, vClaim_Appendix );
    Validate_Claim_Data( vClaim, vClaim_Appendix, vClaim_Add, i_Event);
  end On_Save_Claim;
-------------------------------------------------------------------
  procedure On_Admit_Card( iLoan in Ln_Cache.Contrat_Loan_t )
  is
    vClaim            Ln_Claim%rowtype;
    vClaim_Apx        Ln_Claim_Appendix%rowtype;
    vClaim_Id         Ln_Claim.Claim_Id%type;
    vBlank            Ln_Blanks%rowtype;
    vTransit_Level    Ln_Blank_Transit_Levels%rowtype;
    vMessage          varchar2(3000);
    vSum_Unlead       number := 0;
    vGrace_Period     Ln_Blanks.Grace_Period%type;
    vProduct_Group_Id Ln_Products.Group_Id%type;
    v_Turn_All         number;
    v_Prem_Sum         number;
    v_Count            number;
  begin
    Ln_Init.Set_Product(i_Product_Id => iLoan.Card.Product_Id);
    vProduct_Group_Id := Ln_Product.Product_Group_Id(iLoan.Card.Product_Id);
    vClaim_Id := Dw_Util.Get_Doc_Id( 'LNCONTRACT', iLoan.Card.Loan_Id, 'LNCLAIM' );
    Ln_Util.Select_Claim(i_Claim_Id       => vClaim_Id,
                         o_Claim          => vClaim,
                         o_Claim_Appendix => vClaim_Apx);
    --
    if Not Ln_Init.Off_IABS_Actions_By_Init_Mod and Ln_Init.Off_All_iABS_Actions(vClaim.Creator_Code) then
      Raise_Application_Error(-20000, 'По этому договору запрещено выполнять какие-либо действия в подсистеме "Кредиты"');
    end if;
    --
    /*if Is_Agricultural_Loans_Used and vClaim.Purpose_Loan in ('020202', '020203') then
      Em.Raise_Error_If(Setup.Is_Headerlevel <> 'Y','LNAGR','Операция по утверждению текущего договора должна выполняться в ГО ');
    else
      null;*/
    /*$IF Core_App_Version.c_Has_Branches $THEN 
      if Ln_Setting.Get_Sys_Param('APPROVE_LOAN_CARD_ON_HEAD_LEVEL',setup.Get_HeaderMFO) <> 'Y' and iLoan.Card.Branch_Id <> Setup.Branch_Id
      then
        Ut.Raise_Err( 'Операция по утверждению текущего договора должна выполняться в подразделении ' || iLoan.Card.Local_Code );
      end if;
    $ELSE*/
      if Ln_Setting.Get_Sys_Param('APPROVE_LOAN_CARD_ON_HEAD_LEVEL',setup.Get_HeaderMFO) <> 'Y' and iLoan.Card.Filial_Code <> Setup.Filial_Code
      then
        Ut.Raise_Err( 'Операция по утверждению текущего договора должна выполняться в филиале ' || iLoan.Card.Filial_Code );
      end if;
    --$END
    --end if;
    --
    /*if not Ln_Init.Is_Online_Product and Ln_Cache.Loan.Product_Group_Id != Ln_Const.c_Pgid_Kredit_Konveyor and
      Ln_Setting.Get_Sys_Param('BAN_LOAN_APPROVAL_WO_NOTIFYING_NIKI_ABOUT_APPL') = 'Y' then
      if not Ln_Util.Is_Claim_Adobdet_Niki(i_Claim_Id => vClaim_Id) then
        Ut.Raise_Err('По данному кредиту заявка еще не принята в НИКИ!');
      end if;
      \*if Not Data_Exists('Ln_Claim', 'Claim_Id=' || vClaim_Id || ' and Cond_Nik=''' || Nk_Const.Req_Accepted || '''') then
        Ut.Raise_Err( 'По данному кредиту заявка еще не принята в НИКИ!' );
      end if;*\
    end if;*/
     /*if not Ln_Init.Is_Online_Product and
       Ln_Cache.Loan.Product_Group_Id != Ln_Const.c_Pgid_Kredit_Konveyor and
       Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_NIKI_FOR_APPROVE_LOAN',setup.Get_HeaderMFO) = 'Y' then
      if not Ln_Util.Is_Card_Adobdet_Niki(i_Loan_Id => iLoan.Card.Loan_Id) then
        Ut.Raise_Err('Кредитный договор не принят в НИКИ');
      end if;
      \*if Not Data_Exists('Ln_Nik_Card', 'Loan_Id=' || iLoan.Card.Loan_Id || ' and Cond_Nik=''' || Nk_Const.Req_Accepted || '''') then
        Ut.Raise_Err('Кредитный договор не принят в НИКИ');
      end if;*\
    end if;*/
    --
    -- LN_Claim tablitsadagi Creator code ga qaratildi
    if Vclaim.Creator_Code <> Ln_Const.c_Code_Esbs then
      --
      if not (Ln_Init.Is_Online_Product or Ln_Init.Is_Beepul_Product(Iloan.Card.Product_Id)) and
         Ln_Cache.Loan.Product_Group_Id != Ln_Const.c_Pgid_Kredit_Konveyor and
         Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_ASOKI_FOR_APPROVE_LOAN', Setup.Get_Headermfo) = 'Y' then
        if not Ln_Util.Is_Card_Received_In_Asoki(Iloan.Card.Loan_Id) then
          Ut.Raise_Err('Кредитный договор не принят в АСОКИ');
        end if;
      end if;
      --
    end if;
    
    if not (Ln_Init.Is_Online_Product or Ln_Init.Is_Beepul_Product(Iloan.Card.Product_Id)) and 
       (Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_RCI_FOR_APPROVE_LOAN', Setup.Get_Headermfo) = 'Y_ESBS' or
       (Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_RCI_FOR_APPROVE_LOAN', Setup.Get_Headermfo) = 'Y' and
       Vclaim.Creator_Code <> Ln_Const.c_Code_Esbs)) then
      if not Ln_Rci_Api_Out.Is_Card_Adobdet_Rci(i_Loan_Id => Iloan.Card.Loan_Id) then
        Ut.Raise_Err('Кредитный договор не принят в ГРКИ');
      end if;
    end if;
    --
    if not (Ln_Init.Is_Online_Product or Ln_Init.Is_Beepul_Product(Iloan.Card.Product_Id)) and
      (Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_RCI_FOR_APPROVE_GUAR', Setup.Get_Headermfo) = 'Y_ESBS' or
       (Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_RCI_FOR_APPROVE_GUAR', Setup.Get_Headermfo) = 'Y' and
       Vclaim.Creator_Code <> Ln_Const.c_Code_Esbs)) then
      if not Ln_Rci_Api_Out.Is_Guar_Adobdet_Rci(Iloan.Card.Loan_Id) then
        Ut.Raise_Err('Кредитный обеспечении не принят в ГРКИ');
      end if;
    end if;
    --
    if not (Ln_Init.Is_Online_Product or Ln_Init.Is_Beepul_Product(Iloan.Card.Product_Id)) and
      (Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_RCI_FOR_APPROVE_SCHEDULE', Setup.Get_Headermfo) = 'Y_ESBS' or
       (Ln_Setting.Get_Sys_Param('CHECK_ADOPDET_RCI_FOR_APPROVE_SCHEDULE', Setup.Get_Headermfo) = 'Y' and
       Vclaim.Creator_Code <> Ln_Const.c_Code_Esbs)) then
      if not Ln_Rci_Api_Out.Is_Schedule_Adobdet_Rci(Iloan.Card.Loan_Id) then
        Ut.Raise_Err('Кредитный графике погашения не принят в ГРКИ');
      end if;
    end if;
    --
    if not (vProduct_Group_Id = Ln_Const.c_Pgid_Kredit_Konveyor or Ln_Init.Is_Online_Product or ln_init.Is_Beepul_Product( iLoan.Card.Product_id)) then
       if Not Ln_Util.Is_Approved_Asoki_21(iLoan.Card.Loan_Id)
         and iLoan.Card.Guar_Class != '3' then 
         Ut.Raise_Err( 'Утверждение договора запрещено 21 запрос Асоки в состоянии "Не принят".');
       end if;
    end if;
    --
    if iLoan.Card.Condition <> Ln_Const.c_Loan_Not_Approved then
      Ut.Raise_Err( 'Утверждению подлежат только кредиты в состоянии "Неутвержденная ссуда"!' );
    end if;
    --
    Validate_Card_Data( iLoan => iLoan, iMode => Ln_Const.Admit_Card );
    --
    if vProduct_Group_Id <> Ln_Const.c_Pgid_Installment_Card then    
       if Not Is_Graph_Debt ( iLoan.Card.Loan_Id, iLoan.Card.Loan_Type, iLoan.Card.Summ_Loan, vMessage ) and vClaim_Apx.Card_Type <> 'TET' then
        Ut.Raise_Err( vMessage );
       end if;
    end if;
    --
    if iLoan.Card.Card_Type != Ln_Const.Ln_Factoring and Not Ln_Init.Is_Online_Product and
       Ln_Setting.Get_Sys_Param('IS_GRAPHIC_PERCENT_TO_APPROVE_LOAN',iLoan.Card.Filial_Code) = 'Y' and
       vProduct_Group_Id not in (Ln_Const.c_PGid_Credit_Card, Ln_Const.c_PGid_Credit_Card_Acc) and
         Nvl(Ln_Product.Get_Product_Param('CHECH_LOAN_GRAPHIC_PERC', iLoan.Card.Product_Id, false), 'Y') = 'Y'
    then
      if Not Is_Graph_Perc ( iLoan.Card.Loan_Id, vMessage ) and vClaim_Apx.Card_Type <> 'TET' then
        Ut.Raise_Err( vMessage );
      end if;
    end if;
    --
    if Not Is_Guarantee_Valid ( iLoan.Card.Loan_Id, vMessage ) then
      Ut.Raise_Err( vMessage );
    end if;

    if ln_init.Is_Beepul_Product(iLoan.Card.Product_id) then
      null;
    elsif Not Is_Percent_Rates_Valid( iLoan.Card, vMessage ) then
      Ut.Raise_Err( vMessage );
    end if;

    if Not Is_Mode_Actions_Valid( iLoan.Card.Loan_Id, iLoan.Card.Card_Type, iLoan.Card.Product_Id, vMessage ) then
      Ut.Raise_Err( vMessage );
    end if;

    if not Ln_Init.Is_Online_Product(iLoan.Card.Product_ID) and not Ln_Init.Is_Overdraft_Product(iLoan.Card.Product_Id) and
       not Is_Loan_Info_Contract( iLoan.Card.Loan_Id, iLoan.Card.Card_Type, vMessage ) then
      Ut.Raise_Err( vMessage );
    end if;

    if not Is_Hamkor_Bank then
      if Not Is_Overdraft_Limit ( iLoan.Card.Loan_Id, vMessage )
        and vClaim.Creator_Code <> Ln_Const.c_Code_ESBS then
        Ut.Raise_Err( vMessage );
      end if;
    end if;

    /*if iLoan.Card.Guar_Class <> '3' and not ln_init.Is_Beepul_Product(iLoan.Card.Product_id) then
      if Not Is_Client_Acc_Collateral(iLoan.Card.Loan_Id, iLoan.Card.Client_Code, vMessage) then
        Ut.Raise_Err( vMessage );
      end if;
    end if;*/

    Ln_Setting.Check_Accounts_In_Template(iLoan.Card.LOAN_ID, vMessage);
    if vMessage is not null then
      Ut.Raise_Err( Ln_Util.Parse_Operation_Template(vMessage) );
    end if;
    -- Проверка счета по шаблону продукта
    if vProduct_Group_Id = Ln_Const.c_PGid_Credit_Card_Acc then
      Ln_Operation.Operation_Action(Ioperation_Code  => 'ACCOUNT_ATTACH',
                                    Ioperation_Mode  => 'A',
                                    Ihashparams      => Hashtable(),
                                    Iloan_Id         => iLoan.Card.Loan_Id,
                                    Iis_Preview_Mode => 'OFF',
                                    Iraise_Error     => true);
    end if;
    /*Ln_Product.Check_Product_Account_Types(iLoan.Card.LOAN_ID, iLoan.Card.Product_id, 'ADMIT_CARD', vMessage);
    if vMessage is not null then
      Ut.Raise_Err( Ln_Util.Parse_Operation_Template(vMessage) );
    end if;*/
    --
    if vProduct_Group_Id not in (Ln_Const.c_Pgid_Installment_Card, Ln_Const.c_Pgid_Tet_Without_Operation, Ln_Const.c_Pgid_Islamic_Window) then
      if Not Exists_Loan_Account(iLoan.Card.Filial_Code, iLoan.Card.Loan_Id, iLoan.Card.Card_Type, vMessage) then
        Ut.Raise_Err(vMessage);
      end if;
    end if;
    --
    Check_Has_Plastic_Card(i_Loan_Id => iLoan.Card.Loan_Id, i_Product_Id => iLoan.Card.Product_Id);
    --
    if vProduct_Group_Id = Ln_Const.c_PGid_Business_Online then
      return;
    end if;
    --
    Ln_Util.Select_Blank(vClaim_Id, vBlank, false);
    Ln_Util.Select_Blank_Transit_Level(vBlank.Prev_Level_Id,2,vBlank.Level_Id,
                                       vBlank.Action_Id,vTransit_Level,false);
    vTransit_Level.Condition := 'L';
    if vTransit_Level.Transit_Id is not null then
      if vClaim.Summ_Claim/100 * Currency.Get_Course(vClaim.Currency) between
         vTransit_Level.Amount_Min and vTransit_Level.Amount_Max then
        vTransit_Level.Condition := 'N';
      end if;
    end if;
    if vTransit_Level.Condition = 'L' then
      if Ln_Util.Is_Access_Param_With_Clients('CREDITING_CHECK_RESOURCE','CREDITING_CHECK_RESOURCE_CLIENTS', iLoan.Card.Client_Code) = 'Y' and
         Ln_Product.Is_Limits_Cont_Use_By_Product and
         -- Утверждение запрашиваемых ресурсов свыше установленных лимитов
         iLoan.Card.Summ_Loan*Currency.Get_Course(iLoan.Card.Currency)/Ln_Service.Get_Currency_Scale(iLoan.Card.Currency) >
         Ln_Service.Convert_Number(Ln_Setting.Get_Sys_Param('CONFIRM_OVER_THE_ESTABLISHED_LIMIT',Setup.Get_Filial_Code)) then

       begin
         select state_id, t.grace_period
           into vSum_Unlead, vGrace_Period
           from Ln_Blanks t
          where claim_id = iLoan.Card.Claim_Id;
       exception
         when no_data_found then
           vSum_Unlead := 0;
           vGrace_Period := null;
       end;
       if vSum_Unlead <> 9 or vGrace_Period is null then
          if Not Data_Exists('LN_LOAN_CONTROL_SUM_HIS', 'Loan_Id=' || iLoan.Card.Loan_Id ) then
            Ut.Raise_Err( 'По данному кредиту не утвержден лимит кредитования! Утверждение отклонено!' );
          end if;
        end if;
      end if;
    end if;
    if Ln_Init.Is_Overdraft and Ln_Product.Is_Employer_Must_Client_Bank = 'Y' then
      if vClaim_Apx.Parent_Client_Id is null or vClaim_Apx.Parent_Client_Id = 0 then
        Ut.Raise_Err( 'В заявке не указано место работы сотрудника. Заявка не полностю заполнена.');
      elsif vClaim_Apx.Top_Client_Id is null then
        if not Ln_Overdraft.Is_Exists_Contract(vClaim_Apx.Parent_Client_Id, vClaim.Client_Id, vClaim_Apx.Card_Type) then
          Ut.Raise_Err( 'Указанное место работы в заявке не соответствует месту работы, указанному в модуле "'||vClaim_Apx.Card_Type||'". ' || sqlerrm);
        end if;
      elsif vClaim_Apx.Top_Client_Id is not null then
        if not Ln_Overdraft.Is_Exists_Contract(vClaim_Apx.Parent_Client_Id, vClaim_Apx.Top_Client_Id, vClaim_Apx.Card_Type) then
          Ut.Raise_Err( 'Указанное место работы в заявке не соответствует месту работы, указанному в модуле "'||vClaim_Apx.Card_Type||'". ' || sqlerrm);
        end if;
      end if;
    end if;
    --
    if vProduct_Group_Id = Ln_Const.c_PGid_Credit_Card_Acc then
      execute immediate 'begin Ln_Credit_Card.On_Admit_Loan(i_Loan_Id => :i_Loan_Id); end;'
        using iLoan.Card.Loan_Id;
    end if;
    --
    if not Ln_Init.Is_Online_Product(iLoan.Card.Product_id) and
      vProduct_Group_Id <> Ln_Const.c_Pgid_Installment_Card and
      Ln_Setting.Get_Sys_Param('CREATE_AND_APPROVAL_CARD_ONLY_ACCEPTED_ASOKI_017',Setup.Get_Headermfo) = 'Y' then
     -- if nk_asoki_util.has_ln_his_ready_report_yn(vClaim.Claim_Id) = 'N' then
      if ln_asoki_out.Has_Report_Yn(vClaim.Claim_Id) = 'N' then
        Ut.Raise_Err( 'CI-017 запрос не принят в АСОКИ');
      end if;
    end if;
    --
    if vProduct_Group_Id = Ln_Const.c_PGid_Credit_Card_Acc then
      execute immediate 'begin Ln_Credit_Card.Create_Cca_Card(i_Loan_Id => :i_Loan_Id, i_Product_Id => :i_Product_Id, i_Client_Id => :i_Client_Id); end;'
        using iLoan.Card.Loan_Id, iLoan.Card.Product_id, iLoan.Card.Client_Id;
    end if;
    --
    if Ln_Setting.Get_Sys_Param('BLOCK_APPROVAL_LOANS_WITH_AN_EXPIRED_INS_POLICY', iLoan.Card.Filial_Code) = 'Y' then
      vMessage := Ln_Service.Get_Loan_Account(iLoan.Card.Loan_Id, 1).Coa;
      if vMessage is null then
        Ut.Raise_Err('Не закреплен основной ссудный счет');
      end if;
      --
      if Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List('BLS_APPROVAL_LOANS_WITH_AN_EXPIRED_INS_POLICY',Setup.Get_Headermfo),vMessage)then
        Ut.Raise_Err('Утверждение договора запрещено имеется блокировка (просрочка страхового полиса) обратитесь к сотруднику кредитного отдела ГО');
      end if;
    end if;
    -- Проверка обеспечения по продукном шаблоном
     Ln_Product.Check_Loan_Guars(iLoan.Card.LOAN_ID, vMessage);
     if vMessage is not null then
       Ut.Raise_Err( Ln_Util.Parse_Operation_Template(vMessage) );
     end if;
     --
     $IF core_app_version.c_Header_Code = 9013 $THEN
     if ln_setting.Get_Sys_Param('CONTROL_PAYMENT_INSURANCE_PREMIUM_APPROV_CONTRACTS',
       setup.Get_HeaderMFO) = 'Y' and vClaim.Client_Type = Ln_Const.Physical_Person then
       begin
       select sum(t.prem_summ), count(*)
         into v_Prem_Sum, v_Count
         from Ln_Loan_Guar_Desc_Sp t
        where t.loan_id = iLoan.Card.Loan_Id;
        exception when no_data_found then
          v_Prem_Sum := 0;
        end; 
         begin
         select a.turnover_all_debit
           into v_Turn_All
           from ln_account t, accounts a
          where t.acc_id = a.id
            and t.loan_type_account = 111
            and t.loan_id = iLoan.Card.Loan_Id;
         exception when no_data_found then
           v_Turn_All := 0;
         end;
       --1
        if v_Count = 0 and v_Turn_All < v_Prem_Sum then
          Ut.Raise_Err('Не оплачено страховой премии');
        end if;
        end if;
     $END
     --  Сведения о контракте
     if Ln_Cache.Loan.Product_Id <> Ln_Const.c_Pid_Default and
        Ln_Product.Get_Product_Param('ATTACH_CONTRACT_DETAILS', Ln_Cache.Loan.Product_Id) = 'Y'
      and Ln_Util.Check_File(Ln_Cache.Loan.Loan_Id) = 0 then 
        Ut.Raise_Err('Необходимо добавить ?Сведения о контракте?');  
     end if;
  end On_Admit_Card;
  ------------------------------------------------------------------------------------------------
  Procedure Check_Crediting_Card(i_Loan_Id number) is
    v_Count number;
  begin
    select count(*)
      into v_Count
      from Ln_Crediting_Cards t
     where t.Loan_Id = i_Loan_Id;
  
    if v_Count = 0 then
      Raise_application_error(-20000, 'Невозможна утвердит кредитного договора. Не закреплена или не указана карта для выдачи');
    end if;
  end;
-------------------------------------------------------------------------------------------------
  procedure Admit_Card( iEvent in Dw_Event_t)
  is
    vLoan      Ln_Cache.Contrat_Loan_t;
    v_err      varchar2(4000);
    v_Params   Hashtable := Hashtable();
    v_Sum_Guar number;
    v_guar_ids array_number;
    --v_Err_Num  number;
    v_client_type    varchar2(2);
    --v_UzCard         varchar2(1);
    --v_UzCard_Count   number;
    v_Mobile_Number  ln_claim_appendix.mobile_number%type;
    --
    v_Graph_Id     Ln_Graph_Debt.Id%type;
    v_Date_Limits  Array_Varchar2 := Array_Varchar2();
    v_Summ_Limits  Array_Varchar2 := Array_Varchar2();
    v_States       Array_Number := Array_Number();
    v_Debug_Id     number(15); 
    v_Creator_Code Ln_Claim.Creator_Code%type;
    v_Info_Cont_Acc    varchar2(20);
    v_Info_Cont_Acc_N  varchar2(50);
    v_Info_Cont_Amount number;
    v_Cont_Count       number;
    v_Hash             Hashtable := Hashtable();							  
  begin
    vLoan := Get_Loan_Object( iLoan_Id => iEvent.Get_Doc_Id('LNCONTRACT') );
    select Creator_Code
      into v_Creator_Code
      from ln_claim t
     where t.claim_id = vLoan.Card.claim_Id;
    if Nvl(Ln_Product.Get_Product_Param(i_Code => 'CARD_NUMBER_MASK_OUT_YES_NO', 
                    i_Product_Id => vLoan.Card.Product_id,
                    i_Is_Error   => false), 'N') = 'Y' then
      Check_Crediting_Card(i_Loan_Id => vLoan.Card.Loan_Id);
    end if;
    
    --vaqtinchalik qushildi
    /*if not Ln_Init.Is_Online_Product(vLoan.Card.Product_id) and Setup.Get_Headermfo = '09006' and not Ln_Util.Is_Header_Bank then
      if not ln_service.Is_Array_Value(ln_setting.Get_Sys_Param_Value_List('APPROVE_LOAN_FILIAL_LEVEL_USERS',Setup.Get_Headermfo), Setup.Get_Employee_Code) then
        Ut.Raise_Err('Вы не можете утвердить договор');
      end if;
    end if;*/
    --if (ln_init.Is_Overdraft_Product(vLoan.Card.Product_Id) or ln_product.Product_Group_Id(vLoan.Card.Product_Id) = Ln_Const.c_Pgid_Installment_Card) and not Is_Hamkor_Bank then
    if v_Creator_Code != Ln_Const.c_Code_ESBS then
      if (Ln_Init.Is_Overdraft_Product(vLoan.Card.Product_Id) or Ln_Cache.Loan.Product_Group_Id = Ln_Const.c_Pgid_Installment_Card) and not Is_Hamkor_Bank then
        Ln_Overdraft.Create_Overdraft(i_Loan => vLoan.Card);
        if not Ln_Init.Is_Online_Product  and core_app_version.c_Header_Code <> 9055 then
         Ln_Schedule.Model_Overdraft_Limit(i_Loan_Id     => vLoan.Card.Loan_Id,
                                           o_Date_Limits => v_Date_Limits,
                                           o_Summ_Limits => v_Summ_Limits,
                                           o_States      => v_States);
         Ln_Schedule.Save_Overdraft_Limit(Ograph_Id          => v_Graph_Id,
                                           Iloanid            => vLoan.Card.Loan_Id,
                                           Idecide_Num        => null,
                                           Idecide_Date       => null,
                                           Idecide_Department => null,
                                           Idecide_Reason     => null,
                                           Idate_Limit        => v_Date_Limits,
                                           Isumm_Limit        => v_Summ_Limits,
                                           Istate             => v_States);
        end if;
      end if; 
    end if;
    On_Admit_Card(vLoan);
    --
    if Is_Agricultural_Loans_Used then
      Ln_Loan_Data.gClaim_Num   := vLoan.Card.Claim_Number;
      Ln_Loan_Data.gClient_Code := vLoan.Card.Client_Code;
      Ln_Loan_Data.gPurposeLoan := vLoan.Card.Purpose_Loan;
      Ln_Loan_Data.gSumm_Loan   := vLoan.Card.Summ_Loan;
      Ln_Loan_Data.gOpenDate    := vLoan.Card.Open_Date;

      Event.Reaction_Run(75001, 1); -- SX_LN_ACTIONS.sxExists
      Event.Reaction_Run(75002, 1); -- SX_LN_ACTIONS.sxContractSumma
    end if;
    --
    begin
      Ln_Setting.Locking_Loan(Iloan_Id => Array_Varchar2(vLoan.Card.loan_id), Ilocking => Ln_Const.Loan_Locked);
      --
      update Ln_Card t
         set t.Condition   = Ln_Const.c_Loan_Not_Granted
           , t.Date_Modify = sysdate
           , t.Emp_Code    = Setup.Employee_Code
       where t.Loan_Id = vLoan.Card.Loan_Id;
      --
      $IF Core_APP_Version.c_Header_Code <> 9012 $THEN
      if Ln_Cache.do_backup_online_loans.loan = 'N' then
          Backup_Loan_Card(vLoan.Card.Loan_Id);
       else 
         null;
       end if;
      $END
      Ln_Operation.Set_Operation_Loans(vLoan.Card.Loan_Id);
      --
      --insert into Ln_Card_His t values vLoan.Card;

      Log_Doc_Modification ( iDoc_Id         => vLoan.Card.Loan_Id
                           , iDoc_Type_Code  => 'LNCONTRACT'
                           , iState_Code     => vLoan.Card.Condition
                           , iNew_State_Code => Ln_Const.c_Loan_Not_Granted
                           , iDescription    => 'Утверждение кредитного договора'
                           );
    exception
      when OTHERS then
        Raise_Application_Error( -20000, 'Ошибка при изменении состояния договора и инициализации истории кредита! ' || Ut.cCRLF || SqlErrM );
    end;
    --
    if Ln_Util.Is_Allowed_Confirm_Card('ALLOW_CHECK_FOR_APPROVAL_CARD', 'ROLE_IDS_ALLOWED_TO_APPROVE_CARD') = 'N' and not Ln_Init.Is_Online_Product then
      Raise_Application_Error(-20000, 'У вас нет доступа для утверждения договора!');
    end if;
    -- 
    if ln_setting.Get_Sys_Param('APPROVE_LOAN_CARD_ON_HEAD_LEVEL',setup.Get_HeaderMFO) = 'Y' and
       not Ln_Init.Is_Online_Product and not Ln_Util.Is_Without_Send_Card_Admission(vLoan.Card.Claim_Id) then
      Ln_Kernel.Card_Admission(i_Loan_Id  => vLoan.Card.Loan_Id,
                               i_State_Id => iEvent.Params.Get_Number('state_id'),
                               i_Reason   => iEvent.Params.Get_Optional_Varchar2('reason'));
    end if;
    
    Ln_Kernel.Calc_Percent_For_Col(vLoan.Card.Loan_Id);
    if Ln_Product.Product_Group_Id(vLoan.Card.Product_Id) = Ln_Const.c_PGid_Conct then
      --kontokorrent kreditini utverdit qilinganda 91809 da pul payto qilish
      Ln_Overdraft.Approve_Credit_Card(i_Loan_Id => vLoan.Card.Loan_Id);
    end if;
    --
    if Ln_Init.Is_Credit_Card_Product(vLoan.Card.Product_Id) or ln_init.Is_Beepul_Product(vLoan.Card.Product_id) then
      Ln_Overdraft.Approve_Credit_Card(i_Loan_Id => vLoan.Card.Loan_Id);
      /*Ln_Kernel.Authorization_Card(i_Loan_Id       => vLoan.Card.Loan_Id,
                                   i_Filial_Code   => vLoan.Card.Filial_Code,
                                   i_Client_Phone  => Ln_Util.Get_Client_Mobile_Phone(vLoan.Card.Client_Id),
                                   i_Manager_Phone => '930000000');*/
    end if;
    --identifikatsiya klient dlya vnutrinnix kontrol
    begin
      execute immediate 'begin Cm_Client.Clients_Persons(i_Client_Id => :i_Client_Id, i_Servicetype => :i_Servicetype); end;'
        using vLoan.Card.Client_Id, 4;
    exception
      when others then
        null;
    end;
    --////////////////////////////////////////////////////////////////////////////////////////////
    -- doim procedurani ohirida ishlatilsin bu yerda kartaga popolneniya ketadi
    if Ln_Product.Product_Group_Id(vLoan.Card.Product_id) = Ln_Const.c_PGid_Credit_Card_Acc then
      execute immediate 'begin Ln_Credit_Card.Admit_Cca_Loan(i_Loan_Id => :i_Loan_Id); end;'
        using vLoan.Card.Loan_Id;
    end if;
    --
    v_client_type := Ln_Util.Get_Client_Subject_Code(i_Client_Code => vLoan.Card.Client_Code,
                                                     i_Filial_Code => vLoan.Card.Filial_Code,
                                                     i_Client_Id => vLoan.Card.Client_Id);
    -- Автоматические проводки по обеспечениям (945**) по физ.лицам
    if Ln_Cache.Loan.Product_Group_Id <> Ln_Const.c_Pgid_Islamic_Window and 
      /*Ln_Cache.Loan.Branch_Id != 450 and*/ (Ln_Init.Is_Online_Product or (Ln_Cache.Loan.Client_Type = Ln_Const.Physical_Person and 
         Ln_Setting.Get_Sys_Param_L('GUAR_LEAD_AUTO_PHIS', Ln_Const.Header_Local_Code) = 'Y') or 
       (Ln_Cache.Loan.Client_Type in (Ln_Const.Juridical_Person, Ln_Const.Individual_Entrepreneur) and 
         Ln_Setting.Get_Sys_Param_L('GUAR_LEAD_AUTO_JUR', Ln_Const.Header_Local_Code) = 'Y')) 
    then
      --
      select Nvl(sum(Sum_Guar), 0) / 100
        into v_Sum_Guar
        from Ln_Loan_Guar
       where Loan_Id = vLoan.Card.Loan_Id
         and Guar_Type not in (41, 42, 43, 44, 51, 62, 76);
      --
      v_Sum_Guar := v_Sum_Guar - Ln_Util.Get_Saldo_Accounts(vLoan.Card.Loan_Id, Array_Varchar2('39'))/100;
      if v_Sum_Guar > 0 then
        v_guar_ids := array_number();
        for s in (select Guar_Id
                    from Ln_Loan_Guar
                   where Loan_Id = vLoan.Card.Loan_Id
                     and Guar_Type not in (41, 42, 43, 44, 51, 62, 76))
        loop
          v_Guar_Ids.Extend;
          v_Guar_Ids(v_Guar_Ids.Count) := s.Guar_Id;
        end loop;
        v_Params.Put('LEAD_ACCOUNT_DEBET', LN_ACTION_PARAM.Get_Loan_Account_Code(39));
        v_Params.Put('LEAD_ACCOUNT_NAME_DEBET', LN_ACTION_PARAM.Get_Loan_Account_Name(39));
        v_Params.Put('LEAD_INN_DEBET', LN_ACTION_PARAM.Get_Client_Inn(39));
        v_Params.Put('LEAD_ACCOUNT', LN_ACTION_PARAM.Get_Loan_Account_Code(29));
        v_Params.Put('LEAD_ACCOUNT_NAME', LN_ACTION_PARAM.Get_Loan_Account_Name(29));
        v_Params.Put('LEAD_INN', LN_ACTION_PARAM.Get_Client_Inn(29));
        v_Params.Put('LEAD_DOC_NUMB', '');
        v_Params.Put('LEAD_TRANS_ID', '106');
        v_Params.Put('LEAD_ACT_ID', '41');
        v_Params.Put('LEAD_SUM_PAY', Ln_Service.Convert_Varchar(v_Sum_Guar));
        v_Params.Put('LEAD_SYM_ID', '00599');
        v_Params.Put('LEAD_PURPOSE', LN_ACTION_PARAM.Get_Action_Name('HAND_GUAR_4'));
        v_Params.Put('GUAR_ID', v_guar_ids);
        --17xxx schetdan kredit 2xxxx scheti summani olib utib olish
        Ln_Operation.Operation_Action(Ioperation_Code  => 'HAND_GUAR_4',
                                      Ioperation_Mode  => 'A',
                                      Ihashparams      => v_Params,
                                      Iloan_Id         => vLoan.Card.Loan_Id,
                                      Iis_Preview_Mode => 'OFF',
                                      Iraise_Error     => true);
      end if;
      --
      select Nvl(sum(Sum_Guar), 0) / 100
        into v_Sum_Guar
        from Ln_Loan_Guar
       where Loan_Id = vLoan.Card.Loan_Id
         and Guar_Type in (41, 42, 43, 44, 51, 62, 76);
      --
      v_Sum_Guar := v_Sum_Guar - Ln_Util.Get_Saldo_Accounts(vLoan.Card.Loan_Id, Array_Varchar2('28'))/100;
      if v_Sum_Guar > 0 then
        v_Params.Put('LEAD_ACCOUNT_DEBET', LN_ACTION_PARAM.Get_Loan_Account_Code(28));
        v_Params.Put('LEAD_ACCOUNT_NAME_DEBET', LN_ACTION_PARAM.Get_Loan_Account_Name(28));
        v_Params.Put('LEAD_INN_DEBET', LN_ACTION_PARAM.Get_Client_Inn(28));
        v_Params.Put('LEAD_ACCOUNT', LN_ACTION_PARAM.Get_Loan_Account_Code(29));
        v_Params.Put('LEAD_ACCOUNT_NAME', LN_ACTION_PARAM.Get_Loan_Account_Name(29));
        v_Params.Put('LEAD_INN', LN_ACTION_PARAM.Get_Client_Inn(29));
        v_Params.Put('LEAD_DOC_NUMB', '');
        v_Params.Put('LEAD_TRANS_ID', '106');
        v_Params.Put('LEAD_ACT_ID', '41');
        v_Params.Put('LEAD_SUM_PAY', Ln_Service.Convert_Varchar(v_Sum_Guar));
        v_Params.Put('LEAD_SYM_ID', '00599');
        v_Params.Put('LEAD_PURPOSE', LN_ACTION_PARAM.Get_Action_Name('HAND_GUAR_156'));
        --17xxx schetdan kredit 2xxxx scheti summani olib utib olish
        Ln_Operation.Operation_Action(Ioperation_Code  => 'HAND_GUAR_156',
                                      Ioperation_Mode  => 'A',
                                      Ihashparams      => v_Params,
                                      Iloan_Id         => vLoan.Card.Loan_Id,
                                      Iis_Preview_Mode => 'OFF',
                                      Iraise_Error     => true);
      end if;
    end if;
    --
    if v_Client_Type  = Ln_Const.Physical_Person then
      --utverdit paytida sms junatish
      if Ln_Init.Is_Online_Product(vLoan.Card.Product_id) then
        select substr(a.mobile_number, -9)
          into v_Mobile_Number
          from ln_claim_appendix a
         where a.claim_id = vLoan.Card.claim_id;
      end if;
      if v_Mobile_Number is null then
        v_Mobile_Number := Ln_Util.Get_Client_Mobile_Phone(vLoan.Card.Client_Id);
      end if;
      Ln_Kernel.Authorization_Card(i_Loan_Id       => vLoan.Card.Loan_Id,
                                   i_Filial_Code   => vLoan.Card.Filial_Code,
                                   i_Client_Phone  => v_Mobile_Number,
                                   i_Manager_Phone => '930000000');
    $IF Core_App_Version.c_Header_Code = 9002 $THEN
    else
      Ln_Kernel.Authorization_Card(i_Loan_Id       => vLoan.Card.Loan_Id,
                                   i_Filial_Code   => vLoan.Card.Filial_Code,
                                   i_Client_Phone  => '930000000',
                                   i_Manager_Phone => '930000000');
    $END
    end if;
    --
    --Формировать автоматические проводки по счету 91809 (при утверждении договора на 2 этапе)
    if Ln_Cache.Loan.Product_Group_Id <> Ln_Const.c_Pgid_Islamic_Window and Not Ln_Init.Is_Online_Product(vLoan.Card.Product_id) and 
       Ln_Setting.Get_Sys_Param_l('GUARANTEE_OBLIGATION_AUTO_WHEN_ADMIT_CARD', Ln_Const.Header_Local_Code) = 'Y' then
      v_Params :=Hashtable();
      v_Params.put('ALL','');
      Ln_Operation.Operation_Action(Ioperation_Code  => 'GUARANTEE_OBLIGATION_AUTO',
                                    Ioperation_Mode  => 'M',
                                    Ihashparams      => v_Params,
                                    Iloan_Id         => vLoan.Card.Loan_Id,
                                    Iis_Preview_Mode => 'OFF',
                                    Iraise_Error     => true);
    end if;
	-- Автоматическая выдача по контракту
    if Not Ln_Init.Is_Online_Product(vLoan.Card.Product_id) and
       Ln_Cache.Loan.Client_Type in (Ln_Const.Juridical_Person, Ln_Const.Individual_Entrepreneur) and
       Ln_Service.Is_Array_Value(Ln_Setting.Get_Sys_Param_Value_List_l('LOAN_LEAD_INFO_CONTRACT',setup.Header_Local_Code),Ln_Cache.Loan.Product_Id)
    then
      --
      Select t.account_code, t.account_name, t.amount, count(*)
        into v_Info_Cont_Acc, v_Info_Cont_Acc_N, v_Info_Cont_Amount, v_Cont_Count
        From Ln_Loan_Info_Contracts t
       where t.loan_id = vLoan.Card.Loan_Id;
      --
      if v_Cont_Count > 1 then
       raise_application_error(-20000, 'Неверное количество контрактов для договора!');
      end if;
      --
      v_Hash.Put('LEAD_FILIAL', vLoan.Card.Filial_Code);
      v_Hash.Put('LEAD_ACT_ID', '41');
      v_Hash.Put('LEAD_DOC_NUMB', '');
      v_Hash.Put('LEAD_INN', Bank.Get_Client_Inn(vLoan.Card.Client_Code, 'N', vLoan.Card.Filial_Code));
      v_Hash.Put('LEAD_ACCOUNT', v_Info_Cont_Acc);
      v_Hash.Put('LEAD_ACCOUNT_NAME', v_Info_Cont_Acc_N);
      v_Hash.Put('LEAD_SUM_PAY', Ln_Service.Convert_Varchar(v_Info_Cont_Amount));
      --
      v_Hash.Put('LEAD_PURPOSE', '');
      v_Hash.Put('LEAD_SYM_ID', '01007');
      v_Hash.Put('LEAD_TRANS_ID', '106');
      --
      Ln_Operation.Operation_Action(Ioperation_Code  => 'CREDITING',
                                    Ioperation_Mode  => Ln_Const.Mode_Avto,
                                    Ihashparams      => v_Hash,
                                    Iloan_Id         => vLoan.Card.Loan_Id,
                                    Iis_Preview_Mode => 'OFF',
                                    Iraise_Error     => true);
    end if;   
    /*--МПК овердрафт (без операции)
    if Ln_Cache.Loan.Product_Group_Id = Ln_Const.c_Pgid_Tet_Without_Operation then 
      Ln_Overdraft.Create_Overdraft(i_Loan => vLoan.Card);
    end if;*/
    --Карта рассрочки
    if Ln_Cache.Loan.Product_Group_Id = Ln_Const.c_Pgid_Installment_Card and v_Creator_code <> Ln_Const.c_Code_Esbs then 
      Ln_Overdraft.Set_Limit(i_Loan_Id => vLoan.Card.Loan_id, i_Date_Limit => Setup.Get_Operday);
    end if;
    --
    $IF Core_App_Version.c_Header_Code = 9013 $THEN
    if Ln_Init.Is_Overdraft_Product(vLoan.Card.Product_Id)  and v_Creator_code <> Ln_Const.c_Code_Esbs then
     Ln_Overdraft.Set_Limit(i_Loan_Id => vLoan.Card.Loan_id, i_Date_Limit => Setup.Get_Operday);
     Ln_Action_Seccond.Covered_Premium_Through_Acc(vLoan.Card.Loan_Id);
    end if;
    $END
    --
/*  exception
    when others then
      --sql_util.trace_text('LN', 'Admit_Card:' || v_err);
      Mlm.Trace_Debug(i_Call_Stack  => Dbms_Utility.Format_Call_Stack,
                      i_Error_Stack => Dbms_Utility.Format_Error_Backtrace,
                      o_Debug_Id    => v_Debug_Id);
      v_err := substr(sqlerrm,1,3950) || ' ('||v_Debug_Id||')';
      raise_application_error(-20000, v_err);*/
  end Admit_Card;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Проверяем, принята ли заявка ГО
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  procedure Check_Claim_Admission_By_Head( iEvent in dw_event_t )
  is
    vClaim_ID integer;
    v_claim ln_claim%rowtype;
    v_Claim_Appendix ln_claim_appendix%rowtype;
    --v_err     varchar2(4000);
  begin
    vClaim_ID := dw_util.get_folder_doc_id( iEvent.folder_id, 'LNCLAIM' );
    ln_util.Select_Claim(vClaim_ID, v_claim, v_Claim_Appendix);

    if Ln_Init.Is_Online_Product(v_claim.product_id) or ln_init.Is_Beepul_Product(v_claim.product_id)
      or Ln_Setting.Get_Sys_Param('APPROVE_APPLICATIONS_ON_HEAD_LEVEL') = 'N' then
      return;
    end if;
    --
    select count(*) into v_Claim.Count_Nik
      from Ln_Product_Params
     where Product_Id = v_Claim.Product_Id
       and Param_Id = 61
       and Param_Value = 'Y'
       and rownum = 1;
    --
    if v_Claim.Count_Nik = 0 and
       Not Data_Exists('Ln_Claim', 'Claim_Id=' || vClaim_ID || ' and Status=' || Ln_Const.CLAIM_ACCEPTED_BY_HEAD ) then
      Raise_Application_Error(-20000, 'Текущая заявка еще не принята кредитным департаментом ГО!');
    end if;
  exception
    when others then
      --v_err := substr(sqlerrm,1,3950);
      --sql_util.trace_text('LN', 'Admit_Card:' || v_err);
      raise;
  end Check_Claim_Admission_By_Head;
-------------------------------------------------------------------
Procedure Save_Credit_Sources(iLoan in Ln_Cache.Contrat_Loan_t) is
    v_Row       Ln_Credit_Sources%rowtype;
    v_Sysdate   date := sysdate;
    v_Is_Backup boolean;
    v_Codes     Array_Varchar2 := Array_Varchar2();
    v_Action    Varchar2(1);
  begin
    /*delete Ln_Credit_Sources t
    where t.Loan_Id = iLoan.Card.Loan_Id;*/
    v_Codes.Extend(iLoan.Credit_Source.Count);
    for i in 1 .. iLoan.Credit_Source.Count
    loop
      v_Is_Backup := true;
      v_Codes(i) := iLoan.Credit_Source(i);
      begin
        select *
          into v_Row
          from Ln_Credit_Sources
         where Loan_Id = iLoan.Card.Loan_Id
           and Credit_Source_Code = iLoan.Credit_Source(i);
        --
        if Nvl(v_Row.Lending_Source_Code, 'L') = Nvl(iLoan.Lending_Source_Code(i), 'L') and 
           Nvl(v_Row.Foreign_Organization_Code, 'L') = Nvl(iLoan.Foreign_Organization(i), 'L') and
           Nvl(v_Row.Financing_Currency_Code, '000') = Nvl(iLoan.Financing_Currency(i), '000') and 
           Nvl(v_Row.Financing_Amount, 0) = Nvl(iLoan.Financing_Amount(i), 0) and
           Nvl(v_Row.Loan_Line_Purpose, 'L') = Nvl(Replace_Unicode(iLoan.Loan_Line_Purpose(i)), 'L') and 
           Nvl(v_Row.Under_Guarantee_Ruz, 2) = Nvl(iLoan.Under_Guarantee_Ruz(i), 2) 
        then
          v_Is_Backup := false;
        else
          v_Action := 'U';
          update Ln_Credit_Sources
             set Foreign_Organization_Code = iLoan.Foreign_Organization(i),
                 Financing_Currency_Code   = iLoan.Financing_Currency(i),
                 Financing_Amount          = iLoan.Financing_Amount(i),
                 Loan_Line_Purpose         = Replace_Unicode(iLoan.Loan_Line_Purpose(i)),
                 Under_Guarantee_Ruz       = Nvl(iLoan.Under_Guarantee_Ruz(i), 2),
                 Date_Modify               = v_Sysdate,
                 Lending_Source_Code       = iLoan.Lending_Source_Code(i)
           where Loan_Id = iLoan.Card.Loan_Id
             and Credit_Source_Code = iLoan.Credit_Source(i);
        end if;   
      exception 
        when No_Data_Found then
          v_Action := 'I';
          insert into Ln_Credit_Sources
            (Loan_Id,
             Credit_Source_Code,
             Lending_Source_Code,
             Foreign_Organization_Code,
             Financing_Currency_Code,
             Financing_Amount,
             Loan_Line_Purpose,
             Under_Guarantee_Ruz,
             Date_Modify,
             --Branch_Id,
             Local_Code)
          values
            (iLoan.Card.Loan_Id,
             iLoan.Credit_Source(i),
             iLoan.Lending_Source_Code(i),
             iLoan.Foreign_Organization(i),
             iLoan.Financing_Currency(i),
             iLoan.Financing_Amount(i),
             Replace_Unicode(iLoan.Loan_Line_Purpose(i)),
             Nvl(iLoan.Under_Guarantee_Ruz(i), 2),
             v_Sysdate,
             --iLoan.Card.Branch_Id,
             iLoan.Card.Local_Code);
       end;     
       --         
       if v_Is_Backup then 
         insert into Ln_Credit_Sources_His
         select Loan_Id,
                Credit_Source_Code,
                Foreign_Organization_Code,
                Financing_Currency_Code,
                Financing_Amount,
                Loan_Line_Purpose,
                Date_Modify,
                Under_Guarantee_Ruz,
                Lending_Source_Code,
                --Iloan.Card.branch_id,
                Iloan.Card.local_code,
                v_Action,
                Setup.Bankday
           from Ln_Credit_Sources
          where Loan_Id = iLoan.Card.Loan_Id
            and Credit_Source_Code = iLoan.Credit_Source(i);
       end if;
    end loop;
    --
    insert into Ln_Credit_Sources_His (Loan_Id,
                                       Credit_Source_Code,
                                       Foreign_Organization_Code,
                                       Financing_Currency_Code,
                                       Financing_Amount,
                                       Loan_Line_Purpose,
                                       Under_Guarantee_Ruz,
                                       Date_Modify,
                                       Lending_Source_Code,
                                       --Branch_Id,
                                       Local_Code,
                                       Action,
                                       Oper_Day)
      select t.Loan_Id,
             t.Credit_Source_Code,
             t.Foreign_Organization_Code,
             t.Financing_Currency_Code,
             t.Financing_Amount,
             t.Loan_Line_Purpose,
             t.Under_Guarantee_Ruz,
             sysdate,
             t.Lending_Source_Code,
             --iLoan.Card.branch_id,
             iLoan.Card.local_code,
             'D',
             Setup.Bankday
        from Ln_Credit_Sources t
       where t.Loan_Id = iLoan.Card.Loan_Id
         and t.Credit_Source_Code not member of v_Codes;
    --
    delete Ln_Credit_Sources t
     where t.Loan_Id = iLoan.Card.Loan_Id
       and t.Credit_Source_Code not member of v_Codes;
    --
  exception
    when Dup_Val_On_Index then
      Ut.Raise_Err('У кредитного договора не может быть 2 одинаковых источника кредитования!');
  end Save_Credit_Sources;
  ---------------------------------------------------------------------------------------------------
 Procedure Save_Loan_Purposes(iLoan in Ln_Cache.Contrat_Loan_t) is
 begin
   delete Ln_Loan_Purposes t
    where t.Loan_Id = Iloan.Card.Loan_Id;
   --
   if iLoan.Card.Card_Type <> Ln_Const.Ln_Credit then 
     return;
   end if;
   --
   for i in 1 .. Iloan.Loan_Purpose_Codes.Count
   loop
     insert into Ln_Loan_Purposes
     values
       (ln_loan_purposes_sq.Nextval, Iloan.Card.Loan_Id, Iloan.Loan_Purpose_Codes(i), Iloan.Loan_Purpose_Info(i));
   end loop;
 exception
   when Dup_Val_On_Index then
     Ut.Raise_Err('У кредитного договора не может быть 2 одинаковых код цельи кредитования!');
 end Save_Loan_Purposes;
---------------------------------------------------------------------
Procedure Save_Loan_Report_Types(iLoan in Ln_Cache.Contrat_Loan_t) is
  type t_Row is record(
    Rid            rowid,
    Report_Type_Id number(5),
    Is_Del         varchar2(1));
  type t_Rows is table of t_Row;
  v_Rows t_Rows;
  type t_At_Rows is table of t_Row index by pls_integer;
  v_At_Rows        t_At_Rows;
  v_Report_Type_Id number(5);
  --=============================
  procedure backup(i_loan_id number, i_report_type_id number, i_date_modify date) is 
  begin 
    insert into Ln_Loan_Report_Types_His (Loan_Id, Report_Type_Id, Date_Modify)
    values (i_Loan_Id, i_Report_Type_Id, i_Date_Modify);
  end backup;
  --=============================
begin
  select rowid, Report_Type_Id, 'Y'
    bulk collect
    into v_Rows
    from Ln_Loan_Report_Types t
   where t.Loan_Id = iLoan.Card.Loan_Id;
  for i in 1 .. v_Rows.Count
  loop
    v_At_Rows(v_Rows(i).Report_Type_Id) := v_Rows(i);
  end loop;
  --
  for i in 1 .. iLoan.Loan_Report_Types.Count
  loop
    if iLoan.Loan_Report_Types(i) is not null then
      if v_At_Rows.Exists(iLoan.Loan_Report_Types(i)) then
        v_At_Rows(iLoan.Loan_Report_Types(i)).Is_Del := 'N';
      else
        insert into Ln_Loan_Report_Types (Loan_Id, Report_Type_Id, Date_Modify)
        values (iLoan.Card.Loan_Id, iLoan.Loan_Report_Types(i), iLoan.Card.Date_Modify);
        BackUp(iLoan.Card.Loan_Id, iLoan.Loan_Report_Types(i), iLoan.Card.Date_Modify);
      end if;
    end if;
  end loop;
  --
  v_Report_Type_Id := v_At_Rows.First;
  loop
    exit when v_Report_Type_Id is null;
    if v_At_Rows(v_Report_Type_Id).Is_Del = 'Y' then
      delete from Ln_Loan_Report_Types where rowid = v_At_Rows(v_Report_Type_Id).Rid;
      BackUp(Iloan.Card.Loan_Id, v_Report_Type_Id, sysdate);
    end if;
    v_Report_Type_Id := v_At_Rows.Next(v_Report_Type_Id);
  end loop;
  --
exception
  when Dup_Val_On_Index then
    Ut.Raise_Err('У кредитного договора не может быть 2 одинаковых вид отчета!');
end Save_Loan_Report_Types;
---------------------------------------------------------------------
  Procedure Save_Perc_Retes_From_Claim
  (
    i_Claim_Id  number,
    i_Loan_Id   number,
    i_Perc_Date date
  ) is
    v_Claim   Ln_Claim%rowtype;
    --v_Sysdate date := sysdate;
  begin
    v_Claim := Get_Claim_Rowtype(i_Claim_Id);
    if Ln_Setting.Get_Sys_Param('MANDATORY_FILLING_OF_THE_PERC_RATES_IN_THE_CLAIM',Setup.Get_HeaderMFO) <> 'Y' and v_Claim.Creator_Code <> 'FBCRM' then
      return;
    end if;
    --
    for r in (select Perc_Code_Desc, Perc_Rate, Nvl(Perc_Rate_Type , 'F') Perc_Type     
                from Ln_Blank_Percent_Rate
               where Claim_Id = i_Claim_Id)
    loop
      Ln_Data.Percent_Rate_Create(i_Loan_Id             => i_Loan_Id,
                                  i_Perc_Code_Desc      => r.Perc_Code_Desc,
                                  i_Perc_Type           => r.Perc_Type,
                                  i_First_Date          => i_Perc_Date,
                                  i_Perc_Rate           => r.Perc_Rate,
                                  i_Summa               => 0,
                                  i_Description         => null,
                                  i_Emp_Code            => Setup.Get_Employee_Code,
                                  i_Date_Modify         => sysdate,
                                  i_Share_Combined_Perc => null,
                                  i_Is_Backup           => true);
    end loop;
    /*insert into Ln_Percent_Rate(Loan_Id,
                                Perc_Code_Desc,
                                Perc_Type,
                                First_Date,
                                Perc_Rate,
                                Summa,
                                Description,
                                Emp_Code,
                                Date_Modify)
      select i_Loan_Id,
             Perc_Code_Desc,
             'F',
             i_Perc_Date,
             Perc_Rate,
             0,
             '',
             Setup.Get_Employee_Code,
             v_Sysdate
        from Ln_Blank_Percent_Rate
       where Claim_Id = i_Claim_Id;
     --
      insert into Ln_Percent_Rate_His
        select Loan_Id,
               Perc_Code_Desc,
               Perc_Type,
               First_Date,
               Perc_Rate,
               Summa,
               Description,
               Emp_Code,
               Date_Modify,
               Share_Combined_Perc,
               'I' Action
          from Ln_Percent_Rate
      where loan_id = i_loan_id;*/
  end Save_Perc_Retes_From_Claim;
  ---------------------------------------------------------------------------------------------------
  -- Субсидии на ипотеку
  Procedure Save_Ms_Card (iLoan in Ln_Cache.Contrat_Loan_t, iEvent in Dw_Event_t) is

  begin
    insert into Ln_Ms_Card (Loan_Id,
                         Filial_Code,
                         Product_Id,
                         Perc_Rate,
                         First_Pay,
                         Object_Sum)
   values ( iLoan.Card.Loan_Id,
            iLoan.Card.Filial_Code,
            iLoan.Card.Product_Id,
            iEvent.Params.Get_Optional_Number('SUBSIDY_PERCENTAGE'),
            iEvent.Params.Get_Optional_Number('FIRST_PAY_FOR_SUBSIDES'),
            iEvent.Params.Get_Optional_Number('CALCULATED_OBJECT_AMOUNT'));
  end Save_Ms_Card;
---------------------------------------------------------------------
  procedure Add_Card(iLoan in Ln_Cache.Contrat_Loan_t) is
    --vErr_Log   varchar2(32767);
    vClaim_Id  integer;
    vLoans_Ids array_varchar2;
    vHash        hashtable := hashtable();
    --v_Loan_Id    number;
  begin
    vClaim_Id := Dw_Util.Get_Doc_Id( i_Doc_Type_Code        => 'LNCONTRACT'
                                   , i_Doc_Id               => iLoan.Card.Loan_Id
                                   , i_Obtain_Doc_Type_Code => 'LNCLAIM' );
    --
    vLoans_Ids := Dw_Util.Get_Docs_Id( i_Doc_Type_Code        => 'LNCLAIM'
                                     , i_Doc_Id               => vClaim_Id
                                     , i_Obtain_Doc_Type_Code => 'LNCONTRACT' );
    if vLoans_Ids.count > 1 then
      Ut.Raise_Err('Для текущей заявки уже заведен кредитный договор!');
    end if;
    --
    On_Create_Card( vClaim_Id );
    --
    Validate_Card_Data( iLoan => iLoan, iMode => Ln_Const.Add_Card );
    --
    --v_Loan_Id := iLoan.Card.Loan_id;
    begin
      insert into Ln_Card values iLoan.Card;
      --
      insert into Ln_Card_Additional values iLoan.Card_Additional;
      --
      Save_Credit_Sources( iLoan );
      --
      Save_Loan_Purposes( iLoan );
      --
      --Save_Loan_Report_Types( iLoan );
      --
      Save_Perc_Retes_From_Claim(iLoan.Card.Claim_Id, iLoan.Card.Loan_Id, iLoan.Card.Open_Date);
      --
      Log_Doc_Modification ( iDoc_Id         => iLoan.Card.Loan_Id
                           , iDoc_Type_Code  => 'LNCONTRACT'
                           , iState_Code     => null
                           , iNew_State_Code => iLoan.Card.Condition
                           , iDescription    => 'Создание нового кредитного договора' );
      --
      if Ln_Setting.Get_Sys_Param('PERSONAL_ACCESS') = 'Y' then
        insert into Ln_Access_Emp values ( iLoan.Card.Loan_Id, Setup.Get_Filial_Code, Setup.Get_Employee_Code );
      end if;
      ---
      Ln_Init.Set_Product(i_Product_Id => Ln_Init.Get_Product_Group_Id);
      if Ln_Init.Get_Product_Group_Id = Ln_Const.c_PGid_Ipka_Subsidies then
        vHash.put('PERC_CODE_DESC', array_varchar2('MSP'));
        vHash.put('FIRST_DATE',     array_varchar2(setup.Get_Operday));
        vHash.put('PERC_RATE',      array_varchar2(Ln_Util.Get_Loan_Param_Value(iLoan.Card.Loan_Id, 92)));
        vHash.put('SUMMA',          array_varchar2(0));
        vHash.put('PERC_TYPE',      array_varchar2('F'));
        vHash.put('DESCRIPTION',    array_varchar2(''));
        vHash.put('IS_MODE',        array_varchar2('S'));

        Ln_Operation.Operation_Action( iOperation_Code  => 'PERCENT_RATE_ADD'
                                     , iOperation_Mode  => 'M' -- ручной ввод
                                     , iHashParams      => vHash
                                     , iLoan_Id         => iLoan.Card.Loan_Id
                                     , iIs_Preview_Mode => 'OFF'
                                     , iRaise_Error     => true);
       end if;
      $IF Core_APP_Version.c_Header_Code <> 9012 $THEN
      if Ln_Cache.do_backup_online_loans.loan = 'N' then
             if Not Ln_Init.Is_Online_Product then
               Backup_Loan(i_Loan_Id => iLoan.Card.Loan_Id);
             end if;
             end if;
      $END
       --Ln_Kernel2.Floating_Rate_For_New_Card(iLoan.Card.Loan_Id, iLoan.Card.Product_Id);
       Ln_Pa.Create_Deal(i_Card => iLoan.Card);
    exception
      when DUP_VAL_ON_INDEX then
        Raise_Application_Error(-20000, 'У данного клиента уже существует кредит с указанным порядковым номером! Измените порядковый номер кредита!'
        || sqlerrm || dbms_utility.format_error_backtrace);
      when OTHERS then
        Raise_Application_Error( -20000, 'Ошибка при создании договора : ' || Ut.cCRLF || SqlErrM );
    end;
  end Add_Card;
-------------------------------------------------
  procedure Edit_Card( iNew_Loan in Ln_Cache.Contrat_Loan_t, iLoan in Ln_Cache.Contrat_Loan_t )
  is
    vAction           varchar2(100);
    vError_Log        varchar2(3000);
    vIs_Card_Admitted boolean := false;

    vCard      Ln_Card%rowtype := iLoan.Card;
    vNew_Card  Ln_Card%rowtype := iNew_Loan.Card;
    --vCard_Additional           Ln_Card_Additional%rowtype := iLoan.Card_Additional;
    vNew_Card_Additional       Ln_Card_Additional%rowtype := iNew_Loan.Card_Additional;
  begin
    if Not Ln_Init.Off_IABS_Actions_By_Init_Mod and Ln_Init.Off_All_iABS_Actions then
      Raise_Application_Error(-20000, 'По этому договору запрещено выполнять какие-либо действия в подсистеме "Кредиты"');
    end if;
    --
    if vCard.Filial_Code <> Setup.Get_Filial_Code then
      Ut.Raise_Err('Операция по редактированию текущего договора должна выполняться в филиале "' || vCard.Filial_Code || '"!');

    elsif vCard.Condition = Ln_Const.c_Loan_Closed then
      Ut.Raise_Err('Запрещено редактирование договоров в состоянии "Закрытая ссуда"!');
    end if;

    vIs_Card_Admitted := vCard.Condition <> Ln_Const.c_Loan_Not_Approved;

    vAction := case
                 when vIs_Card_Admitted then Ln_Const.Edit_Approved_Card
                 else Ln_Const.Edit_Not_Approved_Card
               end;

   -- Контроль изменения реквизитов в договоре
    if Ln_Util.Is_Access_Param_With_Clients('CHECK_CHANGE_LOAN', 'CHECK_LOAN_CHANGE_LOAN', Ln_Cache.Loan.LOAN_ID) = 'Y'/*Ln_Setting.Get_Sys_Param('CHECK_CHANGE_LOAN') = 'Y'*/ and vCard.Locking = Ln_Const.Loan_Locked and
        vCard.Condition >= 0 and -- кредит не утвержденный болса конроллар ишламасин
        Ln_Util.Is_Send_Card_Admission(vCard.Loan_Id)
      then
      vError_Log := Check_Locked_Card_Before_Edit( iNew_Loan, iLoan );

      if vError_Log is NOT Null then
        UT.Raise_Err( ' Реквизиты текущего договора заблокированы для изменения : ' || Ut.cCRLF || vError_Log );
      end if;
    end if;

    Validate_Card_Data( iLoan => iNew_Loan, iMode => vAction );

    if vIs_Card_Admitted then
      if Is_Agricultural_Loans_Used then
        Ln_Loan_Data.gClaim_Num   := vNew_Card.Claim_Number;
        Ln_Loan_Data.gClient_Code := vNew_Card.Client_Code;
        Ln_Loan_Data.gSumm_Loan   := vNew_Card.Summ_Loan;
        Ln_Loan_Data.gPurposeLoan := vNew_Card.Purpose_Loan;
        Ln_Loan_Data.gOpenDate    := vNew_Card.Open_Date;

        Event.Reaction_Run(75002, 1); --   SX_LN_ACTIONS.sxContractSumma
      end if;

      if Ln_Product.Is_Limits_Cont_Use_By_Product and
         Ln_Util.Is_Access_Param_With_Clients('CREDITING_CHECK_RESOURCE','CREDITING_CHECK_RESOURCE_CLIENTS', vNew_Card.Client_Code) = 'Y' and
         vNew_Card.Summ_Loan <> vCard.Summ_Loan then
        Ln_Setting.Loan_Request_Sum( vNew_Card.Filial_Code, vNew_Card.Loan_Id, vNew_Card.Summ_Loan );
      end if;
    end if;

    if vNew_Card.Open_Date <> vCard.Open_Date then
      --NBU uchun 01.09.2019 raschet den boshlanishi
      if Setup.Get_Headermfo <> '09002' or (Setup.Get_Headermfo = '09002' and vCard.Open_Date > to_date('01.09.2019', 'dd.mm.yyyy')) then
        Ln_Setting.Synchro_Calc_Date( vCard.Loan_Id, vNew_Card.Open_Date );
      end if;
    end if;

    if vNew_Card.Days_In_Year <> vCard.Days_In_Year then
      /*declare
        vLoan Ln_Init.Loan_T;
      begin*/
        Ln_Init.Set_Loan( vNew_Card.Loan_Id, true );
        --vLoan := Ln_Init.Get_Loan;
        Ln_Calculate.Del_Last_Calc_Perc_All/*( vLoan )*/;
      --end;
    end if;

    begin
      update Ln_Card
         set Row = vNew_Card
       where Loan_Id = vCard.Loan_Id;
      --
      update Ln_Card_Additional
             set row = vNew_Card_Additional
             where Loan_Id = vCard.Loan_Id;
      if sql%rowcount=0 then
       insert into Ln_Card_Additional values vNew_Card_Additional;
      end if;
      --
      update Ln_Nik_Card t
         set t.Cond_Nik = Nk_Const.Req_Not_Sent
       where t.Loan_Id = vCard.Loan_Id;
      Save_Credit_Sources( iNew_Loan );
      --
      Save_Loan_Purposes( iNew_Loan );
      --
      --Save_Loan_Report_Types( iNew_Loan );
      Ln_Cb.Set_Not_Send_Loans(i_Loan_Id => vCard.Loan_Id);
$IF Core_APP_Version.c_Header_Code <> 9012 $THEN
      if Ln_Cache.do_backup_online_loans.loan = 'N' then
        Backup_Loan(vCard.Loan_Id);
      end if;
$END

      /*if vIs_Card_Admitted then
        Backup_Loan( iNew_Loan );
      end if;*/

      Log_Doc_Modification ( iDoc_Id         => vCard.Loan_Id
                           , iDoc_Type_Code  => 'LNCONTRACT'
                           , iState_Code     => vCard.Condition
                           , iNew_State_Code => vNew_Card.Condition
                           , iDescription    => 'Корректировка кредитного договора'
                           );
    exception
      when OTHERS then
        Raise_Application_Error( -20000, 'Ошибка при обновлении договора : ' || Ut.cCRLF || SqlErrM );
    end;
  end Edit_Card;

  procedure Check_Agricultural_Loan( iEvent   in Dw_Event_t
                                   , iLoan_Id in number )
  is
    vSql          varchar2(32767);
    vProduct_Code varchar2(10);
    vPay_Sum      number(20);
    vAmount       number(20) := iEvent.Params.Get_Number('AMOUNT') * Ln_Service.Get_Currency_Scale;
  begin
    if (Is_Agricultural_Loans_Used) then
      begin
        vSql := 'select product_code ' ||
                     ', pay_sum ' ||
                  'from LN_AGR_CONTRACTS ' ||
                 'where claim_id = :1';
        execute immediate vSql into vProduct_Code
                                  , vPay_Sum
                              using Dw_Util.Get_Doc_Id( 'LNCONTRACT', iLoan_Id, 'LNCLAIM' );
        if (iEvent.Params.Get_Varchar2('CURRENCY_CODE') <> '000') then
          Ut.Raise_Err('В С/Х кредитах должен ипользоваться только сум (000)');
        end if;
        if (vProduct_Code <> iEvent.Params.Get_Varchar2('PURPOSE_CODE')) then
          Ut.Raise_Err('Невозможно сохранить договор! Цель кредита не соответствует продукту в С/Х контракте.');
        end if;
        if (vAmount > vPay_Sum) then
          Ut.Raise_Err('Невозможно сохранить договор! Сумма договора не должна быть больше чем сумма выдачи в С/Х контракте.');
        end if;
        vSql := 'update LN_AGR_CONTRACTS ' ||
                   'set loan_id = :1 ' ||
                 'where claim_id = :2';
        execute immediate vSql using iLoan_Id, Dw_Util.Get_Doc_Id( 'LNCONTRACT', iLoan_Id, 'LNCLAIM' );
      exception
        when NO_DATA_FOUND then
          -- Если С/Х контракт по claim_id не найден, значит кредит не связан с С/Х кредитованием, поэтому ничего не делаем
          null;
      end;
    end if;
  end Check_Agricultural_Loan;
  /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *     cохранение_изменение доп. параметри
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Save_Card_Param
  (
    i_Loan_Id number,
    i_Code    varchar2,
    i_Value   varchar2
  ) is
  begin
    Ln_Kernel.Save_Loan_Param(i_Loan_Id     => i_Loan_Id,
                              i_Object_Id   => i_Loan_Id,
                              i_Object_Code => 'CARD',
                              i_Code        => i_Code,
                              i_Value       => i_Value);
  end Save_Card_Param;
  ----------------------------------------------------------------------------------------------------
  Function Get_Card_Transfer_Rate
  (
    i_Loan  Ln_Cache.Contrat_Loan_t,
    i_Value in varchar2
  ) return varchar2 is
    v_Value Ln_Loan_Params.Value%type := i_Value;
  begin
    $IF core_app_version.c_Header_Code = 9005 $THEN
    if i_Value is null then
      begin
        v_Value := Tp_Api.Get_Percent(i_Currency => Currency.Get_Char_Code(i_Loan.Card.Currency), --'USD', --- Shartnoma valyutasi 
                                      i_Date     => i_Loan.Card.Contract_Date, -- shartnoma tuzilgan vaqti
                                      i_Day      => i_Loan.Card.Close_Date - i_Loan.Card.Open_Date);
      exception
        when others then
          null;
      end;
    end if;
    $END
    return v_value;
  end;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     cохранение_изменение договора
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  Procedure Save_Card(Ievent in Dw_Event_t) is
    Vnew_Loan    Ln_Cache.Contrat_Loan_t;
    Vloan        Ln_Cache.Contrat_Loan_t;
    Vhas_Product boolean := false;
    --====================================
    -- bez obespechiniya uchun 
    Procedure Check_Guar is
      v_Cnt     pls_integer := 0;
      v_Guar_Id number(12);
      v_Params  Hashtable := Hashtable();
    begin
      if Vnew_Loan.Card.Guar_Class <> 3 then
        return;
      end if;
      --  
      select count(*)
        into v_Cnt
        from Ln_Loan_Guar t
       where t.Loan_Id = Vnew_Loan.Card.Loan_Id
         and t.Guar_Type = 61
         and Rownum = 1;
      if v_Cnt = 1 then
        return;
      end if;
      v_Params.Put('guarTypeCode', 61);
      v_Params.Put('provisionGroup', -1);
      v_Params.Put('guarType', 61);
      v_Params.Put('collateralType', 801);
      v_Params.Put('credit_subject_type', 3);
      v_Params.Put('currGuar', vNew_Loan.Card.Currency);
      v_Params.Put('sumGuar', 0);
      v_Params.Put('status_pledge', 1);
      Dw_Api.Create_Or_Edit_Document(i_Doc_Type_Code => 'LNGUARANTEE',
                                     Io_Doc_Id       => v_Guar_Id,
                                     i_Folder_Id     => Dw_Util.Get_Folder_Id(i_Doc_Type_Code => 'LNCONTRACT',
                                                                              i_Doc_Id        => Vnew_Loan.Card.Loan_Id),
                                     i_Params        => v_Params);
    end Check_Guar;
    --====================================
  begin
    Retrieve_Card_Data_From_Dw(iEvent, vNew_Loan, vLoan);
    Ln_Product.Check_Card(i_Loan => vNew_Loan);
    for r in (select t.*,
                     decode(t.id, 127, 51, 71, 104, 65, 105, 128, 106, t.id) param_id
                from Ln_s_Loan_Params t
               where Condition = 'A'
                 and Object_Code = 'CARD')
    loop
      begin
        if Ln_Product.Has_Param_Value(r.param_id, vNew_Loan.Card.Product_Id) then
          Save_Card_Param(Vnew_Loan.Card.Loan_Id, r.code, Ln_Product.Get_Product_Param_By_Id(r.param_id, vNew_Loan.Card.Product_Id));
          vHas_Product := true;
        end if;
        if r.code = 'TRANSFER_RATE' then
          Save_Card_Param(Vnew_Loan.Card.Loan_Id, r.code, get_card_transfer_rate(vNew_Loan, iEvent.Params.Get_optional_Varchar2(r.Code))); 
        elsif iEvent.Params.Has(r.Code) then       
         Save_Card_Param(Vnew_Loan.Card.Loan_Id, r.Code, iEvent.Params.Get_Varchar2(r.Code));
        elsif not vHas_Product then
          Save_Card_Param(Vnew_Loan.Card.Loan_Id, r.Code, null);
        elsif r.Code in ('IS_ANNUITET') then
          Save_Card_Param(Vnew_Loan.Card.Loan_Id, r.Code, 'N');
        elsif r.Code in ('IS_SMALL_BIZ') then
          Save_Card_Param(Vnew_Loan.Card.Loan_Id, r.Code, 'N');
        end if;
      exception
        when others then
          Raise_Application_Error(-20000, r.Code || sqlerrm);
      end;
    end loop;
    --
    if iEvent.Creating_Document() then
      Add_Card(vNew_Loan);
      Save_Ms_Card(vNew_Loan, iEvent);
    else
      Edit_Card(vNew_Loan, vLoan);
    end if;
    --
    --if Event.Get_Event_Bxm(vNew_Loan.Card.Filial_Code,Core_Adm_Util.Get_Bxm_Code(vNew_Loan.Card.Local_Code),Event.Event_Closeday) <> 'N' then
      Ln_Operation.Set_Operation_Transact_Loans(i_Loan_Id                   => vNew_Loan.Card.Loan_Id,
                                                i_State                     => 'D',
                                                i_Is_Autonomous_Transaction => true);
    --end if; 
    --
    Check_Agricultural_Loan(iEvent, vNew_Loan.Card.Loan_Id);
    Ln_Init.Set_Loan(Iloan_Id => vNew_Loan.Card.Loan_Id, Iforce_Init => true);
    if iEvent.Creating_Document() and (vNew_Loan.Card.Product_Id in (-3) or Ln_Init.Is_Credit_Card_Product(vNew_Loan.Card.Product_Id)) then
      Ln_Overdraft.Add_Graph_After_Create_Card;
    end if;
    $IF Core_App_Version.c_Header_Code <> 9012 $THEN
      Check_Guar;
    $END
  end Save_Card;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     удаление старых заявок, не имеющих кредитного дела
*  @iClaim_Id - уникальный номер заявки
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
  procedure Delete_Claim( iClaim_Id in Ln_Claim.Claim_Id%type ) is
    --vClaim  Ln_Claim%rowtype;
  begin
    /*vClaim := Get_Claim_Rowtype(iClaim_Id);
    if vClaim.Cond_Nik NOT in (Nk_Api.cReq_Not_Sent, Nk_Api.cReq_Error ) and EXTRACT(YEAR FROM (setup.Get_OperDay - vClaim.Claim_Date) YEAR TO MONTH ) < Ln_Const.Docs_Archiving_Time_In_Years
    then
      Raise_Application_Error(-20000, 'Текущая заявка должна храниться 3 года, так как она зарегистрирована в НИКИ! Удаление отклонено!');
    end if;*/
    if Ln_Rci_Api_Out.Is_Claim_Adobted(i_Claim_Id => iClaim_Id) then
      Raise_Application_Error(-20000, 'Текущая заявка зарегистрирована в ГРКИ! Удаление отклонено!');
    end if;
    delete from ln_coborrowers where claim_id = iClaim_Id;
    delete from ln_claim where claim_id = iClaim_Id;
  end Delete_Claim;
-------------------------------------------------------------------------------
Procedure Close_Loan(Iloan_Id in Ln_Card.Loan_Id%type, i_Is_Backup_Loan boolean := true) is
    Vloan_State Ln_Card.Condition%type;
    type Loan_Accounts is record(
      Acc           Accounts.Code%type,
      Acc_Type      Ln_Account.Loan_Type_Account%type,
      Acc_Type_Name Ln_s_Loan_Type_Account.Name%type,
      Balance       number);
    type t_Loan_Accounts is table of Loan_Accounts;
    --type Refcursor is ref cursor;
    v_Report            varchar2(4000);
    Vln_Accounts       t_Loan_Accounts := t_Loan_Accounts();
    v_Product_Id       Ln_Card.Product_Id%type;
    v_Params           Hashtable := Hashtable();
    v_Sum_Guar         number;
    v_Guar_Ids         Array_Number;
    v_Err_Num          number;
    v_Client_Type      varchar2(2);
    v_Card             Ln_Card%rowtype;
    v_Od               date := Setup.Get_Operday;
    v_Product_Group_Id Ln_Products.Group_Id%type;
    v_Blank_State      Ln_Blanks.State_Id%type;
    i_Module_Code     varchar2(10) default 'LOAN';
  begin
    if Iloan_Id is null then
      Raise_Application_Error(-20000,
                              'Не передан уникальный номер договора! ');
    end if;
    --
    select t.Condition,
           t.Product_Id,
           (select Group_Id
              from Ln_Products
             where Product_Id = t.Product_Id
               and Rownum = 1),
           t.Client_Code,
           t.Filial_Code,
           t.Client_Id,
           t.Currency,
           t.claim_id
      into Vloan_State,
           v_Product_Id,
           v_Product_Group_Id,
           v_Card.Client_Code,
           v_Card.Filial_Code,
           v_Card.Client_Id,
           v_Card.Currency,
           v_Card.Claim_Id
      from Ln_Card t
     where t.Loan_Id = Iloan_Id;
    --
    begin
     Select c.stage_id
       into v_Blank_State
       From Ln_Blanks c
      where c.claim_id = v_Card.Claim_Id;
    exception when no_data_found then
      v_Blank_State := 0;
    end;
    --
    if Vloan_State = Ln_Const.c_Loan_Not_Approved then    
     if (v_Blank_State != 1 and 
        Ln_Setting.Get_Sys_Param('DEACTIVATE_CARD_ON_CLAIM_DELETE', Setup.Get_Headermfo) = 'N') then 
      Raise_Application_Error(-20000,
                              'Ваш договор не утвержден! Закрытие кредита отклонено!');
     end if;
    elsif Vloan_State = Ln_Const.c_Loan_Closed then
      Raise_Application_Error(-20000,
                              'Указанный кредит уже находится в состоянии "Закрытая ссуда"!');
    end if;
    if Ln_Init.Is_Overdraft_Product(v_Product_Id) and Ln_Overdraft.Get_Limit_Btrt(Iloan_Id) > 0 then
      Raise_Application_Error(-20000,
                              'Лимит не равен нулю! Закрытие кредита отклонено!');
    end if;
    if v_Product_Group_Id = Ln_Const.c_Pgid_Credit_Card_Acc then
      execute immediate 'begin :s := Ln_Credit_Card.Get_Card_Balance(i_Loan_Id => :i_Loan_Id); end;'
        using out v_Sum_Guar, in Iloan_Id;
      if v_Sum_Guar <> 0 then
        Raise_Application_Error(-20000,
                                'Баланс кредитной карты не равен нулю! Закрытие кредита отклонено');
      end if;
    end if;
    --
    v_Client_Type := Ln_Util.Get_Client_Subject_Code(i_Client_Code => v_Card.Client_Code,
                                                     i_Filial_Code => v_Card.Filial_Code,
                                                     i_Client_Id   => v_Card.Client_Id);
    -- Автоматические проводки по обеспечениям (945**) по физ.лицам
    if (v_Client_Type = '2' and
       Ln_Setting.Get_Sys_Param('GUAR_LEAD_AUTO_PHIS', Setup.Get_Headermfo) = 'Y') or
       (v_Client_Type in ('1', '3') and
       Ln_Setting.Get_Sys_Param('GUAR_LEAD_AUTO_JUR', Setup.Get_Headermfo) = 'Y') then
      begin
        select Nvl(Abs(a.Saldo_Out), 0) / 100
          into v_Sum_Guar
          from Ln_Account t, Accounts a
         where t.Loan_Id = Iloan_Id
           and t.Loan_Type_Account = 39
           and t.Date_Next = Ln_Const.c_Max_Date
           and a.Id = t.Acc_Id;
      exception
        when No_Data_Found then
          v_Sum_Guar := 0;
      end;
      --
      if v_Sum_Guar > 0 then
        v_Guar_Ids := Array_Number();
        for s in (select Guar_Id
                    from Ln_Loan_Guar
                   where Loan_Id = Iloan_Id
                     and Guar_Type <> 41)
        loop
          v_Guar_Ids.Extend;
          v_Guar_Ids(v_Guar_Ids.Count) := s.Guar_Id;
        end loop;
        v_Params.Put('LEAD_ACCOUNT_DEBET', Ln_Action_Param.Get_Loan_Account_Code(29));
        v_Params.Put('LEAD_ACCOUNT_NAME_DEBET', Ln_Action_Param.Get_Loan_Account_Name(29));
        v_Params.Put('LEAD_INN_DEBET', Ln_Action_Param.Get_Client_Inn(29));
        v_Params.Put('LEAD_ACCOUNT', Ln_Action_Param.Get_Loan_Account_Code(39));
        v_Params.Put('LEAD_ACCOUNT_NAME', Ln_Action_Param.Get_Loan_Account_Name(39));
        v_Params.Put('LEAD_INN', Ln_Action_Param.Get_Client_Inn(39));
        v_Params.Put('LEAD_DOC_NUMB', '');
        v_Params.Put('LEAD_TRANS_ID', '106');
        v_Params.Put('LEAD_ACT_ID', '41');
        v_Params.Put('LEAD_SUM_PAY', Ln_Service.Convert_Varchar(v_Sum_Guar));
        v_Params.Put('LEAD_SUM_PAY_IN_WORDS',
                     Slsumword(Csum         => v_Sum_Guar,
                               Vkod         => v_Card.Currency,
                               Error_Number => v_Err_Num));
        v_Params.Put('LOAN_CURRENCY', v_Card.Currency);
        v_Params.Put('LEAD_SYM_ID', '00599');
        v_Params.Put('LEAD_PURPOSE', Ln_Action_Param.Get_Action_Name('HAND_GUAR_104'));
        v_Params.Put('GUAR_ID', v_Guar_Ids);
        --17xxx schetdan kredit 2xxxx scheti summani olib utib olish
        Ln_Operation.Operation_Action(Ioperation_Code  => 'HAND_GUAR_104',
                                      Ioperation_Mode  => 'A',
                                      Ihashparams      => v_Params,
                                      Iloan_Id         => Iloan_Id,
                                      Iis_Preview_Mode => 'OFF',
                                      Iraise_Error     => true);
      end if;
      --
      begin
        select Nvl(Abs(a.Saldo_Out), 0) / 100
          into v_Sum_Guar
          from Ln_Account t, Accounts a
         where t.Loan_Id = Iloan_Id
           and t.Loan_Type_Account = 28
           and t.Date_Next = Ln_Const.c_Max_Date
           and a.Id = t.Acc_Id;
      exception
        when No_Data_Found then
          v_Sum_Guar := 0;
      end;
      --
      if v_Sum_Guar > 0 then
        v_Params.Put('LEAD_ACCOUNT_DEBET', Ln_Action_Param.Get_Loan_Account_Code(29));
        v_Params.Put('LEAD_ACCOUNT_NAME_DEBET', Ln_Action_Param.Get_Loan_Account_Name(29));
        v_Params.Put('LEAD_INN_DEBET', Ln_Action_Param.Get_Client_Inn(29));
        v_Params.Put('LEAD_ACCOUNT', Ln_Action_Param.Get_Loan_Account_Code(28));
        v_Params.Put('LEAD_ACCOUNT_NAME', Ln_Action_Param.Get_Loan_Account_Name(28));
        v_Params.Put('LEAD_INN', Ln_Action_Param.Get_Client_Inn(28));
        v_Params.Put('LEAD_DOC_NUMB', '');
        v_Params.Put('LEAD_TRANS_ID', '106');
        v_Params.Put('LEAD_ACT_ID', '41');
        v_Params.Put('LEAD_SUM_PAY', Ln_Service.Convert_Varchar(v_Sum_Guar));
        v_Params.Put('LEAD_SUM_PAY_IN_WORDS',
                     Slsumword(Csum         => v_Sum_Guar,
                               Vkod         => v_Card.Currency,
                               Error_Number => v_Err_Num));
        v_Params.Put('LOAN_CURRENCY', v_Card.Currency);
        v_Params.Put('LEAD_SYM_ID', '00599');
        v_Params.Put('LEAD_PURPOSE', Ln_Action_Param.Get_Action_Name('HAND_GUAR_157'));
        --17xxx schetdan kredit 2xxxx scheti summani olib utib olish
        Ln_Operation.Operation_Action(Ioperation_Code  => 'HAND_GUAR_157',
                                      Ioperation_Mode  => 'A',
                                      Ihashparams      => v_Params,
                                      Iloan_Id         => Iloan_Id,
                                      Iis_Preview_Mode => 'OFF',
                                      Iraise_Error     => true);
      end if;
    end if;
    --
    begin
      select t.Account_Code,
             t.Loan_Type_Account,
             (select At.Name
                from Ln_s_Loan_Type_Account At
               where At.Code = t.Loan_Type_Account) name,
             Abs(Bank.Get_Saldo_Out(t.Acc_Id) / Ln_Service.Get_Currency_Scale(v_Card.Currency))
        bulk collect
        into Vln_Accounts
        from Ln_Account t
       where t.Loan_Id = Iloan_Id
         and t.Loan_Type_Account in
             (select column_value
                from table(Ln_Const.c_Loan_Acc_Types)
             $IF core_app_version.c_Header_Code = 9013 $THEN
                union all
                select 111 from dual
             $END
            )
         and t.Date_Next > v_Od
         and t.Date_Validate <= v_Od;
      --
      for j in 1 .. Vln_Accounts.Count
      loop
        if Vln_Accounts(j).Balance <> 0 then
          Raise_Application_Error(-20000,
                                  'Кредит не может быть закрыт, так как на счете "' || Vln_Accounts(j).Acc_Type ||
                                  ' - ' || Vln_Accounts(j).Acc_Type_Name ||
                                  '" обнаружены остатки на сумму ' ||
                                  to_char(Abs(Vln_Accounts(j).Balance),
                                          'FM999G999G999G999G999G999G990D00999999',
                                          'NLS_NUMERIC_CHARACTERS=''. ''') || '!');
        end if;
      end loop;
    exception
      when No_Data_Found then
        Raise_Application_Error(-20000,
                                'Не найдены ссудные счета для договора с ID=' || Iloan_Id ||
                                '! Закрытие отклонено!');
    end;
    --
    update Ln_Card t
       set t.Condition   = Ln_Const.c_Loan_Closed,
           t.Date_Modify = sysdate,
           t.Emp_Code   =
           (select Setup.Get_Employee_Code
              from Dual)
     where t.Loan_Id = Iloan_Id;
     if i_Is_Backup_Loan then
       Backup_Loan_Card(Iloan_Id);
     end if;
    -- Delete from PR
    $if core_app_version.c_Header_Code <> 9012 $then
    for r in (select distinct Record_Id
                from Ln_Loan_Guar
               where Loan_Id = Iloan_Id)
    loop
      begin
        Pr_Api.Prepare_Del_Record(r.Record_Id, Ln_Const.Task_Code);
      exception
        when others then
          null;
      end;
    end loop;
    $end
    --
    Log_Doc_Modification(Idoc_Id         => Iloan_Id,
                         Idoc_Type_Code  => 'LNCONTRACT',
                         Istate_Code     => Vloan_State,
                         Inew_State_Code => Ln_Const.c_Loan_Closed,
                         Idescription    => 'Ручное закрытие ссуды');
    Ln_Contract.Closed_Acc_Before_Close_Loan(i_Loan_Id => Iloan_Id);
    -- send ГРКИ
    /*Rci_Api.Prepare_Send(i_Action   => Rci_Const.g_Set_State_To_Close,
                         i_Req_Type => Rci_Const.c_Auto,
                         i_Module_Code => i_Module_Code,
                         i_Table_Pk => Iloan_Id,
                         o_Rep      => v_Report);*/

      ln_rci_api_out.Close_Loan(i_Loan_Id     => Iloan_Id,
                                o_Err_Msg     => v_Report,
                                i_module_code => i_Module_Code);
		  
  end;
-------------------------------------------------------------------------------
Procedure Update_Card_Params_Checks(Icheck_New in Ln_Check_Card%rowtype) is
begin
  update Ln_Check_Card
     set row = Icheck_New
   where Md = Icheck_New.Md;
end;
-------------------------------------------------------------------------------
Procedure On_Create_Card(iClaim_Id in Ln_Claim.Claim_Id%type) is
  vClaim                      Ln_Claim%rowtype;
  vApprove_Appl_ON_Head_Level varchar2(1) := Ln_Setting.Get_Sys_Param_l('APPROVE_APPLICATIONS_ON_HEAD_LEVEL');
  v_Has_Blank                 varchar2(1);
begin
  vClaim := Get_Claim_Rowtype(iClaim_Id);
  if Not Ln_Init.Off_IABS_Actions_By_Init_Mod and Ln_Init.Off_All_iABS_Actions(vClaim.Creator_Code) then
    Raise_Application_Error(-20000, 'По этому договору запрещено выполнять какие-либо действия в подсистеме "Кредиты"');
  end if;
  select decode(count(*), 1, 'Y', 'N')
    into v_Has_Blank 
    from Ln_Blanks
   where Claim_Id = iClaim_Id;
  --
  if
  /*$IF Core_App_Version.c_Has_Branches $THEN
   Core_Adm_Util.Get_Local_Branch_Id(vClaim.Local_Code) <> Setup.Branch_Id
  $ELSE*/
   vClaim.Filial_Code <> Setup.Get_Filial_Code
  --$END
   then
    $IF Core_App_Version.c_Has_Branches $THEN
    Ut.Raise_Err('Создание нового договора по текущей заявке должно выполняться в подразделении "' ||
                 vClaim.Local_Code || '"!');
    $END
    Ut.Raise_Err('Создание нового договора по текущей заявке должно выполняться в филиале "' ||
                 vClaim.Filial_Code || '"!');
  
  elsif (Ln_Setting.Get_Sys_Param_l('BLANK_USED', vClaim.Local_Code) = 'N' or v_Has_Blank = 'N') and vApprove_Appl_ON_Head_Level = 'N' and 
         vClaim.Status <> Ln_Const.Claim_Accepted_By_Filial then
    Ut.Raise_Err('Текущая заявка не принята!');
  
  /*elsif vApprove_Appl_ON_Head_Level = 'Y' and vClaim.Status <> Ln_Const.Claim_Accepted_By_Head and not Ln_Init.Is_Online_Product and vClaim.Creator_Code <> 'FBCRM' then
    begin
      select 'Y'
        into vClaim.Err_Mess
        from Ln_Product_Params
       where Product_Id = vClaim.Product_Id
         and Param_Id = 61
         and Param_Value = 'Y';
    exception
      when No_Data_Found then
        Ut.Raise_Err('Текущая заявка не принята кредитным департаментом ГО!');
    end;*/
    --
    /*elsif Ln_Setting.Get_Sys_Param_l('BLANK_USED', vClaim.Local_Code) = 'N' and
        Ln_Setting.Get_Sys_Param('BAN_LOAN_APPROVAL_WO_NOTIFYING_NIKI_ABOUT_APPL') = 'Y' and vClaim.Cond_Nik <> Nk_Const.Req_Accepted then
    Ut.Raise_Err( 'Текущая заявка не принята в НИКИ!');*/
  end if;
  --
  if not Ln_Init.Is_Online_Product(vClaim.Product_Id) and
     Ln_Product.Product_Group_Id(vClaim.Product_Id) <> -16 and
     Ln_Setting.Get_Sys_Param('CREATE_AND_APPROVAL_CARD_ONLY_ACCEPTED_ASOKI_017',
                              Setup.Get_Headermfo) = 'Y' then
  
    --if nk_asoki_util.has_ln_his_ready_report_yn(vClaim.Claim_Id) = 'N' then
    if Ln_Asoki_Out.Has_Report_Yn(vClaim.Claim_Id) = 'N' then
      Ut.Raise_Err('CI-017 запрос не принят в АСОКИ');
    end if;
  end if;
end On_Create_Card;
-------------------------------------------------------------------------------
Function Set_Loans_Normal(Iloans_Ids in Array_Number) return varchar2 is
  Vsucc_Loans    integer := 0;
  Verr_Loans     integer := 0;
  result         varchar2(2000);
  Xloan_Unclosed exception;
  --type Refcursor is ref cursor;
  v_Report  varchar2(4000);
  i_Module_Code    varchar2(10) default 'LOAN';
begin
  for Loans in (select t.*
                  from Ln_Card t
                 where t.Loan_Id in (select *
                                       from table(cast(Iloans_Ids as Array_Number))))
  loop
    begin
      if Loans.Condition <> Ln_Const.c_Loan_Closed then
        raise Xloan_Unclosed;
      end if;
      --
      update Ln_Card t
         set t.Condition   = Ln_Const.c_Loan_Normal,
             t.Date_Modify = sysdate,
             t.Emp_Code   =
             (select Setup.Get_Employee_Code
                from Dual)
       where t.Loan_Id = Loans.Loan_Id;
      Backup_Loan_Card(Loans.Loan_Id);
      Log_Doc_Modification(Idoc_Id         => Loans.Loan_Id,
                           Idoc_Type_Code  => 'LNCONTRACT',
                           Istate_Code     => Loans.Condition,
                           Inew_State_Code => Ln_Const.c_Loan_Normal,
                           Idescription    => 'Принудительный перевод ссуды в состояние "Текущая ссуда"');
    
      Vsucc_Loans := Vsucc_Loans + 1;
      /*-- send ГРКИ
      Rci_Api.Prepare_Send(i_Action   => Rci_Const.g_Save_Contract_Restore,
                           i_Req_Type => Rci_Const.c_Auto,
                           i_Module_Code => i_Module_Code,
                           i_Table_Pk => Loans.Loan_Id,
                           o_Rep      => v_Report);*/

      ln_rci_api_out.Set_Loans_Normal(i_Loan_Id     => Loans.Loan_Id,
                                      o_Err_Msg     => v_Report,
                                      i_module_code => i_Module_Code);
    exception
      when Xloan_Unclosed then
        Verr_Loans := Verr_Loans + 1;
      when others then
        Verr_Loans := Verr_Loans + 1;
    end;
  end loop;

  result := 'В состояние "Текущая ссуда" переведено : ' || Vsucc_Loans || Ut.Ccrlf ||
            'Не удалось перевести : ' || Verr_Loans;
  return result;
end;
-------------------------------------------------------------------------------
Function Get_Accessible_Loans_4_Cur_Emp return Array_Number is
  Vloan_Ids Array_Number;
begin
  select /*+ index (t LN_ACCESS_EMP_IDX) */
   t.Loan_Id
    bulk collect
    into Vloan_Ids
    from Ln_Access_Emp t
   where t.Filial_Code = Setup.Filial_Code
     and t.Emp_Code = Setup.Employee_Code;
  return Vloan_Ids;
end Get_Accessible_Loans_4_Cur_Emp;
-------------------------------------------------------------------------------
Function Is_Limits_Control_Used return boolean is
begin
  return Ln_Setting.Get_Sys_Param('CREDITING_CHECK_RESOURCE', Setup.Get_Filial_Code) <> 'N';
end;
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*     Выравнивание(корректировка) состояний кредитов
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
Function Adjust_Loans_States(Iloans_Ids in Array_Number) return varchar2 is
  Vsucc_Loans integer := 0;
  Verr_Loans  integer := 0;
  result      varchar2(2000);
begin
  for i in Iloans_Ids.First .. Iloans_Ids.Last
  loop
    begin
      Set_Loan_State(Iloans_Ids(i));
      Vsucc_Loans := Vsucc_Loans + 1;
    exception
      when others then
        Verr_Loans := Verr_Loans + 1;
    end;
  end loop;
  result := 'Синхронизировано кредитов : ' || Vsucc_Loans || Ut.Ccrlf ||
            'Не удалось синхронизировать : ' || Verr_Loans;
  return result;
end;
-------------------------------------------------------------------------------
Function Get_Loan_Id(iClaim_Id in integer) return integer is
  vClaimid Dw_Documents.Doc_Id%type := iClaim_Id;
  Vresult  Ln_Card.Loan_Id%type;
begin
  select /*+ index (t1 DW_DOCUMENTS_PK) index (t2 DW_DOCUMENTS_UK1) */
   T2.Doc_Id
    into Vresult
    from Dw_Documents T1, Dw_Documents T2
   where T1.Doc_Type_Code = 'LNCLAIM'
     and T1.Doc_Id = vClaimid
     and T2.Doc_Type_Code = 'LNCONTRACT'
     and T2.Folder_Id = T1.Folder_Id
     and Rownum = 1;
  return Nvl(Vresult, 0);
exception
  when No_Data_Found then
    return 0;
end Get_Loan_Id;
-------------------------------------------------------------------------------
Function Get_Loan_State(iClaim_Id in integer) return integer -- todo после внедрения нового НИКИ убрать эту функцию из Ln_V_Card - тормозит на головном
 is
  Vloanid Ln_Card.Loan_Id%type := Get_Loan_Id(iClaim_Id);
  result  integer;
begin
  select /*+ index (t LN_CARD_PK) */
   Decode(t.Condition, 1, 111, 2, 112, 3, 113, 4, 114, 5, 115, 6, 116, 99, 1199, t.Condition)
    into result
    from Ln_Card t
   where t.Loan_Id = Vloanid;
  return result;
exception
  when others then
    return - 9;
end Get_Loan_State;
-------------------------------------------------------------------------------
Procedure Request_Crediting_Limits(Iloan_Id in number) is
  vClaim_Id  Ln_Claim.Claim_Id%type;
  Verror_Log varchar2(3000);
  Vloan      Ln_Cache.Contrat_Loan_t;
begin
  if Is_Header_Bank then
    Raise_Application_Error(-20000,
                            'Лимиты кредитования не должны запрашиваться Головным Офисом! Запрос лимита отклонен!');
  
  elsif Ln_Util.Is_Access_Param_With_Clients('CREDITING_CHECK_RESOURCE',
                                             'CREDITING_CHECK_RESOURCE_CLIENTS',
                                             Vloan.Card.Client_Code) <> 'Y' then
    Raise_Application_Error(-20000,
                            'Лимиты кредитования в Вашем филиале отключены! Обратитесь в ГО!');
  end if;

  Vloan := Get_Loan_Object(Iloan_Id);

  if Ln_Setting.Get_Sys_Param('BAN_LOAN_APPROVAL_WO_NOTIFYING_RCI_ABOUT_APPL') = 'Y' then
    vClaim_Id := Dw_Util.Get_Doc_Id('LNCONTRACT', Vloan.Card.Loan_Id, 'LNCLAIM');
    --if not Data_Exists('Ln_Claim', 'Claim_Id=' || vClaim_Id || ' and Cond_Nik=''' || Nk_Const.Req_Accepted || '''') then
    if Not Ln_Rci_Api_Out.Is_Claim_Adobted(i_Claim_Id => vClaim_Id) then
      --Raise_Application_Error(-20000, 'По данному кредиту заявка еще не принята в НИКИ! Запрос лимита отклонен!');
      Raise_Application_Error(-20000, 'По данному кредиту заявка еще не принята в ГРКИ! Запрос лимита отклонен!');
    end if;
  end if;

  if Vloan.Card.Condition in (Ln_Const.c_Loan_Unused, Ln_Const.c_Loan_Closed) then
    Raise_Application_Error(-20000,
                            'Запрещен запрос лимитов по закрытым и неиспользованным ссудам!');
  end if;

  Validate_Card_Data(Iloan => Vloan, Imode => Ln_Const.Admit_Card);

  if not Is_Guarantee_Valid(Vloan.Card.Loan_Id, Verror_Log) then
    Raise_Application_Error(-20000,
                            Verror_Log || Ut.Ccrlf || 'Запрос лимита отклонен!');
  
  elsif not Is_Percent_Rates_Valid(Vloan.Card, Verror_Log) then
    Raise_Application_Error(-20000,
                            Verror_Log || Ut.Ccrlf || 'Запрос лимита отклонен!');
  
  elsif not Is_Mode_Actions_Valid(Vloan.Card.Loan_Id,
                                  Vloan.Card.Card_Type,
                                  Vloan.Card.Product_Id,
                                  Verror_Log) then
    Raise_Application_Error(-20000,
                            Verror_Log || Ut.Ccrlf || 'Запрос лимита отклонен!');
  end if;

  Ln_Setting.Loan_Request_Sum(Vloan.Card.Filial_Code, Vloan.Card.Loan_Id, Vloan.Card.Summ_Loan);
end Request_Crediting_Limits;
-------------------------------------------------------------------------------
  function Get_Loan_State( iCard    in Ln_Card%rowtype
                         , iOperDay in date := Setup.Get_OperDay )
  return Ln_Card.Condition%type
  is
    type rAccounts is record( Acc                 Accounts.Code%type
                            , Acc_Type            Ln_Account.Loan_Type_Account%type
                            , Saldo               number
                            , Turnover_All_Debit  number );

    type tAccounts is table of rAccounts;
    vAccounts tAccounts := tAccounts();

    vCount              pls_integer;
    result              Ln_Card.Condition%type;
    --vSign_Prolong       varchar2(1);
    --vParam_Is_Open_Loan boolean;
    vLoan_Acc_Turnover     number := 0;
    vCapital_Acc_Turnover  number := 0;
    vSsudniAcc             number := 0;
    vProlongacc            number := 0;
    vProsrochAcc           number := 0;
    vSpisAcc               number := 0;
    vSudacc                number := 0;
    --vBanktoclient          number := 0;
    vAllsum                number := 0;
    vOther                 number := 0;
    vZalog                 number := 0;
    vAny_Percent_Debt      number := 0;
    vSumm_Limit            number;
    vProduct_Group_Id      Ln_Products.Group_Id%type;
  begin
    if iCard.Condition = Ln_Const.c_Loan_Not_Approved then
      return iCard.Condition;
    end if;
    --
    select count(*) into vCount
      from Ln_Account t
     where t.Loan_Id = iCard.Loan_Id
       and t.Date_Validate <= iOperDay
       and rownum = 1;
    --
    if vCount = 0 then
      return case
               when iCard.Close_Date >= iOperDay then Ln_Const.c_Loan_Unused
               else Ln_Const.c_Loan_Closed
             end;
    end if;
    --
    vCount := 0; --SR qo`shdi prolongatsiya statusi noto`g`ri bo`votgani uchun
    if iCard.Loan_Id = Ln_Cache.Loan.Loan_Id then
      vProduct_Group_Id := Ln_Cache.Loan.Product_Group_Id;
    else
      vProduct_Group_Id := Ln_Product.Product_Group_Id(iCard.Product_Id);
    end if;
    --
    /*select count(*) into vCount
      from Ln_Graph_Debt t
     where t.Loan_Id = iCard.Loan_Id
       and t.Sign_Long = 1
       and rownum = 1
       and t.Date_Red < (select --+ index_desc (d LN_GRAPH_DEBT_PK)
                                d.Date_Red
                           from Ln_Graph_Debt d
                          where d.Loan_Id = t.Loan_Id
                            and d.Sign_Long = 0
                            and d.Date_Red <= iOperDay
                            and rownum = 1);*/
    --
    if vProduct_Group_Id in (Ln_Const.c_Pgid_Overdraft, Ln_Const.c_Pgid_Mobile_Overdraft) then
      if 'GRAPH_NO_LIMIT' = Ln_Product.Get_Product_Param('SENDING_BTRT25_ACCORDING_TO', iCard.Product_Id, false) then 
        vSumm_Limit := -1;
      else
        begin
          select --+ index_desc (t LN_OVERDRAFT_LIMIT_PK)
           t.Summ_Limit
            into vSumm_Limit
            from Ln_Overdraft_Limit t
           where t.Loan_Id = iCard.Loan_Id
             and t.Date_Limit <= iOperDay
             and t.Condition = 1
             and Rownum = 1;
        exception
          when No_Data_Found then
            vSumm_Limit := 0;
        end;
      end if;
    end if;
    --
    if iOperDay = Setup.Get_Operday then
      select t.Account_Code, 
             t.Loan_Type_Account, 
             Abs(a.Saldo_Out), 
             Turnover_All_Debit
             + Turnover_All_Credit 
             + Decode(a.Cross_Acc_Id, null, 0, (select Turnover_All_Debit + Turnover_All_Credit from Accounts c where c.Id = a.Cross_Acc_Id))
        bulk collect into vAccounts
        from Ln_Account t, Accounts a
       where t.Loan_Id = iCard.Loan_Id
         and t.Loan_Type_Account in (select Column_Value
                  from table(Ln_Const.c_Loan_Acc_Types))
         and t.Date_Next > iOperDay
         and t.Date_Validate <= iOperDay
         and t.Acc_Id = a.Id;
    else
      select Account_Code,
             Loan_Type_Account,
             Nvl(t.Saldo_Start.Saldo_Out, 0),
             Nvl(t.Saldo_Start.Turnover_All_Debit,0) + Nvl(t.Saldo_Start.Turnover_All_Credit, 0)
        bulk collect into vAccounts
        from (select t.Account_Code,
                     t.Loan_Type_Account,
                     (select /*+ index_desc (s PK_Saldo_) */
                       Core_Acc_Saldo_t(null,
                                        null,
                                        null, -- Saldo_In
                                        Abs(s.Saldo_Out), -- Saldo_Out
                                        null, -- Saldo_Equival_In
                                        null, -- Saldo_Equival_Out
                                        null, -- Turnover_Debit
                                        null, -- Turnover_Credit
                                        s.Turnover_All_Debit, -- Turnover_All_Debit
                                        s.Turnover_All_Credit, -- Turnover_All_Credit
                                        null -- Lead_Last_Date
                                        ) as Saldo_Start
                        from Saldo s
                       where s.Code_Filial = iCard.Filial_Code
                         and s.Id = t.Acc_Id
                         and s.Oper_Day <= iOperDay
                         and Rownum = 1) as Saldo_Start
                from Ln_Account t
               where t.Filial_Code = iCard.Filial_Code
                 and t.Loan_Id = iCard.Loan_Id
                 and t.Loan_Type_Account in (select Column_Value from table(Ln_Const.c_Loan_Acc_Types))
                 and t.Date_Next > iOperDay
                 and t.Date_Validate <= iOperDay) t;
    end if;
    for j in 1 .. vAccounts.Count loop

      if vAccounts(j).Acc_Type = 1 Then
        vSsudniAcc            := vAccounts(j).Saldo;
        vCapital_Acc_Turnover := vAccounts(j).Turnover_All_Debit;
        vLoan_Acc_Turnover    := vAccounts(j).Turnover_All_Debit + vLoan_Acc_Turnover;
        
      elsif vAccounts(j).Acc_Type = 4 Then
        vProlongAcc        := vAccounts(j).Saldo;
        vLoan_Acc_Turnover := vAccounts(j).Turnover_All_Debit + vLoan_Acc_Turnover;
        
      elsif vAccounts(j).Acc_Type = 5 Then
        vProsrochAcc       := vAccounts(j).Saldo;
        vLoan_Acc_Turnover := vAccounts(j).Turnover_All_Debit + vLoan_Acc_Turnover;
        
      elsif vAccounts(j).Acc_Type in (8, 105) Then
        vSudAcc            := vAccounts(j).Saldo + vSudAcc;
        vLoan_Acc_Turnover := vAccounts(j).Turnover_All_Debit + vLoan_Acc_Turnover;
        
      elsif vAccounts(j).Acc_Type in (34, 69) Then
        vSpisAcc           := vSpisAcc + vAccounts(j).Saldo;
        vLoan_Acc_Turnover := vAccounts(j).Turnover_All_Debit + vLoan_Acc_Turnover;
      
      elsif vAccounts(j).Acc_Type in (3,7,11,13,22,30,46,55,57,62,65,67,74,79,82,83,90,92,94,95,97,100,116,118) then
        vAny_Percent_Debt  := vAny_Percent_Debt + vAccounts(j).Saldo;
        vLoan_Acc_Turnover := vAccounts(j).Turnover_All_Debit + vLoan_Acc_Turnover;
      
      elsif vAccounts(j).Acc_Type in (6/*, 24, 26*/) then
        vOther             := vOther + vAccounts(j).Saldo;

      elsif vAccounts(j).Acc_Type in (24, 26, 28, 39, 71) then
        vZalog             := vZalog + vAccounts(j).Saldo;

      end if;

      vAllSum := vAllSum + vAccounts(j).Saldo;
    end loop;
    --vParam_Is_Open_Loan := Ln_Setting.Get_Sys_Param('OPEN_LINE_LOAN_TO_CLOSED_IF_ALL_ACCS_A_0', Setup.Get_HeaderMFO) = 'Y';
    result := iCard.Condition;

    if vAllSum = 0 and iCard.Close_Date >= iOperDay and iCard.Condition <> Ln_Const.c_Loan_Closed then
      if vProduct_Group_Id in (Ln_Const.c_Pgid_Overdraft, Ln_Const.c_Pgid_Mobile_Overdraft) then
        if Nvl(vSumm_Limit, -1) = 0 then
          result := Ln_Const.c_Loan_Closed;
        elsif result = Ln_Const.c_Loan_Closed then
          result := Ln_Const.c_Loan_Normal;
        end if;
      end if;
    elsif vAllSum = 0 then
      result := Ln_Const.c_Loan_Closed;
    elsif vSpisAcc <> 0 then
      result := Ln_Const.c_Loan_Cancelled;
    elsif vSudAcc <> 0 then
      result := Ln_Const.c_Loan_In_Trial;
    elsif vProsrochAcc <> 0 and vProlongAcc <> 0  then
      result := Ln_Const.c_Loan_Part_Prolonged_Overdue;
    elsif (vSsudniAcc  <> 0 and vProsrochAcc <> 0) or (vSsudniAcc <> 0 and vProlongAcc <> 0) or
          (vProlongAcc <> 0 and vCount > 0) then
      result := Ln_Const.c_Loan_Phase_PastDue_Prolonged;
    elsif vProsrochAcc <> 0 then
      result := Ln_Const.c_Loan_Past_Due;
    elsif vProlongAcc <> 0 then
      result := Ln_Const.c_Loan_Prolonged;
    elsif vSsudniAcc = 0 and vProlongAcc = 0 and vProsrochAcc = 0 and vSudAcc = 0 and vAny_Percent_Debt <> 0 then
      result := Ln_Const.c_Loan_With_Percent_Debt;
    elsif vSsudniAcc = 0 and vZalog <> 0 then
      if vCapital_Acc_Turnover + vLoan_Acc_Turnover = 0 then
        result := Ln_Const.c_Loan_Not_Granted;
        $if core_app_version.c_Header_Code = 9002 $then
          if iCard.Open_Date < to_date('01.09.2019', 'dd.mm.yyyy') then
            result := Ln_Const.c_Loan_Waiting_Pledge;
          end if;
        $end
      else
        result := Ln_Const.c_Loan_Waiting_Pledge;
      end if;
    elsif vSsudniAcc = 0 and vCapital_Acc_Turnover + vLoan_Acc_Turnover <> 0 and Is_Loan_Open_End_Credit(iCard.Loan_Type) then
      result := Ln_Const.c_Loan_Waiting_Pledge;
    elsif vSsudniAcc <> 0 or (vOther + vZalog) <> 0 then
      if vCapital_Acc_Turnover + vLoan_Acc_Turnover = 0 then
        result := Ln_Const.c_Loan_Not_Granted;
        $if core_app_version.c_Header_Code = 9002 $then
          if iCard.Open_Date < to_date('01.09.2019', 'dd.mm.yyyy') then
            result := Ln_Const.c_Loan_Normal;
          end if;
        $end
      else
        result := Ln_Const.c_Loan_Normal;
      end if;
    else
      result := Ln_Const.c_Loan_Normal;
    end if;
    return result;
  end Get_Loan_State;
-------------------------------------------------------------------------------
  procedure Set_Sign_EBRD( iLoans_Ids in array_number )
  is
  begin
    update LN_Card t
       set t.Sign_EBRD = 1
     where exists ( select 'X' from table( cast(iLoans_Ids as array_number) ) where column_value = t.Loan_Id )
    ;
  end Set_Sign_EBRD;
-------------------------------------------------------------------------------
  function Is_Hamkor_Bank return boolean
  is
  begin
    return Setup.HeaderMfo = '09012';
  end Is_Hamkor_Bank;
-------------------------------------------------------------------------------
  Procedure Save_Loan_Conversion
  (
    i_Loan_Id         Ln_Card.Loan_Id%type,
    i_Conversion_Yn   varchar2,
    i_Conversion_Date Array_Date,
    i_Amount          Array_Number
  ) is
    v_Conversion      Ln_Loan_Conversions%rowtype;
    v_Conversion_Date Array_Date;
    v_Dublicate_Dates varchar2(101);
  begin
    Ln_Kernel.Save_Loan_Param(i_Loan_Id, i_Loan_Id, 'CONVERSION', 'CONVERSION_YN', i_Conversion_Yn);
    v_Conversion_Date := Nvl(i_Conversion_Date, Array_Date());
    select Substr(String_Agg(distinct Adm_Rep_Util.f_Date(Column_Value)), 1, 100)
      into v_Dublicate_Dates
      from (select Column_Value,
                   Row_Number() Over(partition by Column_Value order by Column_Value) Rn
              from table(v_Conversion_Date))
     where Rn <> 1;
    if v_Dublicate_Dates is not null then
      Raise_Application_Error(-20000, v_Dublicate_Dates);
    end if;
    --
    for r in (select t.*, rowid Rid
                from Ln_Loan_Conversions t
               where Loan_Id = i_Loan_Id
                 and Conversion_Date not member of v_Conversion_Date)
    loop
      delete from Ln_Loan_Conversions
       where rowid = r.Rid;
      insert into Ln_Loan_Conversions_His
      values
        (r.Loan_Id, r.Conversion_Date, r.Amount, -1, 'D', sysdate, Setup.Get_Employee_Code);
    end loop;
    --
    if i_Conversion_Yn = 'Y' then
      for i in 1 .. v_Conversion_Date.Count
      loop
        begin
          select *
            into v_Conversion
            from Ln_Loan_Conversions
           where Loan_Id = i_Loan_Id
             and Conversion_Date = v_Conversion_Date(i);
          if i_Amount(i) != v_Conversion.Amount then
            update Ln_Loan_Conversions
               set Amount      = i_Amount(i),
                   Modified_On = sysdate,
                   Modified_By = Setup.Get_Employee_Code
             where Loan_Id = i_Loan_Id
               and Conversion_Date = v_Conversion_Date(i);
            insert into Ln_Loan_Conversions_His
            values
              (v_Conversion.Loan_Id,
               v_Conversion.Conversion_Date,
               v_Conversion.Amount,
               i_Amount(i),
               'U',
               sysdate,
               Setup.Get_Employee_Code);
          end if;
        exception
          when No_Data_Found then
            insert into Ln_Loan_Conversions
            values
              (i_Loan_Id,
               v_Conversion_Date(i),
               i_Amount(i),
               sysdate,
               Setup.Get_Employee_Code,
               sysdate,
               Setup.Get_Employee_Code);
            insert into Ln_Loan_Conversions_His
            values
              (i_Loan_Id,
               v_Conversion_Date(i),
               -1,
               i_Amount(i),
               'I',
               sysdate,
               Setup.Get_Employee_Code);
        end;
      end loop;
    end if;
  end Save_Loan_Conversion;
  ---------------------------------------------------------------------------------------------------
  Procedure Save_Graph_Revenue
  (
    i_Loan_Id       number,
    i_Date_Revenues Array_Date,
    i_Amounts       Array_Number
  ) is
    v_Count   pls_integer;
    v_Id      Ln_Graph_Revenue.Id%type;
    v_Bd      date := Setup.Bankday;
    v_Sysdate date := sysdate;
    v_User_Id number(12) := Setup.Get_Employee_Code;
    v_Action  varchar2(1);
  begin
    select count(*)
      into v_Count
      from Ln_Graph_Revenue
     where Loan_Id = i_Loan_Id;
    if v_Count > 0 then
      if Ln_Util.Is_Access_Param_With_Clients('CHANGE_GRAPH_REVENUE',
                                              'CHECK_LOANS_CHANGE_GRAPH_REVENUE',
                                              to_char(i_Loan_Id)) = 'Y' then
        Raise_Application_Error(-20000,
                                'Запрешено изменения графика поступлении выручки. Обратитес в ГО!');
      end if;
    end if;
  
    if i_Date_Revenues.Count = 0 then
      v_Action := 'D';
      insert into Ln_Graph_Revenue_His
        select Id, Loan_Id, Date_Revenue, Amount, Modified_By, Modified_On, v_Action, v_Bd Oper_Day
          from Ln_Graph_Revenue
         where Loan_Id = i_Loan_Id;
      delete from Ln_Graph_Revenue
       where Loan_Id = i_Loan_Id;
    else
      for i in 1 .. i_Date_Revenues.Count
      loop
        select Nvl(v_Count, 0) + count(*)
          into v_Count
          from Ln_Graph_Revenue
         where Loan_Id = i_Loan_Id
           and Date_Revenue = i_Date_Revenues(i)
           and Amount = i_Amounts(i);
      end loop;
      if v_Count != i_Date_Revenues.Count then
        delete from Ln_Graph_Revenue
         where Loan_Id = i_Loan_Id;
        if sql%rowcount = 0 then
          v_Action := 'I';
        else
          v_Action := 'U';
        end if;
        --  
        select Ln_Graph_Revenue_Sq.Nextval
          into v_Id
          from Dual;
        --
        for i in 1 .. i_Date_Revenues.Count
        loop
          if i_Date_Revenues(i) is not null then
            insert into Ln_Graph_Revenue
              (Id, Loan_Id, Date_Revenue, Amount, Modified_By, Modified_On)
            values
              (v_Id, i_Loan_Id, i_Date_Revenues(i), i_Amounts(i), v_User_Id, v_Sysdate);
          end if;
        end loop;
        insert into Ln_Graph_Revenue_His
          select Id, Loan_Id, Date_Revenue, Amount, Modified_By, Modified_On, v_Action Action, v_Bd
            from Ln_Graph_Revenue
           where Loan_Id = i_Loan_Id;
      else
        Raise_Application_Error(-20000, 'Данные не изменились!');
      end if;
    end if;
  end Save_Graph_Revenue;
  ---------------------------------------------------------------------------------------------------
  Procedure Nik_Card_Not_Sent(i_Loan_Id Ln_Card.Loan_Id%type) is
  begin
    update Ln_Nik_Card t
       set t.Cond_Nik = Nk_Const.Req_Not_Sent
     where t.Loan_Id = i_Loan_Id;
  end Nik_Card_Not_Sent;
  ---------------------------------------------------------------------------------------------------
  Procedure Check_Card_For_Admission(i_Loan_Id Ln_Card.Loan_Id%type) is
    Vloan Ln_Cache.Contrat_Loan_t;
  begin
    Vloan := Get_Loan_Object(Iloan_Id => i_Loan_Id);
    On_Admit_Card(Vloan);
  end Check_Card_For_Admission;
  ----------------------------------------------------------------------------------------------------
  Procedure Check_Unapproved_Loans(i_Filial_Code varchar2) is
    v_Loan_Ids Array_Number;
    v_Date     date := Setup.Get_Operday;
    v_Day      integer;
  begin
    begin
      v_Day := Ln_Service.Convert_Number(Ln_Setting.Get_Sys_Param('AUTO_CLOSE_UNAPPROVED_LOANS_STATE_IN_DAYS',
                                                                  Setup.Get_Headermfo));
    exception
      when others then
        v_Day := 0;
    end;
    if v_Day <= 0 then
      return;
    end if;
    --
    select Loan_Id
      bulk collect
      into v_Loan_Ids
      from Ln_Card
     where Filial_Code = i_Filial_Code
       and Condition = Ln_Const.c_Loan_Not_Approved
       and Open_Date < v_Date - v_Day;
    /*update Ln_Card
       set Condition = Ln_Const.c_Loan_Closed
     where Filial_Code = i_Filial_Code
       and Condition = Ln_Const.c_Loan_Not_Approved
       and Open_Date < v_Date - v_Day
    returning Loan_Id bulk collect into v_Loan_Ids;*/
    for i in 1 .. v_Loan_Ids.Count
    loop
      update Ln_Card
         set Condition   = Ln_Const.c_Loan_Closed,
             Emp_Code    = Setup.Get_Employee_Code,
             Date_Modify = sysdate
       where Loan_Id = v_Loan_Ids(i);
      Backup_Loan_Card(v_Loan_Ids(i));
      Log_Doc_Modification(Idoc_Id         => v_Loan_Ids(i),
                           Idoc_Type_Code  => 'LNCONTRACT',
                           Istate_Code     => Ln_Const.c_Loan_Not_Approved,
                           Inew_State_Code => Ln_Const.c_Loan_Closed,
                           Idescription    => 'Договор закрыт автоматически в соответствии с настройками (' ||
                                              v_Day || ' дней "Неутвержденнная ссуда".)');
    end loop;
  end Check_Unapproved_Loans;
  -------------------------------------------------------------------------------------------------
  Procedure Closed_Acc_Before_Close_Loan(i_Loan_Id number) is
    v_Dummy      s_Client_Operation.Dialog_Need%type;
    v_Operation  s_Client_Operation.Operation%type := '7';
    v_Message    varchar2(2000);
    --v_Client_Uid Ln_Card.Client_Uid%type;
    v_Client_Id  Ln_Card.Client_Id%type;
    v_Sub_Coa    s_Sub_Coa.Sub_Code%type := '000000';
    v_Filial_Code varchar2(5);
  begin
    if 'Y' = Ln_Setting.Get_Sys_Param('CLOSED_ALL_ACC_BEFORE_CLOSE_LOAN', Setup.Get_Headermfo) then
      select Filial_Code, /*Client_Uid, */Client_Id
        into v_Filial_Code, /*v_Client_Uid, */v_Client_Id
        from Ln_Card
       where Loan_Id = i_Loan_Id;
      if dbms_job.is_jobq then 
        Setup.Set_iabs(v_Filial_Code);
      end if;
      for r in (select t.Loan_Id, a.Code, t.Filial_Code, t.Acc_Id
                  from Ln_Account t, Accounts a
                 where t.Loan_Id = i_Loan_Id
                   and t.Loan_Type_Account Not In (2,102)
                   and exists (select *
                          from Ln_s_Loan_Setup_Bls s
                         where t.Loan_Type_Account = s.Loan_Type_Account
                           and s.Acc_Owner = 'C')
                   and t.Account_Code = a.Code
                   and a.Condition = 'A')
      loop
        v_Dummy     := '';
        v_Operation := '7';
        v_Message   := '';
        --
        Account.Action(/*$IF CORE_APP_VERSION.C_CLIENT_UNIQUE $THEN
                       i_Client_UID => v_Client_Uid,
                       $END*/
                       Iclient_Id        => v_Client_Id,
                       Accountcode       => r.Code,      -- CODE
                       Filialcode        => null,        -- CodeFilial
                       name              => null,        -- NAME
                       Liabilityactive   => null,        -- LIABILITYACTIVE
                       Balanceout        => null,        -- BALANCEOUT
                       Datevalidate      => Setup.Operday,
                       Iooperation       => v_Operation,
                       Ocondition_Result => v_Dummy,
                       Odialog_Need      => v_Dummy,
                       Omessage          => v_Message,
                       Subcoa_Code       => v_Sub_Coa);
        --
        Log_Doc_Modification(Idoc_Id         => r.Loan_Id,
                             Idoc_Type_Code  => 'LNACCOUNT',
                             Istate_Code     => 1,
                             Inew_State_Code => 0,
                             Idescription    => 'Закрыт автоматически-' || r.Code || v_Message);
      end loop;
      --
    end if;
  end Closed_Acc_Before_Close_Loan;
  -------------------------------------------------------------------------------------------------
  Procedure Edit_Class_Quality_Card
  (
    i_Loan_Id       Ln_Card.Loan_Id%type,
    i_Class_Quality Ln_Card.Class_Quality%type
  ) is
    v_Class_Quality Ln_Card.Class_Quality%type;
    v_Client_Id     Ln_Card.Client_Id%type;
    v_Final_Class   Ln_Card.Class_Quality%type;
  begin
    select Class_Quality, Client_Id
      into v_Class_Quality, v_Client_Id
      from Ln_Card
     where Loan_Id = i_Loan_Id;
    Ln_Cca_Api_Out.Set_Client_Class(i_Client_Id    => v_Client_Id,
                                    i_Client_Class => i_Class_Quality,
                                    o_Final_Class  => v_Final_Class);
    --
    if v_Class_Quality = v_Final_Class /*Nvl(i_Class_Quality, v_Class_Quality)*/
     then
      return;
    end if;
    --
    update Ln_Card t
       set Class_Quality = v_Final_Class /*i_Class_Quality*/,
           t.Date_Modify = sysdate,
           t.Emp_Code    = Setup.Get_Employee_Code
     where Loan_Id = i_Loan_Id;
    Backup_Loan_Card(i_Loan_Id);
    Ln_Iw_Esb_Api.Send_Class_Quality(i_Loan_Id => i_Loan_Id, i_Class_Quality => v_Final_Class);
    --Ln_Rci_Api_Out.Add_Card_Id_With_Label(i_loan_id, 'CLASS_QUALITY');
  end Edit_Class_Quality_Card;
  -------------------------------------------------------------------------------------------------
end Ln_Contract;
/
