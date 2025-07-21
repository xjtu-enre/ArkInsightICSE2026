# main.py
# -*- coding: utf-8 -*-
"""
命令行入口：加载 AST、规范化、匹配、计算相似度、生成报告并可选绘制热力图
现在支持直接在代码里传入 args_dict 进行调用，或保持从命令行读取。
"""

import os
import argparse

from src.loader import ASTLoader
from src.normalizer import ASTNormalizer
from src.matcher import ASTMatcher
from src.similarity import SimilarityCalculator
from src.report import ReportGenerator
from src.heatmap import HeatmapPlotter


def main(cli_args=None):
    # -------------------------------------------------------------------------
    # 新增：如果传入了一个 dict，就用它构造 args；否则正常使用 argparse
    # -------------------------------------------------------------------------
    parser = argparse.ArgumentParser(
        description="计算 two ASTs 的相似度并生成详细报告"
    )
    parser.add_argument("our_ast", help="路径到自定义 AST 文件(our_ast.json)")
    parser.add_argument("normal_ast", help="路径到官方 AST 文件(normal_ast.json)")
    parser.add_argument("-o", "--out_dir", default="output", help="报告输出目录")
    parser.add_argument("--heatmap", action="store_true",
                        help="是否生成热力图 (依赖 matplotlib)")

    if isinstance(cli_args, dict):
        # 直接用字典构造 Namespace
        args = argparse.Namespace(**cli_args)
    elif cli_args is None:
        # 正常从命令行解析
        args = parser.parse_args()
    else:
        # 如果已经传入 Namespace 也支持
        args = cli_args

    # -------------------------------------------------------------------------
    # 原有流程无改动
    # -------------------------------------------------------------------------
    print("Loading AST files...")
    our_root = ASTLoader.load_from_file(args.our_ast)
    normal_root = ASTLoader.load_from_file(args.normal_ast)

    print("Normalizing ASTs...")
    our_norm = ASTNormalizer.normalize(our_root)
    normal_norm = ASTNormalizer.normalize(normal_root)

    print("Matching AST nodes...")
    matcher = ASTMatcher(our_norm, normal_norm)
    match_result = matcher.match()

    print("Calculating similarity score...")
    score = SimilarityCalculator.compute_score(match_result)
    print(f"Overall similarity score: {score:.4f}")

    print(f"Generating reports in '{args.out_dir}'...")
    ReportGenerator.generate(match_result, score, args.out_dir)

    if args.heatmap:
        print("Plotting heatmap...")
        matrix = match_result.confidence_matrix
        heatmap_path = os.path.join(args.out_dir, "heatmap.png")
        HeatmapPlotter.plot(matrix, heatmap_path)
        print(f"Heatmap saved to {heatmap_path}")

    print("Done.")


if __name__ == "__main__":
    # —— 方式一：直接从命令行调用 ——
    # main()

    # —— 方式二：在代码里硬编码参数 ——
    # 只需取消下面一行的注释即可，用例：
    args = {
        "our_ast": r"C:\Users\lijiale\Desktop\ArkTS\AST相似度算法\our_ast.json",
        "normal_ast": r"C:\Users\lijiale\Desktop\ArkTS\AST相似度算法\normal_ast.json",
        "out_dir": r"C:\Users\lijiale\Desktop\ArkTS\AST相似度算法\my_output\11",
        "heatmap": True
    }
    main(args)
