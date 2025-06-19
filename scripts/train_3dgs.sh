git clone https://github.com/graphdeco-inria/gaussian-splatting.git --recursive
cd gaussian-splatting
conda env create --file environment.yml
conda activate gaussian_splatting

3DGS训练模型
python train.py \
    -s /mnt/data/jichuan/my_3d_project3 \
    -m /mnt/data/jichuan/my_3d_project3/model_output_final_1 \
    --iterations 30000 \
    --eval \
    -r 8 \
    --densify_until_iter 10000 \
    --densify_grad_threshold 0.0005 \
    --sh_degree 2 \
    --optimizer_type sparse_adam \
    --exposure_lr_init 0.001 \
    --exposure_lr_final 0.0001 \
    --exposure_lr_delay_steps 5000 \
    --exposure_lr_delay_mult 0.001 \
    --train_test_exp \
    --test_iterations 5 3000 6000 9000 12000 15000 18000 21000 24000 27000 30000

3DGS渲染视频
python render.py -m /mnt/data/jichuan/my_3d_project3/model_output_final_1

3DGS定量评估
python metrics.py -m /mnt/data/jichuan/my_3d_project3/model_output_final_1
