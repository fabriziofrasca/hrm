-- CreateEnum
CREATE TYPE "Role" AS ENUM ('SUPER_ADMIN', 'HR_ADMIN', 'MANAGER', 'EMPLOYEE');

-- CreateEnum
CREATE TYPE "PunchType" AS ENUM ('IN', 'OUT');

-- CreateEnum
CREATE TYPE "PunchMethod" AS ENUM ('GEOLOCATION');

-- CreateEnum
CREATE TYPE "PunchStatus" AS ENUM ('ACCEPTED', 'REJECTED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'EMPLOYEE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Workplace" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "lat" DECIMAL(10,7) NOT NULL,
    "lon" DECIMAL(10,7) NOT NULL,
    "radiusM" INTEGER NOT NULL DEFAULT 120,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Workplace_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Employee" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "badgeCode" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "workplaceId" TEXT NOT NULL,
    "hireDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Punch" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "workplaceId" TEXT NOT NULL,
    "type" "PunchType" NOT NULL,
    "method" "PunchMethod" NOT NULL DEFAULT 'GEOLOCATION',
    "lat" DECIMAL(10,7) NOT NULL,
    "lon" DECIMAL(10,7) NOT NULL,
    "accuracyM" INTEGER NOT NULL,
    "distanceM" INTEGER NOT NULL,
    "allowedM" INTEGER NOT NULL,
    "status" "PunchStatus" NOT NULL,
    "rejectReason" TEXT,
    "deviceId" TEXT,
    "userAgent" TEXT,
    "occurredAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Punch_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "Workplace_isActive_idx" ON "Workplace"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Employee_userId_key" ON "Employee"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Employee_badgeCode_key" ON "Employee"("badgeCode");

-- CreateIndex
CREATE INDEX "Employee_workplaceId_idx" ON "Employee"("workplaceId");

-- CreateIndex
CREATE INDEX "Employee_isActive_idx" ON "Employee"("isActive");

-- CreateIndex
CREATE INDEX "Punch_employeeId_occurredAt_idx" ON "Punch"("employeeId", "occurredAt");

-- CreateIndex
CREATE INDEX "Punch_workplaceId_occurredAt_idx" ON "Punch"("workplaceId", "occurredAt");

-- CreateIndex
CREATE INDEX "Punch_status_occurredAt_idx" ON "Punch"("status", "occurredAt");

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_workplaceId_fkey" FOREIGN KEY ("workplaceId") REFERENCES "Workplace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Punch" ADD CONSTRAINT "Punch_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Punch" ADD CONSTRAINT "Punch_workplaceId_fkey" FOREIGN KEY ("workplaceId") REFERENCES "Workplace"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
