select Compound.identifier
from Compound
where compound_id = (Select compound_id from xOrder where identifier = '@OrderNo')
and (Compound.identifier like '7%'
                               or Compound.identifier like '%TMA%')