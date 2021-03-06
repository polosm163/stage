package com.yiie.common.mapper;

import com.yiie.entity.LoginLog;
import com.yiie.vo.request.LoginLogPageReqVO;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Time：2020-1-2 21:01
 * Email： yiie315@163.com
 * Desc：
 *
 * @author： yiie
 * @version：1.0.0
 */
@Repository
@Mapper
public interface LoginLogMapper {

    int saveLoginLog(LoginLog log);

    List<LoginLog> selectAll(LoginLogPageReqVO vo);

    void batchDeletedLog(List<String> logIds);
}
