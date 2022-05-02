create table artist(
    id int auto_increment primary key,
    name varchar(50) not null unique
);

create table album(
    albumID int auto_increment primary key,
    albumName varchar(50) not null,
    artistID int not null,
    foreign key(artistID) references artist(id),
    unique(albumName, artistID)
);

create table genreList(
    genreID tinyint auto_increment primary key,
    name varchar(50) not null unique
);

create table songGenres(
    songID int not null,
    genreID tinyint not null,
    foreign key(genreID) references genreList(genreID),
    primary key(songID, genreID)
);

create table song(
    songID int auto_increment primary key,
    title varchar(50) not null,
    artistID int not null,
    albumID int,
    foreign key(artistID) references artist(id),
    foreign key(albumID) references album(albumID),
    releaseDate date not null,
    unique(title, artistID)
);

create table user(
    userID int auto_increment primary key,
    username varchar(50) not null unique
);

create table playlist(
    playlistID int auto_increment primary key,
    title varchar(50) not null,
    created datetime not null,
    userID int not null,
    foreign key(userID) references user(userID),
    unique(title, userID)
);

create table playlistSongs(
    playlistID int,
    songID int,
    foreign key(playlistID) references playlist(playlistID),
    foreign key(songID) references song(songID),
    primary key(playlistID, songID)
);

create table AlbumRating(
    userID int not null,
    albumID int not null,
    foreign key(userID) references user(userID),
    foreign key(albumID) references album(albumID),
    rating tinyInt check (
        rating >= 1
        and rating <= 5
    ),
    created date,
    primary key(albumID, userID, created)
);

create table SongRating(
    userID int not null,
    songID int not null,
    foreign key(songID) references song(songID),
    foreign key(userID) references user(userID),
    rating tinyInt check (
        rating >= 1
        and rating <= 5
    ),
    created date,
    primary key(songID, userID, created)
);

create table PlaylistRating(
    playlistID int not null,
    userID int not null,
    foreign key(playlistID) references playlist(playlistID),
    foreign key(userID) references user(userID),
    rating tinyInt check (
        rating >= 1
        and rating <= 5
    ),
    created date,
    primary key(playlistID, userID, created)
);

-- problem 1
select
    gl.name,
    count(*)
from
    songGenres sg,
    genreList gl
where
    gl.genreID = sg.genreID
group by
    sg.genreID
order by
    count(*) DESC
limit
    3;

-- problem 2
select
    distinct a.name artist_name
from
    song s,
    artist a
where
    s.artistID = a.id
    and a.id in (
        select
            distinct a1.artistID
        from
            album a1
    )
    and a.id in (
        select
            s.artistID
        from
            song s
        where
            s.albumID is null
    );

-- problem 3
select
    a.albumName album_name,
    avg(ar.rating) average_user_rating
from
    AlbumRating ar,
    album a
where
    ar.created >= "1990-01-01"
    and ar.created <= "1999-12-31"
    and a.albumID = ar.albumID
group by
    ar.albumID
order by
    avg(ar.rating) DESC
limit
    10;

-- problem 4
select
    gl.name genre_name,
    count(*) number_of_song_ratings
from
    SongRating sr,
    songGenres sg,
    genreList gl
where
    sr.created >= "1991-01-01"
    and sr.created <= "1995-12-31"
    and sr.songID = sg.songID
    and sg.genreID = gl.genreID
group by
    gl.name
order by
    count(*) DESC,
    gl.name ASC
limit
    3;

--problem 5
select
    u.username username,
    p.title playlist_title,
    avgPR.avgPsRating average_song_rating
from
    (
        select
            ps.playlistID,
            avg(avgRating) avgPsRating
        from
            playlistSongs ps
            left join (
                select
                    sr.songID,
                    avg(sr.rating) avgRating
                from
                    SongRating sr
                group by
                    sr.songID
            ) temp1 on temp1.songID = ps.songID
        group by
            ps.playlistID
    ) avgPR,
    user u,
    playlist p
where
    u.userID = p.userID
    and p.playlistID = avgPR.playlistID
    and avgPR.avgPsRating >= 4;

--problem 6
select
    u.username username,
    sum(ratingCountByUser.rcount) number_of_ratings
from
    (
        select
            sr.userID,
            count(*) rcount
        from
            SongRating sr
        group by
            sr.userID
        union
        all
        select
            ar.userID,
            count(*) rcount
        from
            AlbumRating ar
        group by
            ar.userID
    ) ratingCountByUser,
    user u
where
    u.userID = ratingCountByUser.userID
group by
    ratingCountByUser.userID
order by
    sum(ratingCountByUser.rcount) DESC
limit
    5;

-- problem 7
select
    a.name artist_name,
    count(*) number_of_songs
from
    song s,
    artist a
where
    s.releaseDate >= "1990-01-01"
    and s.releaseDate <= "2010-12-31"
    and a.id = s.artistID
group by
    s.artistID
order by
    count(*) DESC
limit
    10;

-- problem 8
select
    s.title song_title,
    count(*) number_of_playlists
from
    playlistSongs ps,
    song s
where
    ps.songID = s.songID
group by
    ps.songID
order by
    count(*) DESC,
    s.title ASC
limit
    10;

--problem 9
select
    s.title song_title,
    a.name artist_name,
    count(*) number_of_ratings
from
    SongRating sr,
    song s,
    artist a
where
    sr.songID = s.songID
    and a.id = s.artistID
    and s.albumID is null
group by
    sr.songID
order by
    count(*) DESC
limit
    20;

--problem 10
select
    a.name artist_title
from
    artist a
where
    a.id not in (
        select
            distinct s.artistID
        from
            song s
        where
            s.releaseDate >= "1994-01-01"
    );