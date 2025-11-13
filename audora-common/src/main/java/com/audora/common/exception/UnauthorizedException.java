package com.audora.common.exception;

import org.springframework.http.HttpStatus;

public class UnauthorizedException extends AudoraException {
    public UnauthorizedException(String message) {
        super(message, HttpStatus.UNAUTHORIZED, "UNAUTHORIZED");
    }
}
