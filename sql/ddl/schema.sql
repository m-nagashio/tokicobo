create table talk_keyword (
  id int not null,
  sentiment_type tinyint unsigned not null default 0 comment '0: Negative, 1: Positive',
  talk_count int unsigned not null,
  keyword varchar(30) not null,
  primary key(id),
  key key1(sentiment_type, talk_count)
);