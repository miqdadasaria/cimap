CREATE TABLE edge(
id serial PRIMARY KEY,
edge_type int REFERENCES def_edge_type (id),
node1 int REFERENCES node (id),
node2 int REFERENCES node (id),
start_date timestamp,
end_date timestamp,
details text,
added_by int REFERENCES cimap_user (id),
date_added timestamp,
is_active boolean,
mod_by int REFERENCES cimap_user (id),
mod_date timestamp,
mod_version int
);

CREATE TABLE edge_audit(
id serial PRIMARY KEY,
operation char(1),
operation_date timestamp DEFAULT now(),
orig_id int REFERENCES edge (id),
edge_type int REFERENCES def_edge_type (id),
node1 int,
node2 int,
start_date timestamp,
end_date timestamp,
details text,
added_by int,
date_added timestamp,
is_active boolean,
mod_by int,
mod_date timestamp,
mod_version int
);

CREATE OR REPLACE FUNCTION process_edge_audit() RETURNS TRIGGER AS '
    BEGIN
        --
        -- Create a row in node_audit to reflect the operation performed on edge,
        -- make use of the special variable TG_OP to work out the operation.
        --
        IF (TG_OP = ''DELETE'') THEN
    	    INSERT INTO edge_audit 
		    (
		    operation, 
		    orig_id, 
		    edge_type, 
		    node1, 
		    node2, 
		    start_date, 
		    end_date,
		    details, 
		    added_by, 
		    date_added, 
		    is_active, 
		    mod_by, 
		    mod_date, 
		    mod_version
		    ) 
		    VALUES 
		    (
		    ''D'', 		    
		    OLD.id, 
		    OLD.edge_type, 
		    OLD.node1, 
		    OLD.node2, 
		    OLD.start_date, 
		    OLD.end_date,
		    OLD.details, 
		    OLD.added_by, 
		    OLD.date_added, 
		    OLD.is_active, 
		    OLD.mod_by, 
		    OLD.mod_date, 
		    OLD.mod_version);
        	
        	RETURN OLD;
        ELSIF (TG_OP = ''UPDATE'') THEN
    	    INSERT INTO edge_audit 
		    (
		    operation, 
		    orig_id, 
		    edge_type, 
		    node1, 
		    node2, 
		    start_date, 
		    end_date,
		    details, 
		    added_by, 
		    date_added, 
		    is_active, 
		    mod_by, 
		    mod_date, 
		    mod_version
		    ) 
		    VALUES 
		    (
		    ''U'', 
		    NEW.id, 
		    NEW.edge_type, 
		    NEW.node1, 
		    NEW.node2, 
		    NEW.start_date, 
		    NEW.end_date,
		    NEW.details, 
		    NEW.added_by, 
		    NEW.date_added, 
		    NEW.is_active, 
		    NEW.mod_by, 
		    NEW.mod_date, 
		    NEW.mod_version);
            RETURN NEW;
        ELSIF (TG_OP = ''INSERT'') THEN
			INSERT INTO edge_audit 
		    (
		    operation, 
		    orig_id, 
		    edge_type, 
		    node1, 
		    node2, 
		    start_date, 
		    end_date,
		    details, 
		    added_by, 
		    date_added, 
		    is_active, 
		    mod_by, 
		    mod_date, 
		    mod_version
		    ) 
		    VALUES 
		    (
		    ''U'', 
		    NEW.id, 
		    NEW.edge_type, 
		    NEW.node1, 
		    NEW.node2, 
		    NEW.start_date, 
		    NEW.end_date,
		    NEW.details, 
		    NEW.added_by, 
		    NEW.date_added, 
		    NEW.is_active, 
		    NEW.mod_by, 
		    NEW.mod_date, 
		    NEW.mod_version);
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER edge_audit
AFTER INSERT OR UPDATE OR DELETE ON edge
    FOR EACH ROW EXECUTE PROCEDURE process_edge_audit();