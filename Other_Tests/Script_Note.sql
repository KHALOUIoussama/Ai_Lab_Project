DECLARE @content_filter VARCHAR(50) = '%MH hors normes%'

select identifier, content, xOrder.x_date
from xNote WITH(NOLOCK) JOIN xOrder WITH(NOLOCK) on xNote.owner_id = xOrder.order_id
where content not like '{\rtf1%'
  and content like @content_filter
order by xOrder.x_date desc