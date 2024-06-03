Prisma - [Start from scratch](https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch)

Apply migration & generate file:

```bash
npx prisma migrate dev --name init
```

Whenever you update your Prisma schema, you will have to update your database schema using either `prisma migrate dev` or `prisma db push`. This will keep your database schema in sync with your Prisma schema. The commands will also regenerate Prisma Client. ([source](https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch/relational-databases/install-prisma-client-typescript-postgresql))
