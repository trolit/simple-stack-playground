import { PrismaClient } from '@prisma/client';
import expressLoader from './express.js';
import corsLoader from "./cors.js";

export default async (app) => {
  const prisma = new PrismaClient();

  corsLoader(app);

  expressLoader(app, prisma);
}
