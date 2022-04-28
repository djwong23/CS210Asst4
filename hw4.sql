create table artist(
    id int auto_increment primary key,
    name varchar(50) not null unique
);

create table album(
    albumID int auto_increment primary key,
    albumName varchar(50) not null,
    artistID int references artist not null,
    released date references song not null,
    unique(albumName, artistID)
);

create table genreList(
    genreID tinyint auto_increment primary key,
    name varchar(50) not null unique
);

create table songGenres(
    songID int not null,
    genreID tinyint references genreList not null,
    primary key(songID, genreID)
);

create table song(
    songID int auto_increment primary key,
    title varchar(50) not null,
    artistID int references artist not null,
    albumID int references album,
    releaseDate date not null,
    unique(title, artistID)
);

create table user(
    userID int auto_increment primary key,
    username varchar(50) not null unique
);

create table playlistSongs(
    playlistID int references playlist,
    songID int references song,
    primary key(playlistID, songID)
);

create table playlist(
    playlistID int auto_increment primary key,
    title varchar(50) not null,
    created datetime not null,
    userID int references user not null,
    unique(title, userID)
);

create table AlbumRating(
    albumID int references album not null,
    userID int references user not null,
    rating tinyInt check (
        rating >= 1
        and rating <= 5
    ),
    created date,
    primary key(albumID, userID, created)
);

create table SongRating(
    songID int references song not null,
    userID int references user not null,
    rating tinyInt check (
        rating >= 1
        and rating <= 5
    ),
    created date,
    primary key(albumID, userID, created)
);

create table PlaylistRating(
    playlistID int references playlist not null,
    userID int references user not null,
    rating tinyInt check (
        rating >= 1
        and rating <= 5
    ),
    created date,
    primary key(albumID, userID, created)
);