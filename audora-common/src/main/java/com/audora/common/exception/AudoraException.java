package com.audora.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public class AudoraException extends RuntimeException {
    private final HttpStatus status;
    private final String errorCode;

    public AudoraException(String message, HttpStatus status, String errorCode) {
        super(message);
        this.status = status;
        this.errorCode = errorCode;
    }

    public AudoraException(String message, HttpStatus status, String errorCode, Throwable cause) {
        super(message, cause);
        this.status = status;
        this.errorCode = errorCode;
    }
}
