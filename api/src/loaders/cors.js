import cors from 'cors';
import { ORIGIN_WHITELIST } from '../config/index.js';

/**
 * @param { import("express").Application } app
 */
export default (app) => {
    const whitelist = ORIGIN_WHITELIST.split(',');

    app.use(cors({
        origin: function (origin, callback) {
            if (whitelist.indexOf(origin) !== -1) {
                return callback(null, true);
            }

            return callback(new Error('Not allowed by CORS!'))
        }
    }))
}
