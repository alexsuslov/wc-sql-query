
# Express req.query -> mysql where
## New in 0.0.2
- types
## Use
```
Query = require("wc-sql-query")

Firm =
  table:'`2015`.`firm`'
  find:(q, fields, fn)->
    query = Query q
    where = (if query.where then " WHERE #{query.where}" else "")
    order = (if query.order then " ORDER BY #{query.order}" else "")
    limit = (if query.limit then " LIMIT #{query.limit}" else "")
    sql = "SELECT #{fields} FROM #{@table} #{where} #{order} #{limit};"
    Mysql.query sql, fn
```

## Comparison Query Operators

### EQ
- url: /api/item?name=test
    + WHERE name='test'

### NEQ
- url: /api/item?name=!test
    + WHERE name!='test'

### GT
- url: /api/item?name=>test
    + WHERE name>'test'

### GTE
- url: /api/item?name=]test
    + WHERE name=>'test'

### LT
- url: /api/item?name=< test
    + WHERE name=<'test'

### LTE
- url: /api/item?name=[test
    + WHERE name=<'test'

## Evaluation Query Operators
### 
- url: /api/item?name=~test
    + WHERE name='%test%'


## Sort

- /api/item?order=name
    + name
- /api/item?order=-name
    + name DESC

## Limit
- /api/item?limit=25&skip=0
    + 0, 25
