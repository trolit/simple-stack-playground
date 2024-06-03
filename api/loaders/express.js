import express from 'express';

/**
 * @param { import("express").Application } app
 * @param { import("@prisma/client").PrismaClient } prisma
 */
export default (app, prisma) => {
    app.use(express.json())

    app.get('/users', async function (req, res) {
        const users = await prisma.user.findMany();
        
        return res.status(200).send({
            data: users
        });
    })

    app.post('/users', async function (req, res) {
        const { body: { email, name } } = req;

        if (!email || !name || typeof email !== 'string' || typeof name !== 'string') {
            return res.status(400).send({
                error: 'Validation error!'
            })
        }

        const user = await prisma.user.create({
            data: {
              name,
              email,
            },
          })

        return res.status(201).send({
            data: user
        });
    })
}
