package com.cpy.test;

public class YourTest {
    /* 5.19 1   public int search(int[] nums, int target) {
        int start = 0;
        int end = nums.length - 1;
        int mid = (end - start) / 2;
        while (target > mid) {
            start = mid + 1;
            while (target < mid) {
                end = mid - 1;
                while (target == mid) {
                    return target;
                }
            }
        }
        return 0;
    }*/
  /*public int search(int[] nums, int target) {
      int begin = 0; // 头指针
      int end = nums.length-1; // 尾指针
      int mid = 0;  // 取中间值的下标索引
      while (begin <= end){  //  循环退出的条件是 两个指针交汇
          mid = (begin + end) >> 1;  // 每次循环都取中间处的下标索引
          int midValue = nums[mid];  //  取中间值
          if (midValue < target){  //  情况 :  [1,2,5,7,9]  target= 7
              // 此时 应该取 7 --> 9 (mid 已经判断过了)begin = mid
              begin = mid+1;
          }else if(midValue > target){ //  情况 :  [1,2,5,7,9]  target= 2 此时应该取 1-->2
              end = mid-1;
          }else {
              // target == midValue
              return mid;   // 返回midValue 对应数组位置的索引
          }
      }
//      此时退出循环但是没有退出程序 说明并没有找到 target 应返回-1
      return -1;
  }*/
    public int search(int[] nums, int target) {
        int start = 0;
        int end = nums.length - 1;
        while (start <= end){
            int mid = (start + end) / 2;
            int midz = nums[mid];
            if (target > midz){
                start = mid + 1;
            }
            else if(target < midz){
                end = mid - 1;
            }
            else{
                return mid;
            }
        }
        return -1;
    }
}
