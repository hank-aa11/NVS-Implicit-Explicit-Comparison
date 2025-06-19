# A Comparative Analysis of Implicit and Explicit Representations for Novel View Synthesis
### A Case Study of NeRF, Nerfacto, and 3D Gaussian Splatting

This project conducts a comprehensive comparative analysis of three landmark Novel View Synthesis (NVS) technologies, representing purely implicit (classic NeRF), hybrid (Nerfacto), and purely explicit (3D Gaussian Splatting) paradigms. Using 162 real-world photographs of a potted plant, we evaluate each method on quantitative metrics, qualitative visual fidelity, and computational efficiency.

---

## 摘要 (Abstract)

This report provides a rigorous comparative analysis of three key Novel View Synthesis (NVS) techniques. The core task involved the 3D reconstruction of a "potted plant" object using 162 multi-angle photographs. We conducted a comprehensive evaluation of the performance of these three methods using quantitative metrics (PSNR, SSIM, LPIPS), qualitative visual fidelity, and computational efficiency. The primary conclusion is that 3D Gaussian Splatting demonstrated superior performance in rendering quality, detail preservation, and training/inference speed for this task. Furthermore, an in-depth analysis of the visual artifacts produced by each method reveals the fundamental trade-offs inherent in their respective architectural designs.

---

## 主要结果 (Key Results)

### 定量评估 (Quantitative Evaluation)

| Method                  | PSNR (dB) ↑        | SSIM ↑             | LPIPS ↓            |
| ----------------------- | ------------------ | ------------------ | ------------------ |
| Classic NeRF            | 26.31              | 0.854              | 0.248              |
| Nerfacto                | 27.85              | 0.882              | 0.207              |
| **3D Gaussian Splatting** | **29.14** | **0.903** | **0.175** |

### 效率对比 (Efficiency Comparison)

| Metric              | Classic NeRF            | Nerfacto                     | 3D Gaussian Splatting        |
| ------------------- | ----------------------- | ---------------------------- | ---------------------------- |
| **Training Time** | ~30 hours               | ~40 minutes                  | **~10 minutes** |
| **Rendering Speed** | <1 FPS (Offline)        | ~5-15 FPS (Interactive)      | **>100 FPS (Real-time)** |

---

## 环境与设置 (Environment & Setup)

### 硬件 (Hardware)
All experiments were conducted on a workstation with the following specifications:
* **GPU:** NVIDIA RTX A6000 (48 GB VRAM)
* **CUDA Version:** 12.6

### 软件依赖 (Software Dependencies)
This project relies on three main frameworks. Please install them following their official instructions.

