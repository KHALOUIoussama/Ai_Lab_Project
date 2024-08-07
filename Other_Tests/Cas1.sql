/*select
    [status],
    [xvalue],
    [variable_status],
    [vwResultDetail].[Batch],
    [vwSample].[user13] as [Echantillon]
FROM [vwResultDetail] with (NOLOCK)
    RIGHT JOIN [vwSample] with (NOLOCK) ON [vwResultDetail].[sample_id] = [vwSample].[sample_id]
where Variable = 'T50'
  and Test = 'MDR 200C'
  --and variable_status IN ('Above Limit', 'Below Limit')
  and status != 'Ignored'
  and OrderNo = '@OrderNo'
ORDER BY [vwResultDetail].[Batch], [Echantillon]*/



SELECT[ResultData].[status_symbol] as [variable_status],
	  [Batch].[identifier] as Palette,
	  [Sample].[user13] as [Echantillon]
  FROM [Enterprise].[dbo].[Result] WITH (NOLOCK)
  JOIN [Enterprise].[dbo].[Sample] WITH (NOLOCK) ON Sample.sample_id = Result.sample_id
  JOIN [Enterprise].[dbo].[ResultData] WITH (NOLOCK) ON ResultData.result_id = Result.result_id
  JOIN [Batch] WITH (NOLOCK) ON [Batch].batch_id = [Sample].[batch_id]
  where test_id = '83D8EF2E-C8BD-11E7-9EDD-CC3D82AA3DA8' --test MDR
  AND variable_id = '23105398-8BC8-48D3-A633-0A681E4BFECA' -- filter on T50
  and [Result].status_symbol != 'I' -- remove ignored results
  and [Sample].order_id IN (Select order_id from xOrder WITH (NOLOCK) where identifier = '@OrderNo') --filter by Order

  Order by [Batch].[identifier], [Sample].[user13]