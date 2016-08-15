CREATE TABLE news(
id serial PRIMARY KEY,
pub_type text,
title text,
pub_date timestamp,
pub_source text,
pub_url text,
added_by int REFERENCES cimap_user (id),
date_added timestamp,
is_active boolean,
activated_by int REFERENCES cimap_user (id),
date_activated timestamp
);