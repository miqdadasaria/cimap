CREATE TABLE node_news(
id serial PRIMARY KEY,
node_id int REFERENCES node (id),
news_id int REFERENCES news (id)
);