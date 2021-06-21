USE `evoppi`;

INSERT INTO `user` (`login`, `role`, `email`, `password`)
VALUES ('admin', 'ADMIN', 'admin@email.com', '%%ADMIN_PASSWORD%%');
INSERT INTO `user` (`login`, `role`, `email`, `password`)
VALUES ('researcher', 'RESEARCHER', 'researcher@email.com', '%%RESEARCHER_PASSWORD%%');

INSERT INTO `administrator` (`login`) VALUES ('admin');
INSERT INTO `researcher` (`login`) VALUES ('researcher');

