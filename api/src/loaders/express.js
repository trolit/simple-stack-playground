import express from 'express';

/**
 * @param { import("express").Application } app
 * @param { import("@prisma/client").PrismaClient } prisma
 */
export default (app, prisma) => {
    app.use(express.json())

    app.get('/users', async function (req, res) {
        let users = [];

        try {
            users = await prisma.user.findMany();
        } catch (error) {
            return res.status(500).send('Database not running!')
        }

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

        let user;

        try {
            user = await prisma.user.create({
                data: {
                    name,
                    email,
                },
            })
        } catch (error) {
            return res.status(500).send('Database not running!')
        }

        return res.status(201).send({
            data: user
        });
    })
}
