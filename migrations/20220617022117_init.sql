-- migrate:up

CREATE TABLE available_language(
  uid SERIAL PRIMARY KEY,
  metadata JSONB NOT NULL,

  lang_id TEXT NOT NULL,
  create_ts TIMESTAMP NOT NULL,

  config JSONB NOT NULL,
  lang_image_id TEXT NOT NULL,
  server_agent_id TEXT NOT NULL
);

CREATE TABLE default_language(
  lang_id TEXT PRIMARY KEY,
  create_ts TIMESTAMP NOT NULL
);

CREATE TABLE lang_image(
  id TEXT PRIMARY KEY,
  metadata JSONB NOT NULL,

  lang_id TEXT NOT NULL,
  create_ts TIMESTAMP NOT NULL
);

CREATE TABLE base_image(
  id TEXT PRIMARY KEY,
  create_ts TIMESTAMP NOT NULL,
  metadata JSONB NOT NULL
);

CREATE TABLE lang_package(
  id TEXT PRIMARY KEY,
  metadata JSONB NOT NULL,

  lang_id TEXT NOT NULL,
  create_ts TIMESTAMP NOT NULL
);

-- migrate:down

DROP TABLE lang_package;
DROP TABLE base_image;
DROP TABLE lang_image;
DROP TABLE default_language;
DROP TABLE available_language;
