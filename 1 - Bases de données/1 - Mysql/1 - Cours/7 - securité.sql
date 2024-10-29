create user oussama@'%' identified by '123456';
set password for oussama@'%' = 'abcdefg';
grant all privileges on cuisine_202.* to  oussama@'%';