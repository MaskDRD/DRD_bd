CREATE TABLE users(
	id int AUTO_INCREMENT,
	login varchar(128),
	password varchar(256),
	email varchar(128),
	check_active boolean default 1,
	check_conf_email boolean default 0,
	CONSTRAINT customers_pk PRIMARY KEY(id),
	CONSTRAINT customers_login_uq UNIQUE KEY(login),
	CONSTRAINT customers_email_uq UNIQUE KEY(email),
);

-- bd.UserGetWhereTokenValue
DROP PROCEDURE IF EXISTS bd.UserGetWhereTokenValue;
CREATE DEFINER = `root` @`localhost` PROCEDURE bd.UserGetWhereTokenValue(in _token varchar(256)) 
begin
	select
		u.id,
		u.login,
		u.email,
		u.check_active,
		u.check_conf_email,
		t.id as token_id, 
		t.value as token_value,
		t.date as token_date
	from users u
	left join token t ON t.id_user = u.id
	where t.value = _token
	limit 1;
end

-- bd.UserGetWhereTokenId
DROP PROCEDURE IF EXISTS bd.UserGetWhereTokenId;
CREATE DEFINER = `root` @`localhost` PROCEDURE bd.UserGetWhereTokenId(in _token_id int) 
begin
	select
		u.id,
		u.login,
		u.email,
		u.check_active,
		u.check_conf_email,
		t.id as token_id, 
		t.value as token_value,
		t.date as token_date
	from users u
	left join token t ON t.id_user = u.id
	where t.id = _token_id
	limit 1;
end

-- bd.UserGetWhereId
DROP PROCEDURE IF EXISTS bd.UserGetWhereId;
CREATE DEFINER = `root` @`localhost` PROCEDURE bd.UserGetWhereId(in _id int) 
begin
	select
		u.id,
		u.login,
		u.email,
		u.check_active,	
		u.check_conf_email
	from users u
	where u.id = _id
	limit 1;
end

-- bd.UserCheck
DROP PROCEDURE IF EXISTS bd.UserCheck;
CREATE DEFINER=`root`@`localhost` PROCEDURE `bd`.`UserCheck`(
	in _login varchar(128),
	in _email varchar(128),
	out check_login_ boolean,
	out check_email_ boolean
)
begin
	select count(u.login) into check_login_ from users u where u.login = _login limit 1;
	select count(u.email) into check_email_ from users u where u.email = _email limit 1;
end

-- bd.UserCreate
DROP PROCEDURE IF EXISTS bd.UserCreate;
CREATE DEFINER = `root` @`localhost` PROCEDURE bd.UserCreate(
	in _login varchar(128),
	in _password varchar(256),
	in _email varchar(128)
) 
begin
	INSERT users(login, password, email)
	VALUES (_login, _password, _email);
	select LAST_INSERT_ID() as id;
end