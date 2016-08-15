CREATE TABLE def_edge_type(
id int PRIMARY KEY,
edge_type text,
edge_sub_type text
);

INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (1, 'ORG2ORG', 'Funding');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (2, 'ORG2ORG', 'Training');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (3, 'ORG2ORG', 'Subsidiary');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (4, 'ORG2ORG', 'Regulatory');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (5, 'ORG2ORG', 'Monitoring');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (6, 'ORG2ORG', 'Partnership');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (7, 'ORG2ORG', 'Other');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (8, 'ORG2ORG', 'Supporter');


INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (101, 'ORG2IND', 'Employee');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (102, 'ORG2IND', 'Director');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (103, 'ORG2IND', 'Head/Leader');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (104, 'ORG2IND', 'Owner/Shareholder');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (105, 'ORG2IND', 'Member');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (106, 'ORG2IND', 'Funder');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (107, 'ORG2IND', 'Consultant');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (108, 'ORG2IND', 'Education');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (109, 'ORG2IND', 'Other');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (110, 'ORG2IND', 'Supporter');


INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (201, 'IND2IND', 'Family');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (202, 'IND2IND', 'Associates');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (203, 'IND2IND', 'Opponents');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (204, 'IND2IND', 'Mentor');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (205, 'IND2IND', 'Supporter');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (206, 'IND2IND', 'Funder');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (207, 'IND2IND', 'Other');




INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (301, 'ORG2EVE', 'Organiser');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (302, 'ORG2EVE', 'Funder');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (303, 'ORG2EVE', 'Participant');

INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (401, 'IND2EVE', 'Presenter');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (402, 'IND2EVE', 'Attendee');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (403, 'IND2EVE', 'Organiser');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (404, 'IND2EVE', 'Funder');

INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (501, 'ORG2PUB', 'Publisher');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (502, 'ORG2PUB', 'Funder');

INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (601, 'IND2PUB', 'Author');
INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (602, 'IND2PUB', 'Funder');

INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (701, 'PUB2PUB', 'Reference');

INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (801, 'EVE2EVE', 'Related Event Series');

INSERT INTO def_edge_type (id, edge_type, edge_sub_type)
VALUES (901, 'EVE2PUB', 'Conference Paper');