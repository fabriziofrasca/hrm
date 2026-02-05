import "dotenv/config";
import { PrismaClient } from "@prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";

function getDatabaseUrl(): string {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error("DATABASE_URL is missing");
  return url;
}

export class PrismaService extends PrismaClient {
  constructor() {
    const adapter = new PrismaPg({ connectionString: getDatabaseUrl() });
    super({ adapter });
  }
}
