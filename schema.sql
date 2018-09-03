CREATE TABLE article #記事
(
	id INT NOT NULL,
	created_at DATETIME,
	image INT,
	good INT
);

CREATE TABLE user #ユーザー
(
	id INT NOT NULL,
	password CHAR(100)
);

CREATE TABLE comment #コメント
(
	id INT NOT NULL,
	user_id INT, #投稿者のID
	article_id INT, #どの記事に対するコメントか 
	contents TEXT	
);