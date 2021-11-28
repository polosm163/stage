package com.yiie;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@MapperScan("com.yiie.commmon.mapper")
@ComponentScan(basePackages={"com.ai","com.yiie"})
public class StageApplication {

    public static void main(String[] args) {
        //在App类main方法中加上下面红色这句，开发时如果有小的改动（不新增方法、变量）时，可以不自动重启而代码生效
        //System.setProperty("spring.devtools.restart.enabled", "false")
        SpringApplication.run(StageApplication.class, args);
    }

}




