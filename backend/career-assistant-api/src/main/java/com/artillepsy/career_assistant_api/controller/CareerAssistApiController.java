package com.artillepsy.career_assistant_api.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class CareerAssistApiController {

    @GetMapping("/test")
    public String getTestStr() // async
    {
        return "test_response";
    }
}
