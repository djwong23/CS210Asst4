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