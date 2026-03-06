Frontend: vote (Python), result (NodeJS)
Backend: worker (.NET)
Data: redis, postgres
Flow: USER -> Vote -> Redis -> Worker -> PostgreSQL -> Result
