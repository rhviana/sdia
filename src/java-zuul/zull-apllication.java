package com.sdia.ddcr;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;

/**
 * SDIA DDCR — Phantom v12 | Netflix Zuul Gateway
 * Ricardo Luz Holanda Viana | March 2026
 * The domain never lies.
 */
@SpringBootApplication
@EnableZuulProxy
public class DdcrZuulApplication {
    public static void main(String[] args) {
        SpringApplication.run(DdcrZuulApplication.class, args);
    }
}
