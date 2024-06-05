import express from 'express';
import loader from './loaders/index.js';
import { PORT } from './config/index.js';

const app = express();

loader(app);

app.listen(PORT, err => {
  if (err) {
    console.log(err);

    return process.exit(1);
  }

  console.log(`Server is running at http://127.0.0.1:${PORT} 🔥`);
});

export default app;
