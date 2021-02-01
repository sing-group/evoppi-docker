USE `evoppi`;

INSERT INTO `user` (`login`, `role`, `email`, `password`)
VALUES ('admin', 'ADMIN', 'admin@email.com', '%%ADMIN_PASSWORD%%');
INSERT INTO `user` (`login`, `role`, `email`, `password`)
VALUES ('researcher', 'RESEARCHER', 'researcher@email.com', '%%RESEARCHER_PASSWORD%%');

INSERT INTO `administrator` (`login`) VALUES ('admin');
INSERT INTO `researcher` (`login`) VALUES ('researcher');

UPDATE gene g
SET g.defaultName = (SELECT name FROM gene_name_value WHERE geneId = g.id ORDER BY IF(name RLIKE '^[a-z]', 1, 2), name LIMIT 1);
