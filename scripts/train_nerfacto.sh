conda create -n nerfstudio python=3.10 -y
conda activate nerfstudio
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
pip install nerfstudio
pip install --upgrade "numpy<2.0"
conda install -c conda-forge ffmpeg -

数据处理
ns-process-data images --data /mnt/data/jichuan/my_3d_project2/images --output-dir /mnt/data/jichuan/my_3d_project2 

模型训练
ns-train nerfacto \
    --data /mnt/data/jichuan/my_3d_project2 \
    --max-num-iterations 30000 \
    --pipeline.model.camera-optimizer.mode "SO3xR3" \
    --viewer.quit-on-train-completion True \
    --pipeline.model.disable-scene-contraction True \
    nerfstudio-data \
    --downscale-factor 1

渲染环绕视频
ns-render spiral \
    --load-config /mnt/data/jichuan/outputs/my_3d_project2/nerfacto/2025-06-18_035930/config.yml \
    --output-path /mnt/data/jichuan/outputs/my_3d_project2/nerfacto/renders/my_video.mp4

定量评估
ns-eval \
    --load-config /mnt/data/jichuan/outputs/my_3d_project2/nerfacto/2025-06-18_035930/config.yml \
    --output-path /mnt/data/jichuan/outputs/my_3d_project2/nerfacto/results/my_eval_metrics.json
