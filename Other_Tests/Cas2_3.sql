-- with T as (select OrderNo,
--                   Batch,
--                   [vwSample].[user13] as [Palette],
--                   ConvertedValue as MH,
--                   CASE
--                       when ConvertedValue < vwXChart.ConvertedMinFail then 'Below Criteria Limit'
--                       when ConvertedValue > vwXChart.ConvertedMaxFail then 'Above Criteria Limit'
--                       when ConvertedValue > vwXChart.ConvertedMinFail + (vwXChart.ConvertedMaxFail - vwXChart.ConvertedMinFail) / 2
--                           and ConvertedValue < vwXChart.ConvertedMaxFail then 'Passed Above Midpoint'
--                       when ConvertedValue < vwXChart.ConvertedMinFail + (vwXChart.ConvertedMaxFail - vwXChart.ConvertedMinFail) / 2
--                           and ConvertedValue > vwXChart.ConvertedMinFail then 'Passed Below Midpoint'
--                       END as variable_status
--            FROM vwXChart RIGHT JOIN [vwSample] ON [vwXChart].[sample_id] = [vwSample].[sample_id]
--            where Variable = 'MH'
--              and vwXChart.status_symbol != 'I'
--              and fullid = 'MDR 200C'),
--      Orders_Failed as (select distinct OrderNo from T
--                        where variable_status IN ('Below Criteria Limit', 'Above Criteria Limit')
--                          and OrderNo = '@OrderNo')
-- select stdev(MH) as MH_dev,
--        (stdev(MH)*100) / avg(MH) as MH_CV
-- from T where OrderNo in (select OrderNo from Orders_Failed)
--          and variable_status in ('Passed Above Midpoint', 'Passed Below Midpoint')
-- group by OrderNo
-- order by MH_dev

SELECT Batch,
       [vwSample].[user13] AS [Palette],
       ConvertedValue AS MH,
       CASE
           WHEN ConvertedValue < vwXChart.ConvertedMinFail THEN 'Below Criteria Limit'
           WHEN ConvertedValue > vwXChart.ConvertedMaxFail THEN 'Above Criteria Limit'
           WHEN ConvertedValue between vwXChart.ConvertedMinFail and vwXChart.ConvertedMaxFail THEN 'Passed'
           END AS variable_status
FROM vwXChart WITH(NOLOCK)
         RIGHT JOIN [vwSample] WITH(NOLOCK) ON [vwXChart].[sample_id] = [vwSample].[sample_id]
WHERE Variable = 'MH'
  AND OrderNo = '@OrderNo'
  AND vwXChart.status_symbol != 'I'
  AND fullid = 'MDR 200C'
ORDER BY Batch, [vwSample].[user13];