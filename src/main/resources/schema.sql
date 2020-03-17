SET CACHE_SIZE 65536;
SET LOCK_MODE 1;

CREATE USER IF NOT EXISTS "O2M" SALT 'f52a4c3a9c269707' HASH '2560b341f1330aeb2e44d32eb19b9091e8bb7bd78c98f885df56383a281ae948' ADMIN;

-- WAY
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."WAY"(
    "ID" BIGINT PRIMARY KEY NOT NULL,
    "NAME" VARCHAR(100),
    "TYPE" VARCHAR(30),
    "THICKNESS" REAL,
    "LINESTRING" GEOMETRY NOT NULL
);

-- ZONE
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."ZONE"(
    "ID" BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    "POLY" GEOMETRY NOT NULL,
    "OWNER" VARCHAR(20),
    "TYPE" TINYINT NOT NULL
);

-- FRIEND
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."FRIEND"(
    "ID" BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    "ZONE_ID" BIGINT NOT NULL,
    "PLAYER" VARCHAR(20) NOT NULL,
);

-- MODO
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."MODO"(
    "PLAYER" VARCHAR(20) PRIMARY KEY NOT NULL,
);

-- VECTOR3D
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."VECTOR3D"(
    "ID" BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    "X" DOUBLE NOT NULL,
    "Y" DOUBLE NOT NULL,
    "Z" DOUBLE NOT NULL
);

-- POI
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."POI"(
    "ID" BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    "NAME" VARCHAR(100) NOT NULL,
    "NAME_LOWER" VARCHAR(100) AS LOWER(NAME),
    "POSITION" BIGINT NOT NULL,
    "ROTATION" BIGINT
);

-- MAP ELEMENT
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."MAPELEMENT"(
    "ID" BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    "TYPE" VARCHAR(50),
    "GEOMETRY" GEOMETRY NOT NULL
);

-- OPTIONS
CREATE CACHED TABLE IF NOT EXISTS "PUBLIC"."OPTIONS"(
    "ID" INT NOT NULL,
    "HEIGHT" INT NOT NULL,
    "ZOOM" DOUBLE NOT NULL,
    "TL_LAT" DOUBLE NOT NULL,
    "TL_LON" DOUBLE NOT NULL,
    "BR_LAT" DOUBLE NOT NULL,
    "BR_LON" DOUBLE NOT NULL
);

-- CONSTRAINT
ALTER TABLE "PUBLIC"."POI" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_POS" FOREIGN KEY("POSITION") REFERENCES "PUBLIC"."VECTOR3D"("ID") NOCHECK;
ALTER TABLE "PUBLIC"."POI" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_ROT" FOREIGN KEY("ROTATION") REFERENCES "PUBLIC"."VECTOR3D"("ID") NOCHECK;
ALTER TABLE "PUBLIC"."FRIEND" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_FRIEND" FOREIGN KEY("ZONE_ID") REFERENCES "PUBLIC"."ZONE"("ID") NOCHECK;

-- INDEX
CREATE SPATIAL INDEX IDX_SPATIAL_ZONE_POLY ON ZONE(POLY);
CREATE SPATIAL INDEX IDX_SPATIAL_WAY_GEO ON WAY(LINESTRING);
CREATE SPATIAL INDEX IDX_SPATIAL_MAPELEMENT_GEO ON MAPELEMENT(GEOMETRY);
CREATE INDEX "PUBLIC"."INDEX_OWNER" ON "PUBLIC"."ZONE" ("OWNER");
CREATE INDEX "PUBLIC"."INDEX_FRIEND" ON "PUBLIC"."FRIEND" ("PLAYER");

CREATE ALIAS buffer FOR "com.wardenfar.osm2map.Util.buffer";
CREATE ALIAS intersects FOR "com.wardenfar.osm2map.Util.intersects";
CREATE ALIAS intersectsRect FOR "com.wardenfar.osm2map.Util.intersectsRect";
CREATE ALIAS isWithinDistance FOR "com.wardenfar.osm2map.Util.isWithinDistance";
