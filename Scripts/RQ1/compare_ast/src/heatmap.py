# src/heatmap.py
# -*- coding: utf-8 -*-
"""
heatmap.py: Render similarity confidence matrix as heatmap (PNG/SVG).
"""

import os
import numpy as np
import matplotlib.pyplot as plt


class HeatmapPlotter:
    @staticmethod
    def plot(matrix: np.ndarray, out_path: str):
        """
        Render heatmap:
          - matrix: shape (N_our, N_normal)
          - out_path: output file path, suffix determines format (.png/.svg etc.)
        """
        # Create canvas
        plt.figure()
        plt.imshow(matrix, aspect='auto')
        plt.colorbar()
        plt.title("AST Similarity Heatmap")
        plt.xlabel("Normal AST Node UID")
        plt.ylabel("Our AST Node UID")
        # Save and close
        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        plt.savefig(out_path, bbox_inches='tight')
        plt.close()
