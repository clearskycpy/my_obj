package com.cpy.commons.utils;

import com.cpy.workbench.domain.Activity;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class HSSFWorkbookUtils {

    private static String[] activityColumnsName = {"ID","owner","name","startDate","endDate","cost",
            "description","createTime","createBy","editTime","editBy"};

    /**
     * 将一个Activity集合 转换为 一个HSSFWorkbook对象
     * @param activities
     * @return
     */
    public static HSSFWorkbook CreateHSSFWorkbook(List<Activity> activities){
//        定义一个工作区
        HSSFWorkbook wbJob = new HSSFWorkbook();
//        定义一个页
        HSSFSheet activitySheet = wbJob.createSheet("activitySheet");
//        创建一个行  定义表头
        HSSFRow activitySheetRow = activitySheet.createRow(0);

        for (int i = 0; i < activityColumnsName.length; i++) {
//            创建一个列
            activitySheetRow.createCell(i).setCellValue(activityColumnsName[i]);
        }
//        填充数据
        Activity activity = null;
        if (activities != null && activities.size() > 0) { // 如果为空就不能遍历，防止出现空指针异常
            for (int i = 1; i < activities.size() + 1; i++) { // 加一保证能遍历完所有的activity
                activitySheetRow = activitySheet.createRow(i); // 创建每一个activity 对应的行
                activity = activities.get(i - 1);  // 取到对应的索引处的activity
                String[] s = activity.toString().split("&&");
                for (int j = 0; j < s.length; j++) {
                    activitySheetRow.createCell(j).setCellValue(s[j]);
                }
            }
        }
        return wbJob;
    }
//      解析Excel文件
    public static List<Activity> getActivityList(InputStream inputStream,String createBy) throws IOException {
        List<Activity> list = new ArrayList<>();
        HSSFWorkbook wbJob = new HSSFWorkbook(inputStream);  // 接收文件
//      先将行和列定义出来
        HSSFRow sheetAtRow = null;
        HSSFCell cell = null;
        Activity activity =null;
            HSSFSheet sheetAt = wbJob.getSheetAt(0);

            for (int j = 1; j <= sheetAt.getLastRowNum(); j++) {
                // sheetAt.getLastRowNum() 获取最后一行的下标
                sheetAtRow = sheetAt.getRow(j);
                //if (sheetAtRow.getLastCellNum() != 1) break;  // 不是十行说明数据格式不对应。直接返回

                // 保存数据的时候，可能用户没有提供id ，那么就要自动生成一个
                // 用户填的是id 。但是我们数据库存的是id  、、 为了对应ID。我们只能使用一个固定的id，比如说是专门的导入者的id
                // 修改者
                // 创建者
                activity = new Activity(UUIDUtils.createUUID(),"abcd",
                        sheetAtRow.getCell(2).getStringCellValue(),sheetAtRow.getCell(3).getStringCellValue(),
                        sheetAtRow.getCell(4).getStringCellValue(),sheetAtRow.getCell(5).getStringCellValue(),
                        sheetAtRow.getCell(6).getStringCellValue(),sheetAtRow.getCell(7).getStringCellValue(),
                        createBy,sheetAtRow.getCell(9).getStringCellValue(),
                        sheetAtRow.getCell(10).getStringCellValue());  // 装载数据
                /*for (int k = 0; k < sheetAtRow.getLastCellNum(); k++) {
                    // sheetAtRow.getLastCellNum() 最后一列的编号加一。
                     // 获取到了每一列
                    String stringCellValue = sheetAtRow.getCell(k).getStringCellValue();
                    // 因为我们知道一定是字符串，不是的话就有问题。
//                    一般获取方式是
                    *//*if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
//                        说明是string
                        System.out.println(cell.getStringCellValue());
                    }*//*
                }*/
                list.add(activity);
            }

        return list;
    }
}
