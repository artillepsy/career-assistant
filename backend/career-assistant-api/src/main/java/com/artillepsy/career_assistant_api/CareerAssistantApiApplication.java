package com.artillepsy.career_assistant_api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.hibernate.autoconfigure.HibernateJpaAutoConfiguration;
import org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration;
import org.springframework.boot.jdbc.autoconfigure.DataSourceTransactionManagerAutoConfiguration;

// todo: temporary fix, remove exclude block later, after adding functionality
@SpringBootApplication(exclude = {
		DataSourceAutoConfiguration.class,
		DataSourceTransactionManagerAutoConfiguration.class,
		HibernateJpaAutoConfiguration.class,
})
public class CareerAssistantApiApplication {

	public static void main(String[] args) {
		SpringApplication.run(CareerAssistantApiApplication.class, args);
	}

}
