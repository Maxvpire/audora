-- Seed Data for Audora Database
-- Sample data for development and testing

\c audora_music;

-- Insert sample artists
INSERT INTO artists (id, name, bio, verified, monthly_listeners, country) VALUES
('a1111111-1111-1111-1111-111111111111', 'The Weeknd', 'Canadian R&B artist', TRUE, 95000000, 'Canada'),
('a2222222-2222-2222-2222-222222222222', 'Taylor Swift', 'American singer-songwriter', TRUE, 80000000, 'USA'),
('a3333333-3333-3333-3333-333333333333', 'Drake', 'Canadian rapper and singer', TRUE, 75000000, 'Canada'),
('a4444444-4444-4444-4444-444444444444', 'Billie Eilish', 'American pop artist', TRUE, 60000000, 'USA'),
('a5555555-5555-5555-5555-555555555555', 'Ed Sheeran', 'British singer-songwriter', TRUE, 70000000, 'UK');

-- Insert sample albums
INSERT INTO albums (id, title, artist_id, release_date, album_type, total_tracks, genre) VALUES
('b1111111-1111-1111-1111-111111111111', 'After Hours', 'a1111111-1111-1111-1111-111111111111', '2020-03-20', 'ALBUM', 14, 'RNB'),
('b2222222-2222-2222-2222-222222222222', '1989', 'a2222222-2222-2222-2222-222222222222', '2014-10-27', 'ALBUM', 13, 'POP'),
('b3333333-3333-3333-3333-333333333333', 'Certified Lover Boy', 'a3333333-3333-3333-3333-333333333333', '2021-09-03', 'ALBUM', 21, 'HIP_HOP'),
('b4444444-4444-4444-4444-444444444444', 'Happier Than Ever', 'a4444444-4444-4444-4444-444444444444', '2021-07-30', 'ALBUM', 16, 'POP'),
('b5555555-5555-5555-5555-555555555555', 'Divide', 'a5555555-5555-5555-5555-555555555555', '2017-03-03', 'ALBUM', 16, 'POP');

-- Insert sample songs
INSERT INTO songs (id, title, artist_id, album_id, duration, genre, release_date, audio_file_url, play_count) VALUES
('s1111111-1111-1111-1111-111111111111', 'Blinding Lights', 'a1111111-1111-1111-1111-111111111111', 'b1111111-1111-1111-1111-111111111111', 200, 'RNB', '2020-03-20', 'https://audora-music.s3.amazonaws.com/songs/blinding-lights.mp3', 5000000),
('s2222222-2222-2222-2222-222222222222', 'Shake It Off', 'a2222222-2222-2222-2222-222222222222', 'b2222222-2222-2222-2222-222222222222', 219, 'POP', '2014-10-27', 'https://audora-music.s3.amazonaws.com/songs/shake-it-off.mp3', 4500000),
('s3333333-3333-3333-3333-333333333333', 'Way 2 Sexy', 'a3333333-3333-3333-3333-333333333333', 'b3333333-3333-3333-3333-333333333333', 258, 'HIP_HOP', '2021-09-03', 'https://audora-music.s3.amazonaws.com/songs/way-2-sexy.mp3', 3000000),
('s4444444-4444-4444-4444-444444444444', 'bad guy', 'a4444444-4444-4444-4444-444444444444', NULL, 194, 'POP', '2019-03-29', 'https://audora-music.s3.amazonaws.com/songs/bad-guy.mp3', 6000000),
('s5555555-5555-5555-5555-555555555555', 'Shape of You', 'a5555555-5555-5555-5555-555555555555', 'b5555555-5555-5555-5555-555555555555', 233, 'POP', '2017-03-03', 'https://audora-music.s3.amazonaws.com/songs/shape-of-you.mp3', 7000000);

-- Insert sample song features
INSERT INTO song_features (song_id, tempo, energy, danceability, valence, acousticness) VALUES
('s1111111-1111-1111-1111-111111111111', 171.0, 0.73, 0.51, 0.33, 0.001),
('s2222222-2222-2222-2222-222222222222', 160.0, 0.80, 0.65, 0.94, 0.075),
('s3333333-3333-3333-3333-333333333333', 98.0, 0.57, 0.78, 0.58, 0.19),
('s4444444-4444-4444-4444-444444444444', 135.0, 0.43, 0.70, 0.56, 0.33),
('s5555555-5555-5555-5555-555555555555', 96.0, 0.65, 0.83, 0.93, 0.58);

\c audora_users;

-- Note: User data will be created through the Auth Service registration endpoint
-- This is just sample playlist data for testing

-- Sample playlists would be created here after users are registered
