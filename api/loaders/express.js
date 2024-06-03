export default (app) => {
    app.get('/', function (req, res) {
        res.send('Hello World');
    })
}
