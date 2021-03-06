CREATE TABLE node(
id serial PRIMARY KEY,
node_type int REFERENCES def_node_type (id),
name text,
photograph text,
background text,
node_url text,
email text,
phone text,
address_line1 text,
address_line2 text,
state text,
city text,
country text,
postcode text,
longitude float,
latitude float,
origin_state text,
origin_city text,
origin_country text,
date timestamp,
size1 int,
size2 int,
source text,
gender char(1),
added_by int REFERENCES cimap_user (id),
date_added timestamp,
is_active boolean,
mod_by int REFERENCES cimap_user (id),
mod_date timestamp,
mod_version int,
view_count int DEFAULT 0
);

CREATE TABLE node_audit(
id serial PRIMARY KEY,
operation char(1),
operation_date timestamp DEFAULT now(),
orig_id int REFERENCES node (id),
node_type int REFERENCES def_node_type (id),
name text,
photograph text,
background text,
node_url text,
email text,
phone text,
address_line1 text,
address_line2 text,
state text,
city text,
country text,
postcode text,
longitude float,
latitude float,
origin_state text,
origin_city text,
origin_country text,
date timestamp,
size1 int,
size2 int,
source text,
gender char(1),
added_by int,
date_added timestamp,
is_active boolean,
mod_by int,
mod_date timestamp,
mod_version int,
view_count int DEFAULT 0
);

CREATE OR REPLACE FUNCTION process_node_audit() RETURNS TRIGGER AS '
    BEGIN
        --
        -- Create a row in node_audit to reflect the operation performed on node,
        -- make use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = ''DELETE'') THEN
    	    INSERT INTO node_audit 
		    (
		    operation, 
		    orig_id, 
		    node_type, 
		    name, 
		    photograph, 
		    background, 
		    node_url, 
			email,
			phone,
			address_line1,
			address_line2,
			state,
			city,
			country,
			postcode,
			longitude,
			latitude,
			origin_state,
			origin_city,
			origin_country,
			date,
			size1,
			size2,
			source,
			gender,
		    added_by, 
		    date_added, 
		    is_active, 
		    mod_by, 
		    mod_date, 
		    mod_version,
		    view_count
		    ) 
		    VALUES 
		    (
		    ''D'', 
		    OLD.id, 
		    OLD.node_type, 
		    OLD.name, 
		    OLD.photograph, 
		    OLD.background, 
		    OLD.node_url,
			OLD.email,
			OLD.phone,			
			OLD.address_line1,
			OLD.address_line2,
			OLD.state,
			OLD.city,
			OLD.country,
			OLD.postcode,
			OLD.longitude,
			OLD.latitude,
			OLD.origin_state,
			OLD.origin_city,
			OLD.origin_country,
			OLD.date,
			OLD.size1,
			OLD.size2,
			OLD.source,
			OLD.gender,
		    OLD.added_by, 
		    OLD.date_added, 
		    OLD.is_active, 
		    OLD.mod_by, 
		    OLD.mod_date, 
		    OLD.mod_version,
		    OLD.view_count);
        	
        	RETURN OLD;
        ELSIF (TG_OP = ''UPDATE'') THEN
    	    INSERT INTO node_audit 
		    (
		    operation, 
		    orig_id, 
		    node_type, 
		    name, 
		    photograph, 
		    background, 
		    node_url, 
			email,
			phone,
			address_line1,
			address_line2,
			state,
			city,
			country,
			postcode,
			longitude,
			latitude,
			origin_state,
			origin_city,
			origin_country,
			date,
			size1,
			size2,
			source,
			gender,		    
		    added_by, 
		    date_added, 
		    is_active, 
		    mod_by, 
		    mod_date, 
		    mod_version,
		    view_count
		    ) 
		    VALUES 
		    (
		    ''U'', 
		    NEW.id, 
		    NEW.node_type, 
		    NEW.name, 
		    NEW.photograph, 
		    NEW.background, 
		    NEW.node_url, 
			NEW.email,
			NEW.phone,
			NEW.address_line1,
			NEW.address_line2,
			NEW.state,
			NEW.city,
			NEW.country,
			NEW.postcode,
			NEW.longitude,
			NEW.latitude,
			NEW.origin_state,
			NEW.origin_city,
			NEW.origin_country,
			NEW.date,
			NEW.size1,
			NEW.size2,
			NEW.source,
			NEW.gender,
		    NEW.added_by, 
		    NEW.date_added, 
		    NEW.is_active, 
		    NEW.mod_by, 
		    NEW.mod_date, 
		    NEW.mod_version,
		    NEW.view_count);
            RETURN NEW;
        ELSIF (TG_OP = ''INSERT'') THEN
    	    INSERT INTO node_audit 
		    (
		    operation, 
		    orig_id, 
		    node_type, 
		    name, 
		    photograph, 
		    background, 
		    node_url, 
		    email,
			phone,
			address_line1,
			address_line2,
			state,
			city,
			country,
			postcode,
			longitude,
			latitude,
			origin_state,
			origin_city,
			origin_country,
			date,
			size1,
			size2,
			source,
			gender,
		    added_by, 
		    date_added, 
		    is_active, 
		    mod_by, 
		    mod_date, 
		    mod_version,
		    view_count
		    ) 
		    VALUES 
		    (
		    ''I'', 
		    NEW.id, 
		    NEW.node_type, 
		    NEW.name, 
		    NEW.photograph, 
		    NEW.background, 
		    NEW.node_url, 
		    NEW.email,
			NEW.phone,
			NEW.address_line1,
			NEW.address_line2,
			NEW.state,
			NEW.city,
			NEW.country,
			NEW.postcode,
			NEW.longitude,
			NEW.latitude,
			NEW.origin_state,
			NEW.origin_city,
			NEW.origin_country,
			NEW.date,
			NEW.size1,
			NEW.size2,
			NEW.source,
			NEW.gender,
		    NEW.added_by, 
		    NEW.date_added, 
		    NEW.is_active, 
		    NEW.mod_by, 
		    NEW.mod_date, 
		    NEW.mod_version,
		    NEW.view_count);

            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER node_audit
AFTER INSERT OR UPDATE OR DELETE ON node
    FOR EACH ROW EXECUTE PROCEDURE process_node_audit();