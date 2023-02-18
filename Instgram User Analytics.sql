use trainity;
# Q1 Oldest Users
select * from users order by created_at asc limit 5;

# Q2 Inactive Users
select * from users;
select username inactive_users from users
left join photos on users.id = photos.user_id where photos.id is null;

# Q3 Contest Winner
select username, photos.id, photos.image_url, count(*) as Total_likes from photos
inner join likes on likes.photo_id = photos.id
inner join users on photos.user_id = users.id
group by photos.id
order by Total_likes desc
limit 3;

# Q4 Hashtag Researching
select tags.tag_name, count(*) as total_tags from photo_tags
inner join tags on photo_tags.tag_id = tags.id
group by tags.id
order by total_tags desc
limit 5;

# Q5 Launch AD Campaign
select dayname(created_at) as Day_Name, count(*) as Total from users
group by day_name
order by total desc
limit 4;

# Q6 User Engagement
select (select count(*) from photos) / (select count(*) from users) as Average,
count(*) as Total_Photos from photos;

# Q7 Bots & Fake Accounts
select username, user_id, count(*) as total_likes from users
inner join likes on users.id = likes.user_id
group by likes.user_id
having total_likes = (select count(*) from photos);


