import { PrismaClient } from '@prisma/client';
import expressLoader from './express.js';

export default async (app) => {
  const prisma = new PrismaClient();

  expressLoader(app, prisma);
}
