package com.cpy.commons.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

public class IOUtils {
    /**
     * 实现流对拷的方式
     * @param fileInputStream
     * @param outputStream
     * @throws IOException
     */
    public static void copy(FileInputStream fileInputStream, OutputStream outputStream) throws IOException {
        byte[] buffer = new byte[1024*4];
        int len = 0;
        while ((len = fileInputStream.read(buffer)) != -1){
            outputStream.write(buffer,0,len);
        }
    }
}
