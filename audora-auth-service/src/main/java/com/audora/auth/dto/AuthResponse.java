package com.audora.auth.dto;

import com.audora.common.enums.UserRole;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

@Data
@Builder
public class AuthResponse {
    private UUID userId;
    private String email;
    private String fullName;
    private UserRole role;
    private String accessToken;
    private String refreshToken;
    private Long expiresIn;
}
