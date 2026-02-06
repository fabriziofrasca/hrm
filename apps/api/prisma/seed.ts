import "dotenv/config";
import { PrismaClient, Role } from "@prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";
import bcrypt from "bcrypt";

function getDatabaseUrl(): string {
  const url = process.env.DATABASE_URL;
  if (!url) throw new Error("DATABASE_URL is missing");
  return url;
}

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: getDatabaseUrl() }),
});

async function main() {
  await prisma.workplace.createMany({
    data: [
      { name: "Sede 1", lat: 41.1234567 as any, lon: 16.1234567 as any, radiusM: 120 },
      { name: "Sede 2", lat: 41.2345678 as any, lon: 16.2345678 as any, radiusM: 120 },
      { name: "Sede 3", lat: 41.3456789 as any, lon: 16.3456789 as any, radiusM: 120 },
    ],
    skipDuplicates: true,
  });

  const adminEmail = "admin@hrm.local";
  const adminPassword = "Admin123!";
  const passwordHash = await bcrypt.hash(adminPassword, 10);

  await prisma.user.upsert({
    where: { email: adminEmail },
    update: {},
    create: {
      email: adminEmail,
      password: passwordHash,
      role: Role.SUPER_ADMIN,
    },
  });

  console.log("Seed OK ✅");
  console.log("Admin:", { email: adminEmail, password: adminPassword });
}

main()
  .catch((e) => {
    console.error("Seed error ❌", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
