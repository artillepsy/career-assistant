package com.artillepsy.career_assistant_api;

import org.springframework.boot.SpringApplication;

public class TestCareerAssistantApiApplication {

	public static void main(String[] args) {
		SpringApplication.from(CareerAssistantApiApplication::main).with(TestcontainersConfiguration.class).run(args);
	}

}
