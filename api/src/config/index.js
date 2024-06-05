import dotenv from 'dotenv';

dotenv.config();

export const PORT = process.env.PORT;
export const ORIGIN_WHITELIST = process.env.ORIGIN_WHITELIST;
