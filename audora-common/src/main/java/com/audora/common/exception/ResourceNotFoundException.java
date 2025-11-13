package com.audora.common.exception;

import org.springframework.http.HttpStatus;

public class ResourceNotFoundException extends AudoraException {
    public ResourceNotFoundException(String resourceName, String identifier) {
        super(
            String.format("%s not found with identifier: %s", resourceName, identifier),
            HttpStatus.NOT_FOUND,
            "RESOURCE_NOT_FOUND"
        );
    }
}
