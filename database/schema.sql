-- Audora Database Schema
-- PostgreSQL 14+

-- Create Databases
CREATE DATABASE IF NOT EXISTS audora_auth;
CREATE DATABASE IF NOT EXISTS audora_users;
CREATE DATABASE IF NOT EXISTS audora_music;
CREATE DATABASE IF NOT EXISTS audora_analytics;

-- =======================
-- AUTH SERVICE SCHEMA
-- =======================
\c audora_auth;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('USER', 'ARTIST', 'ADMIN', 'PREMIUM_USER')),
    email_verified BOOLEAN DEFAULT FALSE,
    active BOOLEAN DEFAULT TRUE,
    profile_picture VARCHAR(500),
    oauth_provider VARCHAR(50),
    oauth_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_oauth ON users(oauth_provider, oauth_id);

-- Refresh Tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    token VARCHAR(500) UNIQUE NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    expiry_date TIMESTAMP NOT NULL,
    revoked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_token ON refresh_tokens(token);

-- =======================
-- USER SERVICE SCHEMA
-- =======================
\c audora_users;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- User Profiles table (extended profile information)
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE NOT NULL,
    bio TEXT,
    country VARCHAR(100),
    preferred_language VARCHAR(10) DEFAULT 'en',
    date_of_birth DATE,
    gender VARCHAR(20),
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_profiles_user ON user_profiles(user_id);

-- Subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    tier VARCHAR(50) NOT NULL CHECK (tier IN ('FREE', 'PREMIUM_MONTHLY', 'PREMIUM_YEARLY', 'ARTIST_PRO')),
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    auto_renew BOOLEAN DEFAULT TRUE,
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);

-- Playlists table
CREATE TABLE IF NOT EXISTS playlists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    cover_image VARCHAR(500),
    total_duration INTEGER DEFAULT 0,
    song_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_playlists_user ON playlists(user_id);
CREATE INDEX idx_playlists_public ON playlists(is_public);

-- Playlist Songs table (many-to-many relationship)
CREATE TABLE IF NOT EXISTS playlist_songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    playlist_id UUID NOT NULL REFERENCES playlists(id) ON DELETE CASCADE,
    song_id UUID NOT NULL,
    position INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_playlist_songs_playlist ON playlist_songs(playlist_id);
CREATE INDEX idx_playlist_songs_song ON playlist_songs(song_id);
CREATE UNIQUE INDEX idx_playlist_songs_unique ON playlist_songs(playlist_id, song_id);

-- User Favorites table
CREATE TABLE IF NOT EXISTS user_favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    song_id UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_favorites_user ON user_favorites(user_id);
CREATE INDEX idx_favorites_song ON user_favorites(song_id);
CREATE UNIQUE INDEX idx_favorites_unique ON user_favorites(user_id, song_id);

-- =======================
-- MUSIC CATALOG SCHEMA
-- =======================
\c audora_music;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Artists table
CREATE TABLE IF NOT EXISTS artists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    bio TEXT,
    profile_picture VARCHAR(500),
    verified BOOLEAN DEFAULT FALSE,
    monthly_listeners BIGINT DEFAULT 0,
    total_plays BIGINT DEFAULT 0,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_artists_name ON artists(name);
CREATE INDEX idx_artists_verified ON artists(verified);

-- Albums table
CREATE TABLE IF NOT EXISTS albums (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    artist_id UUID NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
    release_date DATE,
    cover_image VARCHAR(500),
    album_type VARCHAR(50) CHECK (album_type IN ('ALBUM', 'SINGLE', 'EP', 'COMPILATION')),
    total_tracks INTEGER DEFAULT 0,
    total_duration INTEGER DEFAULT 0,
    genre VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_albums_artist ON albums(artist_id);
CREATE INDEX idx_albums_release_date ON albums(release_date);
CREATE INDEX idx_albums_genre ON albums(genre);

-- Songs table
CREATE TABLE IF NOT EXISTS songs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    artist_id UUID NOT NULL REFERENCES artists(id) ON DELETE CASCADE,
    album_id UUID REFERENCES albums(id) ON DELETE SET NULL,
    duration INTEGER NOT NULL,
    genre VARCHAR(50),
    release_date DATE,
    audio_file_url VARCHAR(500) NOT NULL,
    cover_image VARCHAR(500),
    lyrics TEXT,
    is_explicit BOOLEAN DEFAULT FALSE,
    play_count BIGINT DEFAULT 0,
    like_count BIGINT DEFAULT 0,
    quality VARCHAR(50) DEFAULT 'HIGH',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_songs_title ON songs(title);
CREATE INDEX idx_songs_artist ON songs(artist_id);
CREATE INDEX idx_songs_album ON songs(album_id);
CREATE INDEX idx_songs_genre ON songs(genre);
CREATE INDEX idx_songs_release_date ON songs(release_date);
CREATE INDEX idx_songs_play_count ON songs(play_count DESC);

-- Song Features (for AI recommendations)
CREATE TABLE IF NOT EXISTS song_features (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    song_id UUID UNIQUE NOT NULL REFERENCES songs(id) ON DELETE CASCADE,
    tempo FLOAT,
    energy FLOAT,
    danceability FLOAT,
    valence FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    loudness FLOAT,
    key INTEGER,
    mode INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_song_features_song ON song_features(song_id);

-- =======================
-- ANALYTICS SCHEMA
-- =======================
\c audora_analytics;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Play History table
CREATE TABLE IF NOT EXISTS play_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    song_id UUID NOT NULL,
    played_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_played INTEGER,
    completed BOOLEAN DEFAULT FALSE,
    device_type VARCHAR(50),
    country VARCHAR(100)
);

CREATE INDEX idx_play_history_user ON play_history(user_id);
CREATE INDEX idx_play_history_song ON play_history(song_id);
CREATE INDEX idx_play_history_played_at ON play_history(played_at DESC);

-- User Activity Log
CREATE TABLE IF NOT EXISTS user_activity (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_activity_user ON user_activity(user_id);
CREATE INDEX idx_user_activity_type ON user_activity(activity_type);
CREATE INDEX idx_user_activity_created ON user_activity(created_at DESC);

-- Artist Analytics
CREATE TABLE IF NOT EXISTS artist_analytics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    artist_id UUID NOT NULL,
    date DATE NOT NULL,
    total_plays BIGINT DEFAULT 0,
    unique_listeners BIGINT DEFAULT 0,
    revenue DECIMAL(10, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_artist_analytics_artist ON artist_analytics(artist_id);
CREATE INDEX idx_artist_analytics_date ON artist_analytics(date DESC);
CREATE UNIQUE INDEX idx_artist_analytics_unique ON artist_analytics(artist_id, date);
