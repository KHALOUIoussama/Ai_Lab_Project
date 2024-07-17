select Batch, variable_status

from vwResultDetail2

where Variable = 'MH'
  and test = 'MDR 200C'
  and orderno = '@OrderNo';