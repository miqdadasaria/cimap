CREATE TABLE theme(
id serial PRIMARY KEY,
name text,
details text,
keywords text,
added_by int REFERENCES cimap_user (id),
date_added timestamp
);