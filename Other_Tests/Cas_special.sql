SET NOCOUNT ON

-- Declare the variables
DECLARE @ResultCurveId uniqueidentifier

DECLARE @ResultIds AS TABLE (result_id VARCHAR(50))
INSERT INTO @ResultIds (result_id)
SELECT
    distinct [Result].result_id

FROM [Enterprise].[dbo].[Result] WITH (NOLOCK)
         JOIN [Enterprise].[dbo].[Sample] WITH (NOLOCK) ON Sample.sample_id = Result.sample_id

where test_id = '83D8EF2E-C8BD-11E7-9EDD-CC3D82AA3DA8' --test MDR
  and [Result].status_symbol != 'I' -- remove ignored results
  and [Sample].order_id IN (Select order_id from xOrder WITH (NOLOCK) where identifier = '@OrderNo') --filter by Order

SELECT distinct resultcurve_id,
                vwSample.Batch,
                vwSample.unique_code as Sample_Code,
                [vwSample].[user13] as [Palette]
INTO #Resultcurve_id_table
FROM ResultCurve
       JOIN Result ON ResultCurve.result_id = Result.result_id and Result.result_id IN (select result_id from @ResultIds)
         RIGHT JOIN [vwSample] ON [Result].[sample_id] = [vwSample].[sample_id]

WHERE ResultCurve.variable_id = '8AE2CDE9-0986-47A7-8DC1-F9C56AD2C87B' --selectionner les courbes Torque


-- Create a temporary table to store the results
CREATE TABLE #ResultsTable (ResultCurve_id varchar(50), n int, xtime float , xvalue float)

-- Declare the cursor
DECLARE cur CURSOR FOR
    SELECT resultcurve_id FROM #Resultcurve_id_table

-- Open the cursor
OPEN cur

-- Fetch the first row
FETCH NEXT FROM cur INTO @ResultCurveId

-- Loop through the rows
WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Execute the stored procedure for each ResultCurveId and insert the result into the temporary table
        INSERT INTO #ResultsTable
            EXEC dbo.CurveData @ResultCurveId

        -- Fetch the next row
        FETCH NEXT FROM cur INTO @ResultCurveId
    END

-- Close and deallocate the cursor
CLOSE cur
DEALLOCATE cur;

-- Tables des ResultCurve_id de la commande
WITH T AS (
    SELECT #ResultsTable.ResultCurve_id,
           n,
           (xtime/60) AS xtime, -- À optimiser en utilisant LEAD pour T2.xtime dans la table T
           (xvalue*10) AS xvalue,
           Batch,
           Sample_Code,
           [Palette]
    FROM #ResultsTable
             JOIN #Resultcurve_id_table Rit ON #ResultsTable.ResultCurve_id = Rit.resultcurve_id
    WHERE n != 0
)
SELECT T.Batch as [Palette],
       T.Sample_Code,
       T.xtime,
       T.xvalue,
       T.[Palette] as [Echantillon],
       (T.xvalue - T2.xvalue)/(T.xtime - T2.xtime) AS slope,
       null as fitted_slope
FROM T JOIN T AS T2 ON (T.ResultCurve_id = T2.ResultCurve_id)
    AND T.n = T2.n + 1
    AND (T.xtime - T2.xtime) != 0
ORDER BY T.Batch, T.Sample_Code, T.Palette, T.xtime

-- Drop the temporary table
DROP TABLE #ResultsTable
DROP TABLE #Resultcurve_id_table