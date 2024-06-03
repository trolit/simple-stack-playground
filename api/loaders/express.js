export default (app, prisma) => {
    app.get('/users', async function (req, res) {
        const users = await prisma.user.findMany();
        
        return res.send({
            data: users
        });
    })
}
