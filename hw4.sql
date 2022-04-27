create table artist (
    id smallint auto_increment primary key,
    name varchar(50) not null unique
);
create table album(
    albumID smallint auto_increment primary key,
    albumName varchar(50), 
    artistID smallint references artist,
    unique(albumName, artistID)
);
create table genreList(
    genreID smallint primary key,
    name varchar(50) not null unique
);
create table songGenres(
    songID smallint not null,
    genreID smallint references genreList not null,
    primary key(songID, genreID)
);
create table song(
    songID smallint primary key,
    title varchar(50) not null, 
    artistID smallint references artist not null,
    albumID smallint references album,
    releaseDate date not null,
    unique(title, artistID)
);
create table user(
    userID smallint primary key,
    username varchar(50) unique
);
create table playlistSongs(
    playlistID references playlist,
    songID references song,
    primary key(playlistID, songID)
)
create table playlist(
    playlistID smallint primary key,
    name varchar(50) not null,
    userID smallint not null,
    unique(name, userID)
)


 



