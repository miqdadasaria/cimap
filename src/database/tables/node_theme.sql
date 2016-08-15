CREATE TABLE node_theme(
id serial PRIMARY KEY,
node_id int REFERENCES node (id),
theme_id int REFERENCES theme (id)
);