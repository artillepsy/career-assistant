package com.artillepsy.career_assistant_api;


import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

import static org.junit.jupiter.api.Assertions.assertTrue;

@Import(TestcontainersConfiguration.class)
@SpringBootTest
class CareerAssistantApiApplicationTests {

	@Test
	void contextLoads() {
		assertTrue(true);
	}

}
