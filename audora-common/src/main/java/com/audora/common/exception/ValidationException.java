package com.audora.common.exception;

import org.springframework.http.HttpStatus;

public class ValidationException extends AudoraException {
    public ValidationException(String message) {
        super(message, HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
    }
}
