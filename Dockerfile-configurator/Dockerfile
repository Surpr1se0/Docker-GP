FROM mcr.microsoft.com/mssql/server:2022-latest

ENV MSSQL_SA_PASSWORD=1StrongPwd!!

COPY init.sql /docker-entrypoint-initdb.d

CMD /opt/mssql-tools18/bin/sqlcmd -S sqlserver -U sa -P 1StrongPwd!! -d master -i /docker-entrypoint-initdb.d/init.sql && echo "All done!"