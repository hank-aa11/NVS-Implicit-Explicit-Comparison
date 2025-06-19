import os
from PIL import Image

# --- 配置参数 ---
# 源图像文件夹
SOURCE_FOLDER = '/mnt/data/jichuan/my_3d_project/images'
# 处理后图像的目标文件夹
DEST_FOLDER = '/mnt/data/jichuan/my_3d_project/images_resized'
# 统一的目标尺寸 (宽度, 高度)。1024x768 是一个兼顾速度和质量的常用尺寸
TARGET_SIZE = (1024, 768)
# ----------------

print(f"开始处理图像，目标尺寸: {TARGET_SIZE}")

if not os.path.exists(DEST_FOLDER):
    os.makedirs(DEST_FOLDER)

file_list = sorted(os.listdir(SOURCE_FOLDER))
total_files = len(file_list)

for i, filename in enumerate(file_list):
    if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
        source_path = os.path.join(SOURCE_FOLDER, filename)
        dest_path = os.path.join(DEST_FOLDER, filename)

        try:
            with Image.open(source_path) as img:
                # 使用高质量的LANCZOS算法进行缩放
                resized_img = img.resize(TARGET_SIZE, Image.Resampling.LANCZOS)
                resized_img.save(dest_path)
                print(f"({i+1}/{total_files}) 已处理: {filename} -> {dest_path}")
        except Exception as e:
            print(f"处理文件失败: {filename}, 错误: {e}")

print("\n所有图像尺寸已统一！")
