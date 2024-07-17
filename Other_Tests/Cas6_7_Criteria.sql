select Batch,
       [vwSample].[user13] as [Palette],
       CASE
           when ConvertedValue < vwXChart.ConvertedMinFail then 'Below Criteria Limit'
           when ConvertedValue > vwXChart.ConvertedMaxFail then 'Above Criteria Limit'
           when ConvertedValue > vwXChart.ConvertedMinFail + (vwXChart.ConvertedMaxFail - vwXChart.ConvertedMinFail) / 2
               and ConvertedValue < vwXChart.ConvertedMaxFail
               then 'Passed Above Midpoint'
           when ConvertedValue < vwXChart.ConvertedMinFail + (vwXChart.ConvertedMaxFail - vwXChart.ConvertedMinFail) / 2
               and ConvertedValue > vwXChart.ConvertedMinFail
               then 'Passed Below Midpoint'
           END as variable_status

FROM vwXChart RIGHT JOIN [vwSample] ON [vwXChart].[sample_id] = [vwSample].[sample_id]
where Variable = 'MH'
  and fullid = 'MDR 200C'
  and OrderNo = '@OrderNo'