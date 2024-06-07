-- Declare the variables
DECLARE @ResultCurveId uniqueidentifier

-- Create a temporary table to store the results
CREATE TABLE #ResultsTable (ResultCurve_id varchar(100), n int, xtime float , xvalue float)

SELECT distinct resultcurve_id, OrderNo, Batch, unique_code as Sample_Code
INTO #Resultcurve_id_table
FROM ResultCurve
         JOIN vwResultDetail on ResultCurve.result_id = vwResultDetail.result_id
WHERE ResultCurve.variable_id in (SELECT variable_id FROM xVariable WHERE identifier = 'SP') --selectionner les courbes Torque
  AND ResultCurve.result_id in (SELECT result_id FROM vwResultDetail WHERE OrderNo = 'MX22406061DL01' AND Test = 'MDR 200C')

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
DEALLOCATE cur

-- Tables des ResultCurve_id de la commande
SELECT #ResultsTable.ResultCurve_id, (xtime/60) as xtime, (xvalue*10) as xvalue, Batch, Sample_Code
FROM #ResultsTable join #Resultcurve_id_table Rit on #ResultsTable.ResultCurve_id = Rit.resultcurve_id
where n != 0

-- Drop the temporary table
DROP TABLE #ResultsTable
DROP TABLE #Resultcurve_id_table