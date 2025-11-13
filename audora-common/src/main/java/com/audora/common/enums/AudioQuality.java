package com.audora.common.enums;

public enum AudioQuality {
    LOW(128),      // 128 kbps
    MEDIUM(192),   // 192 kbps
    HIGH(320),     // 320 kbps
    LOSSLESS(1411); // CD quality

    private final int bitrate;

    AudioQuality(int bitrate) {
        this.bitrate = bitrate;
    }

    public int getBitrate() {
        return bitrate;
    }
}
