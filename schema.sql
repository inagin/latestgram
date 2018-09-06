CREATE TABLE article #記事
(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	created_at DATETIME,
	user_id INT,
	image TEXT,
	good INT,
	contents TEXT,
	PRIMARY KEY(id)
);

CREATE TABLE user #ユーザー
(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	name CHAR(191),
	password CHAR(100),
	PRIMARY KEY(id)
);

CREATE TABLE comment #コメント
(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	created_at DATETIME, #コメントの日付
	user_id INT, #投稿者のID
	article_id INT, #どの記事に対するコメントか 
	contents TEXT,
	PRIMARY KEY(id)
);