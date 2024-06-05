import cors from 'cors';
import { CLIENT_URL } from '../config/index.js';

/**
 * @param { import("express").Application } app
 */
export default (app) => {
    app.use(cors({
        origin: CLIENT_URL,
    }))
}
