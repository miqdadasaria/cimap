CREATE TABLE cimap_user(
id serial PRIMARY KEY,
name text,
orgname text,
country text,
email text,
url text,
bio text,
username text UNIQUE,
password text,
is_active boolean,
photograph text,
level int,
date_added timestamp DEFAULT now(),
last_login timestamp,
login_count int DEFAULT 0,
node_add_count int DEFAULT 0,
node_view_count int DEFAULT 0,
node_update_count int DEFAULT 0,
node_add_quota int DEFAULT -1,
node_view_quota int DEFAULT -1,
node_update_quota int DEFAULT -1
);

CREATE TABLE cimap_user_audit(
id serial PRIMARY KEY,
operation char(1),
operation_date timestamp DEFAULT now(),
user_id int REFERENCES cimap_user (id),
name text,
orgname text,
country text,
email text,
url text,
bio text,
username text,
password text,
is_active boolean,
photograph text,
level int,
date_added timestamp DEFAULT now(),
last_login timestamp,
login_count int DEFAULT 0,
node_add_count int DEFAULT 0,
node_view_count int DEFAULT 0,
node_update_count int DEFAULT 0,
node_add_quota int DEFAULT -1,
node_view_quota int DEFAULT -1,
node_update_quota int DEFAULT -1
);

CREATE OR REPLACE FUNCTION process_cimap_user_audit() RETURNS TRIGGER AS '
    BEGIN
        --
        -- Create a row in node_audit to reflect the operation performed on node,
        -- make use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = ''DELETE'') THEN
    	    INSERT INTO cimap_user_audit 
		    ( 
			operation,
		    user_id, 
			name,
			orgname,
			country,
			email,
			url,
			bio,
			username,
			password,
			is_active,
			photograph,
			level,
			date_added,
			last_login,
			login_count,
			node_add_count,
			node_view_count,
			node_update_count,
			node_add_quota,
			node_view_quota,
			node_update_quota
		    ) 
		    VALUES 
		    (
		    ''D'', 
		    OLD.user_id, 
			OLD.name,
			OLD.orgname,
			OLD.country,
			OLD.email,
			OLD.url,
			OLD.bio,
			OLD.username,
			OLD.password,
			OLD.is_active,
			OLD.photograph,
			OLD.level,
			OLD.date_added,
			OLD.last_login,
			OLD.login_count,
			OLD.node_add_count,
			OLD.node_view_count,
			OLD.node_update_count,
			OLD.node_add_quota,
			OLD.node_view_quota,
			OLD.node_update_quota);
        	RETURN OLD;
        ELSIF (TG_OP = ''UPDATE'') THEN
    	    INSERT INTO cimap_user_audit 
		    (
			operation,
		    user_id, 
			name,
			orgname,
			country,
			email,
			url,
			bio,
			username,
			password,
			is_active,
			photograph,
			level,
			date_added,
			last_login,
			login_count,
			node_add_count,
			node_view_count,
			node_update_count,
			node_add_quota,
			node_view_quota,
			node_update_quota
		    ) 
		    VALUES 
		    (
		    ''U'', 
		    NEW.id, 
			NEW.name,
			NEW.orgname,
			NEW.country,
			NEW.email,
			NEW.url,
			NEW.bio,
			NEW.username,
			NEW.password,
			NEW.is_active,
			NEW.photograph,
			NEW.level,
			NEW.date_added,
			NEW.last_login,
			NEW.login_count,
			NEW.node_add_count,
			NEW.node_view_count,
			NEW.node_update_count,
			NEW.node_add_quota,
			NEW.node_view_quota,
			NEW.node_update_quota);
            RETURN NEW;
        ELSIF (TG_OP = ''INSERT'') THEN
    	    INSERT INTO cimap_user_audit 
		    (
			operation,
		    user_id, 
			name,
			orgname,
			country,
			email,
			url,
			bio,
			username,
			password,
			is_active,
			photograph,
			level,
			date_added,
			last_login,
			login_count,
			node_add_count,
			node_view_count,
			node_update_count,
			node_add_quota,
			node_view_quota,
			node_update_quota
		    ) 
		    VALUES 
		    (
		    ''I'', 
		    NEW.id, 
			NEW.name,
			NEW.orgname,
			NEW.country,
			NEW.email,
			NEW.url,
			NEW.bio,
			NEW.username,
			NEW.password,
			NEW.is_active,
			NEW.photograph,
			NEW.level,
			NEW.date_added,
			NEW.last_login,
			NEW.login_count,
			NEW.node_add_count,
			NEW.node_view_count,
			NEW.node_update_count,
			NEW.node_add_quota,
			NEW.node_view_quota,
			NEW.node_update_quota);
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER cimap_user_audit
AFTER INSERT OR UPDATE OR DELETE ON cimap_user
    FOR EACH ROW EXECUTE PROCEDURE process_cimap_user_audit();