1.  **Classic NeRF:** [yenchenlin/nerf-pytorch](https://github.com/yenchenlin/nerf-pytorch)
2.  **Nerfacto:** [nerfstudio-project/nerfstudio](https://github.com/nerfstudio-project/nerfstudio)
3.  **3D Gaussian Splatting:** [graphdeco-inria/gaussian-splatting](https://github.com/graphdeco-inria/gaussian-splatting)

It is recommended to use `conda` to create separate virtual environments for each framework to avoid dependency conflicts.

```bash
# 示例：为 nerfstudio 创建环境
conda create -n nerfstudio python=3.10 -y
conda activate nerfstudio
pip install torch torchvision torchaudio --index-url [https://download.pytorch.org/whl/cu118](https://download.pytorch.org/whl/cu118)
pip install nerfstudio
pip install --upgrade "numpy<2.0"
conda install -c conda-forge ffmpeg
```

---

## 复现指南 (Replication Guide)

### 1. 数据准备 (Data Preparation)

The raw dataset consists of 162 images of a potted plant, which are not included in this repository due to size limitations. You can use your own image set.

**(a) 图像预处理 (Image Pre-processing)**

Place your images in a directory (e.g., `data/my_project/images`). It is recommended to rename them sequentially and ensure they have a consistent resolution.

**(b) 相机姿态估计 (Camera Pose Estimation with COLMAP)**

We use COLMAP to estimate camera poses.

```bash
# 特征提取
colmap feature_extractor --database_path data/my_project/database.db --image_path data/my_project/images

# 特征匹配
colmap exhaustive_matcher --database_path data/my_project/database.db

# 稀疏重建
mkdir data/my_project/sparse
colmap mapper \
    --database_path data/my_project/database.db \
    --image_path data/my_project/images \
    --output_path data/my_project/sparse
```

**(c) 数据格式转换 (Data Format Conversion)**

* **For Classic NeRF (nerf-pytorch):**
    Use the LLFF `imgs2poses.py` script to generate `poses_bounds.npy`.
    ```bash
    git clone [https://github.com/Fyusion/LLFF.git](https://github.com/Fyusion/LLFF.git)
    python LLFF/imgs2poses.py data/my_project
    ```
    Then, place the `images` folder and the `poses_bounds.npy` file into the `nerf-pytorch/data/my_scene` directory.

* **For Nerfacto & 3DGS:**
    Use the `nerfstudio` command-line tool. This will create a `transforms.json` file.
    ```bash
    ns-process-data images --data data/my_project/images --output-dir data/my_project_processed
    ```

### 2. 模型训练与评估 (Model Training & Evaluation)

Below are the exact commands used in the paper.

#### (a) Classic NeRF

```bash
# 进入 nerf-pytorch 目录
cd nerf-pytorch

# 训练模型
python run_nerf.py \
    --expname plant_final_high_quality \
    --basedir ./logs \
    --datadir ./data/my_scene \
    --dataset_type llff \
    --no_ndc \
    --spherify \
    --factor 2 \
    --netdepth 8 \
    --netwidth 256 \
    --netdepth_fine 8 \
    --netwidth_fine 256 \
    --N_rand 1024 \
    --N_samples 128 \
    --N_importance 256 \
    --use_viewdirs \
    --lrate 5e-4 \
    --lrate_decay 250 \
    --llffhold 8 \
    --i_print 100 \
    --i_img 1000 \
    --i_weights 10000 \
    --i_testset 50000 \
    --i_video 50000
```

#### (b) Nerfacto (nerfstudio)

```bash
# 训练模型
ns-train nerfacto \
    --data /path/to/your/data/my_project_processed \
    --max-num-iterations 30000 \
    --pipeline.model.camera-optimizer.mode "SO3xR3" \
    --viewer.quit-on-train-completion True \
    --pipeline.model.disable-scene-contraction True \
    nerfstudio-data \
    --downscale-factor 1

# 定量评估
ns-eval \
    --load-config /path/to/outputs/my_project_processed/nerfacto/.../config.yml \
    --output-path /path/to/outputs/nerfacto_eval.json

# 渲染视频
ns-render spiral \
    --load-config /path/to/outputs/my_project_processed/nerfacto/.../config.yml \
    --output-path renders/nerfacto_video.mp4
```

#### (c) 3D Gaussian Splatting

```bash
# 进入 gaussian-splatting 目录
cd gaussian-splatting

# 训练模型 (假设处理后的数据位于 'data/my_project_processed')
python train.py -s data/my_project_processed -m output/plant_model --iterations 30000 --eval
```
*Note: The command line provided in the original log for 3DGS contained many specific parameters. A simplified version is shown here. For a full replication, please refer to the detailed logs in the appendix of the paper.*

---

## 引用 (Citation)

If you use this work, please cite the original papers for the methods evaluated:

```bibtex
@inproceedings{mildenhall2020nerf,
  title={NeRF: Representing Scenes as Neural Radiance Fields for View Synthesis},
  author={Mildenhall, Ben and Srinivasan, Pratul P. and Tancik, Matthew and Barron, Jonathan T. and Ramamoorthi, Ravi and Ng, Ren},
  booktitle={ECCV},
  year={2020}
}

@inproceedings{muller2022instant,
  title={Instant Neural Graphics Primitives with a Multiresolution Hash Encoding},
  author={M{\"u}ller, Thomas and Evans, Alex and Schied, Christoph and Keller, Alexander},
  booktitle={ACM Transactions on Graphics (TOG)},
  year={2022}
}

@article{kerbl20233d,
  title={3D Gaussian Splatting for Real-Time Radiance Field Rendering},
  author={Kerbl, Bernhard and Kopanas, Georgios and Leimk{\"u}hler, Thomas and Drettakis, George},
  journal={ACM Transactions on Graphics (TOG)},
  year={2023}
}
```
