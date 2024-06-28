-- Declare the variables
DECLARE @ResultCurveId uniqueidentifier

-- Create a temporary table to store the results
CREATE TABLE #ResultsTable (ResultCurve_id varchar(50), n int, xtime float , xvalue float)

SELECT distinct resultcurve_id, OrderNo, Batch, unique_code as Sample_Code
INTO #Resultcurve_id_table
FROM ResultCurve
         JOIN vwResultDetail on ResultCurve.result_id = vwResultDetail.result_id
WHERE ResultCurve.variable_id = '8AE2CDE9-0986-47A7-8DC1-F9C56AD2C87B' --selectionner les courbes Torque
  and ResultCurve.result_id in ()

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
    SELECT Rit.OrderNo, #ResultsTable.ResultCurve_id, n, (xtime/60) AS xtime, (xvalue*10) AS xvalue, Batch, Sample_Code
    FROM #ResultsTable
    JOIN #Resultcurve_id_table Rit ON #ResultsTable.ResultCurve_id = Rit.resultcurve_id
    WHERE n != 0
),
SlopeTable AS (
    SELECT T.OrderNo, T.Batch, T.Sample_Code, T.xtime, T.xvalue, (T.xvalue - T2.xvalue)/(T.xtime - T2.xtime) AS slope
    FROM T, T AS T2
    WHERE T.ResultCurve_id = T2.ResultCurve_id AND T.n = T2.n + 1 AND T.xtime > 0.2 AND T.xtime < 0.8
),
MaxSlope AS (
    SELECT Sample_Code, MAX(slope) AS max_slope
    FROM SlopeTable
    GROUP BY Sample_Code
)
SELECT ST.OrderNo, Round(STDEV(ST.xtime)*1000,2) as ecart_type
FROM SlopeTable ST
JOIN MaxSlope MS ON ST.Sample_Code = MS.Sample_Code AND ST.slope = MS.max_slope
group by ST.OrderNo
ORDER BY ST.OrderNo DESC

-- Drop the temporary table
DROP TABLE #ResultsTable
DROP TABLE #Resultcurve_id_table