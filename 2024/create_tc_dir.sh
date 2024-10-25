#!/bin/bash

# 檢查是否輸入足夠參數
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 HW幾 總共有幾題"
  exit 1
fi

HW=$1      # HW幾
TOTAL=$2   # 總共有幾題

# 創建資料夾
folder_name="/share/HW${HW}_TC"
mkdir -p "$folder_name"

# 從 pA 到 pX 創建題目資料夾
for (( i=0; i<TOTAL; i++ )); do
  # 根據 ASCII 編碼計算題號 pA, pB, pC...
	topic="p$(awk "BEGIN { printf \"%c\", 65 + $i }")"  
# 創建題目資料夾
  topic_dir="$folder_name/$topic"
  mkdir -p "$topic_dir"
  
  # 在每個題目資料夾裡創建 6 個檔案：1.in 1.out 2.in 2.out 3.in 3.out
  for j in {1..3}; do
    touch "$topic_dir/$j.in"
    touch "$topic_dir/$j.out"
  done
done

echo "資料夾和檔案已經成功創建在 $folder_name"
