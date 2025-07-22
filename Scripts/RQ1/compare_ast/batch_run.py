# batch_run.py
# -*- coding: utf-8 -*-
"""
Batch processing of our_ast and normal_ast:
For OUR_ASTs/<name>.json and NORMAL_ASTs/<name>.json,
generate reports in my_output/<name>/
"""
import os
import glob
import json
import argparse
import pandas as pd  # For generating Excel report
from main import main


def run_batch(our_dir: str, normal_dir: str, out_root: str, heatmap: bool = False):
    os.makedirs(out_root, exist_ok=True)

    # Sort and iterate over all entries in our_dir (to ensure test1, test2, ... order)
    for entry in sorted(os.listdir(our_dir)):
        our_path = os.path.join(our_dir, entry)
        normal_path = os.path.join(normal_dir, entry)

        # Prepare JSON file paths for comparison
        our_json = None
        normal_json = None
        base = entry

        # — Case A: A single JSON file such as our_dir/test1.json —
        if os.path.isfile(our_path) and our_path.lower().endswith(".json"):
            # A matching .json file must exist in normal_dir
            cand = os.path.join(normal_dir, entry)
            if os.path.isfile(cand):
                our_json = our_path
                normal_json = cand

        # Skip invalid entries
        if not our_json or not normal_json:
            continue

        # Use filename without extension as output subdirectory name
        base = os.path.splitext(base)[0]
        out_dir = os.path.join(out_root, base)

        print(f"\n=== Processing case '{base}' ===")
        args = {
            "our_ast": our_json,
            "normal_ast": normal_json,
            "out_dir": out_dir,
            "heatmap": heatmap
        }
        main(args)

    # Generate aggregate Excel report after processing all cases
    generate_aggregate_excel(out_root)


def generate_aggregate_excel(out_root: str):
    """
    Scan all subdirectories under out_root for summary.json,
    collect fields like similarity_score, and export as Excel report.
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
    # Move 'case' column to the front
    cols = ["case"] + [c for c in df.columns if c != "case"]
    df = df[cols]

    excel_path = os.path.join(out_root, "aggregate_summary.xlsx")
    df.to_excel(excel_path, index=False)
    print(f"\nAggregate summary Excel written to: {excel_path}")


if __name__ == "__main__":
    our_dir = r"C:\Users\lijiale\Desktop\ArkTS\AST_compare\ArkInsight-ASTs"
    normal_dir = r"C:\Users\lijiale\Desktop\ArkTS\AST_compare\ArkAnalyzer-ASTs"
    out_root = r"C:\Users\lijiale\Desktop\ArkTS\my_output\batch_run"
    heatmap = True

    run_batch(our_dir, normal_dir, out_root, heatmap)
