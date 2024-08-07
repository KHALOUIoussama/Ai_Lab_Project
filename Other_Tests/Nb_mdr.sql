/*select count(distinct instrument) as nb_instruments
from vwResultDetail
where Test = 'MDR 200C'
  and OrderNo = '@OrderNo'*/

select count(distinct instrument_id) as nb_instruments
from Result
where sample_id in (select sample_id
							from Sample
								where order_id = (Select order_id from xOrder where identifier = '@OrderNo'))
	 and test_id = '83D8EF2E-C8BD-11E7-9EDD-CC3D82AA3DA8' -- MDR 200C