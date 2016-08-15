CREATE TABLE node_contact_list(
id serial PRIMARY KEY,
node_id int REFERENCES node (id),
contact_list_id int REFERENCES contact_list(id),
added_by int REFERENCES cimap_user (id),
date_added timestamp
);