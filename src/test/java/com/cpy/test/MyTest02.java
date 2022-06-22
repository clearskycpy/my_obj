package com.cpy.test;

import com.cpy.commons.utils.UUIDUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.junit.Test;

import java.io.FileOutputStream;
import java.io.IOException;

public class MyTest02 {
    @Test
    public void excelFileAPITest() throws IOException {
//        定义一个工作区 （文件本身）
        HSSFWorkbook wb = new HSSFWorkbook();
//        在工作区中生成一页
        HSSFSheet sheet = wb.createSheet("student1");
//        创建行对象
        HSSFRow row = sheet.createRow(0);
//        从0开始
        HSSFCell cell = row.createCell(0);
//        表示一行一列
        cell.setCellValue("姓名");
//        一行的二列
        cell = row.createCell(1);

        cell.setCellValue("班级");
//        内置样式的使用
        HSSFCellStyle cellStyle = wb.createCellStyle(); // 行样式
        cellStyle.setAlignment(HorizontalAlignment.CENTER);  // 文本居中显示
//        其他样式也可以通过方法调用修改
//        定义好的style可以传给列元素


//        使用sheet创建row对象
        for (int i = 1; i <= 10; i++) {
            row = sheet.createRow(i);
            cell = row.createCell(0);
            cell.setCellValue("abc" + i);
            cell = row.createCell(1);
            cell.setCellStyle(cellStyle);
            // 添加样式 ， 既然样式可以封装。那么意味着肯定网上是肯定有封装好的样式可以使用的

            cell.setCellValue("班级"+i);
        }
//        生成excel文件
        FileOutputStream fileOutputStream = new FileOutputStream("D:\\Document\\SSM_CRM\\项目资料\\clientDir\\"+ UUIDUtils.createUUID().substring(0,8)+".xls");
        wb.write(fileOutputStream);
        fileOutputStream.close();
        wb.close();
    }

    @Test
    public void sub(){
        String s = "abcde";
        System.out.println(s.substring(0,s.length()));
    }



}
