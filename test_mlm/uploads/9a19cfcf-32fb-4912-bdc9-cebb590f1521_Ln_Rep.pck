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