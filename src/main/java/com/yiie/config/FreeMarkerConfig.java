package com.yiie.config;

import com.google.common.collect.Lists;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

/**
 * 配置freemarker全局变量
 *
 * @author chengjie
 * @date 2020年03月19日09:29:13
 */

@Slf4j
@Data
@Configuration
@NoArgsConstructor
@AllArgsConstructor
@ConfigurationProperties(prefix = "web.page")
public class FreeMarkerConfig {

    @Resource
    private freemarker.template.Configuration configuration;


    private InternalResourceViewResolver resourceViewResolver;

    // @Value("${ctx}")
    private String version;

    private String autoIncludes;

    @Autowired
    private Environment env;


    @Autowired
    private Map<String, Object> variables ;


    /**
     * Spring 初始化的时候加载配置
     */
    @PostConstruct
    public void setConfigure() throws Exception {
        //configuration.setSharedVariable("version", version);
        //variables.put("ctx2", env.getProperty("server.servlet.context-path", ""));
        configuration.setSharedVaribles(variables);


        //配置自动includes 模板路径
        List<String> autoIncludesList = Lists.newArrayListWithCapacity(1);
        autoIncludes = env.getProperty("spring.freemarker.auto_include_path", "");
        if (StringUtils.isNotEmpty( autoIncludes)) {
            autoIncludesList.addAll(Arrays.asList(StringUtils.split(autoIncludes, ",")));
        }

        configuration.setAutoIncludes(autoIncludesList);

    }



}
