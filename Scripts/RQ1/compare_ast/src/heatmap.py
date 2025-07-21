# src/heatmap.py
# -*- coding: utf-8 -*-
"""
heatmap.py: 将相似度置信度矩阵渲染为热力图（PNG/SVG）。
"""

import os
import numpy as np
import matplotlib.pyplot as plt


class HeatmapPlotter:
    @staticmethod
    def plot(matrix: np.ndarray, out_path: str):
        """
        渲染 heatmap：
          - matrix: shape (N_our, N_normal)
          - out_path: 输出文件路径，后缀决定格式（.png/.svg 等）
        """
        # 创建画布
        plt.figure()
        plt.imshow(matrix, aspect='auto')
        plt.colorbar()
        plt.title("AST Similarity Heatmap")
        plt.xlabel("Normal AST Node UID")
        plt.ylabel("Our AST Node UID")
        # 保存并关闭
        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        plt.savefig(out_path, bbox_inches='tight')
        plt.close()
