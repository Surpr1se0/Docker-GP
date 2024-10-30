FROM mcr.microsoft.com/mssql/server:2022-latest

ENV MSSQL_SA_PASSWORD=1StrongPwd!!

COPY init.sql /docker-entrypoint-initdb.d/

CMD /opt/mssql-tools18/bin/sqlcmd -S tcp:sqlserver,1433 -U sa -P 1StrongPwd!! -d master -C -i /docker-entrypoint-initdb.d/init.sql && echo "All done!"
