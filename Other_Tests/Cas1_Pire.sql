/*select top(1)
    [vwResultDetail].[Batch],
    [vwSample].[user13] as [Echantillon],
    MAX(CASE
            WHEN abs(vwXChart.ConvertedValue - vwXChart.ConvertedMinFail) > abs(vwXChart.ConvertedValue - vwXChart.ConvertedMaxFail)
                THEN abs(vwXChart.ConvertedValue - vwXChart.ConvertedMinFail)
            ELSE abs(vwXChart.ConvertedValue - vwXChart.ConvertedMaxFail)
        END) AS MaxDifference
FROM ([vwResultDetail] RIGHT JOIN [vwSample] ON [vwResultDetail].[sample_id] = [vwSample].[sample_id])
         RIGHT JOIN vwXChart ON vwResultDetail.sample_id = vwXChart.sample_id and vwResultDetail.Variable = vwXChart.Variable
where vwResultDetail.Variable = 'T50'
  and Test = 'MDR 200C'
  and variable_status IN ('Above Limit', 'Below Limit')
  and status != 'Ignored'
  and vwResultDetail.OrderNo = '@OrderNo'
GROUP BY [vwResultDetail].[Batch], [vwSample].[user13]
ORDER BY MaxDifference DESC
*/


SELECT TOP(1)
	  [Batch].[identifier] as Palette,
	  [Sample].[user13] as [Echantillon],
	  MAX(CASE
            WHEN abs(xvalue - min_failure) > abs(xvalue - max_failure)
                THEN abs(xvalue - min_failure)
            ELSE abs(xvalue - max_failure)
        END) AS MaxDifference

  FROM [Enterprise].[dbo].[Result] WITH (NOLOCK)
  JOIN [Enterprise].[dbo].[Sample] WITH (NOLOCK) ON Sample.sample_id = Result.sample_id
  JOIN [Enterprise].[dbo].[ResultData] WITH (NOLOCK) ON ResultData.result_id = Result.result_id
  JOIN [Batch] WITH (NOLOCK) ON [Batch].batch_id = [Sample].[batch_id]
  JOIN Criteria WITH (NOLOCK) ON Criteria.specification_test_id = Result.specification_test_id
							  AND Criteria.variable_id = '23105398-8BC8-48D3-A633-0A681E4BFECA'

  where test_id = '83D8EF2E-C8BD-11E7-9EDD-CC3D82AA3DA8' --test MDR
  AND ResultData.variable_id = '23105398-8BC8-48D3-A633-0A681E4BFECA' -- filter on T50
  and [Result].status_symbol != 'I' -- remove ignored results
  and [Sample].order_id IN (Select order_id from xOrder WITH (NOLOCK) where identifier = 'MX224043015W501') --filter by Order

  Group by [Batch].[identifier], [Sample].[user13]
  Order by MaxDifference desc