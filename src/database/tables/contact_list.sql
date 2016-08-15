CREATE TABLE contact_list(
id serial PRIMARY KEY,
name text,
description text,
added_by int REFERENCES cimap_user (id),
date_added timestamp
);
