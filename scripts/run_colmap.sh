特征提取:
colmap feature_extractor --database_path /mnt/data/jichuan/my_3d_project/database.db --image_path /mnt/data/jichuan/my_3d_project/images
特征匹配:
colmap exhaustive_matcher --database_path /mnt/data/jichuan/my_3d_project/database.db
稀疏重建:
mkdir /mnt/data/jichuan/my_3d_project/sparse
colmap mapper --database_path /mnt/data/jichuan/my_3d_project/database.db --image_path /mnt/data/jichuan/my_3d_project/images --output_path /mnt/data/jichuan/my_3d_project/sparse
运行LLFF转换poses_bounds.npy：
cd /mnt/data/jichuan
git clone https://github.com/Fyusion/LLFF.git
cd /mnt/data/jichuan/LLFF
python imgs2poses.py /mnt/data/jichuan/my_3d_project
