# DataLink tests on PG15

tbc

run `init.bat`, then 

add `?prepareThreshold=0` to the `datalink.default.url`
new:
```yaml
###############################################################################
# DEFAULT JDBC INFO (DEFAULT : H2)
###############################################################################
datalink.default.datasource=jdbc/DataSource
datalink.default.driver=org.postgresql.Driver
datalink.default.url=jdbc:postgresql://localhost:5432/datalink?prepareThreshold=0
datalink.default.username=postgres
datalink.default.password=samsung01
# Initial DB Connection pool size
datalink.default.initial_size=10
# Max DB Connection pool size
datalink.default.max_active=70
# Max Wating Connection Timeout
datalink.default.max_wait=5000
# Max DB Connection pool idle size
datalink.default.max_idle=200

# ConnectionPool type=DS: Java datasource, H2: H2 datasource
datalink.default.connectionpool=postgres

```
then run `dbupdate.bat`