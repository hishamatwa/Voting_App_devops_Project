# Backend Layer

Service:
- Worker (.NET)

Role:
- Reads votes from Redis
- Stores results into PostgreSQL

Flow:
Vote -> Redis -> Worker -> PostgreSQL -> Result
