select top(1)
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