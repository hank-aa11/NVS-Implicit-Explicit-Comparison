import os
from PIL import Image
import collections

# --- 请在这里修改您的图像文件夹路径 ---
image_folder = '/mnt/data/jichuan/my_3d_project/images'
# ------------------------------------

print(f"开始检查文件夹: {image_folder}")

sizes = collections.defaultdict(list)

try:
    for filename in sorted(os.listdir(image_folder)):
        if filename.lower().endswith(('.png', '.jpg', '.jpeg')):
            try:
                with Image.open(os.path.join(image_folder, filename)) as img:
                    sizes[img.size].append(filename)
            except Exception as e:
                print(f"无法读取文件: {filename}, 错误: {e}")

    if not sizes:
        print("错误：在文件夹中没有找到任何图片。")
    else:
        print("\n--- 检查结果 ---")
        if len(sizes) == 1:
            size, files = list(sizes.items())[0]
            print(f"恭喜！所有 {len(files)} 张图片的尺寸都相同: {size}")
        else:
            print(f"警告！发现了 {len(sizes)} 种不同的图片尺寸。请处理尺寸不一致的图片。")
            for size, files in sizes.items():
                print(f"\n尺寸: {size} (共 {len(files)} 张)")
                # 只打印前5张作为示例
                for f in files[:5]:
                    print(f"  - {f}")
                if len(files) > 5:
                    print(f"  - ... (及其他 {len(files) - 5} 张)")

except FileNotFoundError:
    print(f"错误：找不到文件夹路径 '{image_folder}'。请确认路径是否正确。")
