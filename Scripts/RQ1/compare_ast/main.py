# main.py
# -*- coding: utf-8 -*-
"""
Command-line entry: Load ASTs, normalize, match, compute similarity, generate report, and optionally plot heatmap.
Supports both direct call via args_dict and standard command-line usage.
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
    # New: If a dict is passed in, construct args from it; otherwise use argparse as usual.
    # -------------------------------------------------------------------------
    parser = argparse.ArgumentParser(
        description="Compute similarity between two ASTs and generate a detailed report"
    )
    parser.add_argument("our_ast", help="Path to the custom AST file (our_ast.json)")
    parser.add_argument("normal_ast", help="Path to the reference AST file (normal_ast.json)")
    parser.add_argument("-o", "--out_dir", default="output", help="Output directory for the report")
    parser.add_argument("--heatmap", action="store_true",
                        help="Whether to generate a heatmap (requires matplotlib)")

    if isinstance(cli_args, dict):
        # Construct Namespace directly from dictionary
        args = argparse.Namespace(**cli_args)
    elif cli_args is None:
        # Parse arguments from command line
        args = parser.parse_args()
    else:
        # Allow pre-constructed Namespace
        args = cli_args

    # -------------------------------------------------------------------------
    # Original workflow remains unchanged
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
    # — Option 1: Call from command line —
    # main()

    # — Option 2: Hardcoded parameters in code —
    # Just uncomment the following line to run:
    args = {
        "our_ast": r"C:\Users\lijiale\Desktop\ArkTS\our_ast.json",
        "normal_ast": r"C:\Users\lijiale\Desktop\ArkTS\normal_ast.json",
        "out_dir": r"C:\Users\lijiale\Desktop\ArkTS\my_output\11",
        "heatmap": True
    }
    main(args)
