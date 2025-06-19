# 这是一个bash脚本，用于批量重命名当前目录下的图片文件

i=1 # 初始化一个计数器
prefix="image_" # 设置新文件名的前缀

# 遍历所有常见格式的图片文件（包括大小写后缀）
for filename in *.jpg *.jpeg *.png *.JPG *.JPEG *.PNG; do

  # 检查文件是否存在，以避免在没有某种类型文件时出错
  if [ -f "$filename" ]; then

    # 提取文件的扩展名 (例如 .jpg)
    ext="${filename##*.}"

    # 生成新的文件名，格式为 image_0001.jpg, image_0002.jpg ...
    # %04d 表示一个4位数的数字，不足4位的前面补0
    new_name=$(printf "%s%04d.%s" "$prefix" "$i" "$(echo $ext | tr '[:upper:]' '[:lower:]')")

    # 执行重命名操作
    mv "$filename" "$new_name"

    # 打印操作日志，让您看到发生了什么
    echo "已重命名 '$filename' -> '$new_name'"

    # 计数器加一
    i=$((i+1))
  fi
done

echo "批量重命名完成！"
