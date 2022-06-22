package com.cpy.commons.utils;

import java.util.UUID;

public class UUIDUtils {
    /**
     * 获取UUID值
     * @return
     */
    public static String createUUID(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}
