# batch_run.py
# -*- coding: utf-8 -*-
"""
批量处理 our_ast 与 normal_ast：
对于 OUR_ASTs/<name>.json 与 NORMAL_ASTs/<name>.json，
生成报告到 my_output/<name>/
"""
import os
import glob
import json
import argparse
import pandas as pd  # 用于生成 Excel
from main import main


def run_batch(our_dir: str, normal_dir: str, out_root: str, heatmap: bool=False):
    os.makedirs(out_root, exist_ok=True)

    # 按名称排序遍历 our_dir 下的所有条目（保证 test1, test2 ... 顺序）
    for entry in sorted(os.listdir(our_dir)):
        our_path = os.path.join(our_dir, entry)
        normal_path = os.path.join(normal_dir, entry)

        # 准备用于匹配的 JSON 文件路径
        our_json = None
        normal_json = None
        base = entry

        # —— 情况 A: 直接文件 our_dir/test1.json ——
        if os.path.isfile(our_path) and our_path.lower().endswith(".json"):
            # 要求 normal_dir 下也有同名 .json 文件
            cand = os.path.join(normal_dir, entry)
            if os.path.isfile(cand):
                our_json = our_path
                normal_json = cand

        # 跳过无效条目
        if not our_json or not normal_json:
            continue

        # 输出子目录名用 base（去掉 .json 扩展）
        base = os.path.splitext(base)[0]
        out_dir = os.path.join(out_root, base)

        print(f"\n=== Processing case '{base}' ===")
        args = {
            "our_ast":    our_json,
            "normal_ast": normal_json,
            "out_dir":    out_dir,
            "heatmap":    heatmap
        }
        main(args)

        # 所有 case 处理完毕后，生成汇总 Excel
        generate_aggregate_excel(out_root)


def generate_aggregate_excel(out_root: str):
    """
    扫描 out_root 下各子目录的 summary.json，
    汇总其中的 similarity_score 等字段，生成 Excel 报表。
    """
    records = []
    for case in sorted(os.listdir(out_root)):
        summary_path = os.path.join(out_root, case, "summary.json")
        if not os.path.isfile(summary_path):
            continue
        with open(summary_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        data["case"] = case
        records.append(data)

    if not records:
        print("No summary.json files found; skipping aggregate report.")
        return

    df = pd.DataFrame.from_records(records)
    # 将 case 字段放到最前
    cols = ["case"] + [c for c in df.columns if c != "case"]
    df = df[cols]

    excel_path = os.path.join(out_root, "aggregate_summary.xlsx")
    df.to_excel(excel_path, index=False)
    print(f"\nAggregate summary Excel written to: {excel_path}")


if __name__ == "__main__":
    our_dir = r"C:\Users\lijiale\Desktop\ArkTS\AST相似度算法\AST_compare\Enre-ASTs"
    normal_dir = r"C:\Users\lijiale\Desktop\ArkTS\AST相似度算法\AST_compare\Ark-ASTs"
    out_root = r"C:\Users\lijiale\Desktop\ArkTS\AST相似度算法\my_output\batch_run"
    heatmap = True

    run_batch(our_dir, normal_dir, out_root, heatmap)
